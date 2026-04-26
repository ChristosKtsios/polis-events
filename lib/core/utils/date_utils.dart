import 'package:flutter/material.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';
import 'package:intl/intl.dart';

/// Βοηθητικές συναρτήσεις για ημερομηνίες.
class DateUtils {
  DateUtils._();

  /// Formattάρει μια ημερομηνία event με βάση το locale.
  /// π.χ. "Σάβ 14 Μαρ · 21:00" στα ελληνικά.
  static String formatEventDate(DateTime date, String locale) {
    final formatter = DateFormat('EEE d MMM', locale);
    final timeFormatter = DateFormat('HH:mm', locale);
    final datePart = formatter.format(date);
    final timePart = timeFormatter.format(date);
    return '$datePart · $timePart';
  }

  static String formatDayName(int weekday, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (weekday) {
      case DateTime.monday:
        return l10n.monday;
      case DateTime.tuesday:
        return l10n.tuesday;
      case DateTime.wednesday:
        return l10n.wednesday;
      case DateTime.thursday:
        return l10n.thursday;
      case DateTime.friday:
        return l10n.friday;
      case DateTime.saturday:
        return l10n.saturday;
      case DateTime.sunday:
        return l10n.sunday;
      default:
        return '';
    }
  }

  /// Επιστρέφει "Σήμερα", "Αύριο" ή το όνομα της ημέρας.
  static String smartDayLabel(DateTime date, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diffDays = target.difference(today).inDays;

    if (diffDays == 0) return l10n.today;
    if (diffDays == 1) return l10n.tomorrow;
    return formatDayName(date.weekday, context);
  }

  static String greetingForTime(DateTime time, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (time.hour < 12) return l10n.greetingMorning;
    if (time.hour < 18) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }
}
