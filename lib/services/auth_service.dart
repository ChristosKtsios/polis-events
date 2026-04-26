import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_model.dart';

/// Service για Firebase Authentication + Firestore user documents.
/// Υποστηρίζει: Anonymous, Email/Password, Google.
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  /// Επιστρέφει true αν ο χρήστης είναι anonymous.
  bool get isAnonymous => _auth.currentUser?.isAnonymous ?? false;

  /// Επιστρέφει true αν ο χρήστης είναι "real" (όχι anonymous).
  bool get isRealUser =>
      _auth.currentUser != null && !_auth.currentUser!.isAnonymous;

  // ── Anonymous sign-in (αυτόματο στο app start) ────────

  Future<UserCredential> signInAnonymously() {
    return _auth.signInAnonymously();
  }

  // ── Email/Password ─────────────────────────────────────

  /// Εγγραφή με email - upgrade αν είναι anonymous, αλλιώς νέος λογαριασμός.
  Future<AppUser> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final current = _auth.currentUser;

    UserCredential credential;
    if (current != null && current.isAnonymous) {
      // Upgrade anonymous user → permanent
      final emailCred = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      credential = await current.linkWithCredential(emailCred);
    } else {
      credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    }

    await credential.user?.updateDisplayName(displayName);

    final appUser = AppUser(
      uid: credential.user!.uid,
      email: email,
      displayName: displayName,
      createdAt: DateTime.now(),
    );
    await _createOrUpdateUserDocument(appUser);
    return appUser;
  }

  Future<AppUser> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Sign out anonymous αν υπάρχει, για να μπει με τον λογαριασμό
    if (_auth.currentUser?.isAnonymous == true) {
      await _auth.signOut();
    }
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _fetchOrCreateUserDocument(credential.user!);
  }

  // ── Google sign-in ─────────────────────────────────────

  /// Sign in με Google - upgrade αν είναι anonymous.
  Future<AppUser?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final current = _auth.currentUser;
    UserCredential userCredential;

    if (current != null && current.isAnonymous) {
      // Upgrade anonymous → Google
      try {
        userCredential = await current.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        // Αν το Google account υπάρχει ήδη, sign in κανονικά
        if (e.code == 'credential-already-in-use' ||
            e.code == 'email-already-in-use') {
          await _auth.signOut();
          userCredential = await _auth.signInWithCredential(credential);
        } else {
          rethrow;
        }
      }
    } else {
      userCredential = await _auth.signInWithCredential(credential);
    }

    return _fetchOrCreateUserDocument(userCredential.user!);
  }

  // ── Common ─────────────────────────────────────────────

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email);
  }

  /// Sign out - μετά γίνεται ξανά anonymous αυτόματα.
  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }

  Future<void> updateLanguage(String uid, String languageCode) {
    return _firestore
        .collection('users')
        .doc(uid)
        .update({'languageCode': languageCode});
  }

  Stream<AppUser?> userDocumentStream(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? AppUser.fromMap(doc.data()!) : null);
  }

  Future<AppUser> _fetchOrCreateUserDocument(User firebaseUser) async {
    final doc =
        await _firestore.collection('users').doc(firebaseUser.uid).get();
    if (doc.exists) return AppUser.fromMap(doc.data()!);

    final appUser = AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      displayName: firebaseUser.displayName ??
          firebaseUser.email?.split('@').first ??
          '',
      photoUrl: firebaseUser.photoURL,
      createdAt: DateTime.now(),
    );
    await _createOrUpdateUserDocument(appUser);
    return appUser;
  }

  Future<void> _createOrUpdateUserDocument(AppUser user) {
    return _firestore
        .collection('users')
        .doc(user.uid)
        .set(user.toMap(), SetOptions(merge: true));
  }
}
