import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/locale/locale_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/preferences_service.dart';

class PolisEventsApp extends StatelessWidget {
  final PreferencesService prefs;
  const PolisEventsApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthService>(create: (_) => AuthService()),
        RepositoryProvider<PreferencesService>.value(value: prefs),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (ctx) => AuthBloc(ctx.read<AuthService>())
              ..add(const AuthSubscriptionRequested()),
          ),
          BlocProvider<LocaleBloc>(
            create: (ctx) => LocaleBloc(ctx.read<PreferencesService>())
              ..add(const LocaleInitialized()),
          ),
        ],
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatefulWidget {
  const _AppView();

  @override
  State<_AppView> createState() => _AppViewState();
}

class _AppViewState extends State<_AppView> {
  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();

    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, localeState) {
        return MaterialApp.router(
          title: 'Polis Events',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          locale: localeState.locale,
          supportedLocales: const [Locale('el'), Locale('en')],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          routerConfig: buildRouter(authBloc),
        );
      },
    );
  }
}
