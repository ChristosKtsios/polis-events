import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../features/auth/screens/sign_in_screen.dart';
import '../../features/auth/screens/sign_up_screen.dart';
import '../../features/events/screens/event_detail_screen.dart';
import '../../features/home/screens/category_screen.dart';
import '../../features/home/screens/main_scaffold.dart';
import '../../features/home/screens/subcategory_places_screen.dart';
import '../../features/places/screens/place_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/profile/screens/settings_screen.dart';

GoRouter buildRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: _BlocListenable(authBloc.stream),
    redirect: (context, state) {
      final authState = authBloc.state;
      final status = authState.status;

      // Περίμενε να γίνει initialized
      if (status == AuthStatus.unknown) return null;

      final isAuthRoute = state.matchedLocation == '/signin' ||
          state.matchedLocation == '/signup';

      // ΑΛΛΑΓΗ: ΟΛΟΙ (anonymous + authenticated) μπορούν να μπουν στο home.
      // Αν είναι σε auth screen και είναι ήδη authenticated, στείλ' τον στο home.
      if (status == AuthStatus.authenticated && isAuthRoute) {
        return '/';
      }

      // Anonymous και authenticated επιτρέπεται παντού
      return null;
    },
    routes: [
      GoRoute(
        path: '/signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainScaffold(),
        routes: [
          GoRoute(
            path: 'event/:id',
            builder: (context, state) =>
                EventDetailScreen(eventId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'place/:id',
            builder: (context, state) =>
                PlaceDetailScreen(placeId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: 'category/:id',
            builder: (context, state) => CategoryScreen(
              categoryId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: 'category/:catId/sub/:subId',
            builder: (context, state) => SubcategoryPlacesScreen(
              categoryId: state.pathParameters['catId']!,
              subcategoryId: state.pathParameters['subId']!,
            ),
          ),
          GoRoute(
            path: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
}

class _BlocListenable extends ChangeNotifier {
  _BlocListenable(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }

  StreamSubscription<dynamic>? _sub;

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
