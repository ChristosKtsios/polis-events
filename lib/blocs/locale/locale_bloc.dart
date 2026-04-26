import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../services/preferences_service.dart';

// ── Events ──────────────────────────────────────────────

abstract class LocaleEvent extends Equatable {
  const LocaleEvent();
  @override
  List<Object?> get props => [];
}

class LocaleInitialized extends LocaleEvent {
  const LocaleInitialized();
}

class LocaleChanged extends LocaleEvent {
  final Locale locale;
  const LocaleChanged(this.locale);
  @override
  List<Object?> get props => [locale];
}

// ── State ───────────────────────────────────────────────

class LocaleState extends Equatable {
  final Locale locale;
  const LocaleState(this.locale);

  @override
  List<Object?> get props => [locale];
}

// ── Bloc ────────────────────────────────────────────────

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  final PreferencesService _prefs;

  /// Default = Ελληνικά.
  LocaleBloc(this._prefs) : super(const LocaleState(Locale('el'))) {
    on<LocaleInitialized>(_onInitialized);
    on<LocaleChanged>(_onChanged);
  }

  Future<void> _onInitialized(
    LocaleInitialized event,
    Emitter<LocaleState> emit,
  ) async {
    final code = _prefs.languageCode;
    if (code != null && (code == 'el' || code == 'en')) {
      emit(LocaleState(Locale(code)));
    }
  }

  Future<void> _onChanged(
    LocaleChanged event,
    Emitter<LocaleState> emit,
  ) async {
    await _prefs.setLanguageCode(event.locale.languageCode);
    emit(LocaleState(event.locale));
  }
}
