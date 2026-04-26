import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import '../../services/auth_service.dart';

// ── Events ──────────────────────────────────────────────

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthSubscriptionRequested extends AuthEvent {
  const AuthSubscriptionRequested();
}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInRequested({required this.email, required this.password});
}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });
}

class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  const AuthPasswordResetRequested(this.email);
}

class _AuthUserChanged extends AuthEvent {
  final User? user;
  const _AuthUserChanged(this.user);
}

// ── State ───────────────────────────────────────────────

enum AuthStatus {
  unknown,
  anonymous, // Logged in αλλά anonymous (browse-only)
  authenticated, // Logged in με Google/Email (full access)
  unauthenticated,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final AppUser? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.errorMessage,
    this.isLoading = false,
  });

  /// True αν ο χρήστης είναι "real" (όχι anonymous).
  /// Χρησιμοποιείται για να ελέγχουμε protected actions.
  bool get isRealUser => status == AuthStatus.authenticated;

  AuthState copyWith({
    AuthStatus? status,
    AppUser? user,
    String? errorMessage,
    bool? isLoading,
    bool clearError = false,
    bool clearUser = false,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: clearUser ? null : (user ?? this.user),
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object?> get props => [status, user, errorMessage, isLoading];
}

// ── Bloc ────────────────────────────────────────────────

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;
  StreamSubscription<User?>? _authSub;

  AuthBloc(this._authService) : super(const AuthState()) {
    on<AuthSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<_AuthUserChanged>(_onUserChanged);
  }

  Future<void> _onSubscriptionRequested(
    AuthSubscriptionRequested event,
    Emitter<AuthState> emit,
  ) async {
    _authSub?.cancel();
    _authSub = _authService.authStateChanges().listen(
          (user) => add(_AuthUserChanged(user)),
        );

    // Αν δεν υπάρχει user, κάνε αμέσως anonymous sign-in
    if (_authService.currentUser == null) {
      try {
        await _authService.signInAnonymously();
      } catch (e) {
        emit(state.copyWith(
          status: AuthStatus.error,
          errorMessage: 'Could not start anonymous session: $e',
        ));
      }
    }
  }

  Future<void> _onUserChanged(
    _AuthUserChanged event,
    Emitter<AuthState> emit,
  ) async {
    final firebaseUser = event.user;

    if (firebaseUser == null) {
      // No user - πρέπει να γίνει anonymous sign-in
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        clearUser: true,
        isLoading: false,
      ));
      // Trigger anonymous sign-in
      try {
        await _authService.signInAnonymously();
      } catch (_) {}
      return;
    }

    if (firebaseUser.isAnonymous) {
      // Anonymous user - browse mode
      emit(state.copyWith(
        status: AuthStatus.anonymous,
        user: AppUser(
          uid: firebaseUser.uid,
          email: '',
          displayName: '',
          createdAt: DateTime.now(),
        ),
        isLoading: false,
      ));
      return;
    }

    // Real user - φόρτωσε το user document από Firestore
    try {
      final appUser = await _authService
          .userDocumentStream(firebaseUser.uid)
          .firstWhere((u) => u != null)
          .timeout(const Duration(seconds: 5));

      if (appUser != null) {
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: appUser,
          isLoading: false,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final user = await _authService.signInWithEmail(
        email: event.email,
        password: event.password,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e.code),
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final user = await _authService.signUpWithEmail(
        email: event.email,
        password: event.password,
        displayName: event.displayName,
      );
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      ));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: _mapFirebaseError(e.code),
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final user = await _authService.signInWithGoogle();
      if (user == null) {
        emit(state.copyWith(isLoading: false));
        return;
      }
      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
        isLoading: false,
      ));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authService.signOut();
    // Μετά το signOut θα γίνει αυτόματα anonymous μέσω _onUserChanged
  }

  Future<void> _onPasswordResetRequested(
    AuthPasswordResetRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await _authService.sendPasswordResetEmail(event.email);
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(errorMessage: _mapFirebaseError(e.code)));
    }
  }

  String _mapFirebaseError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Δεν βρέθηκε χρήστης με αυτό το email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Λάθος email ή κωδικός.';
      case 'email-already-in-use':
        return 'Υπάρχει ήδη λογαριασμός με αυτό το email.';
      case 'weak-password':
        return 'Ο κωδικός είναι πολύ αδύναμος.';
      case 'invalid-email':
        return 'Μη έγκυρο email.';
      default:
        return 'Κάτι πήγε στραβά ($code)';
    }
  }

  @override
  Future<void> close() {
    _authSub?.cancel();
    return super.close();
  }
}
