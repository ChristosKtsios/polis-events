/// Ωράριο λειτουργίας επιχείρησης για 7 ημέρες.
class WorkingHours {
  final DayHours monday;
  final DayHours tuesday;
  final DayHours wednesday;
  final DayHours thursday;
  final DayHours friday;
  final DayHours saturday;
  final DayHours sunday;

  const WorkingHours({
    required this.monday,
    required this.tuesday,
    required this.wednesday,
    required this.thursday,
    required this.friday,
    required this.saturday,
    required this.sunday,
  });

  /// Default Δευ-Παρ 09:00-21:00, Σαβ 10:00-22:00, Κυρ κλειστά.
  factory WorkingHours.defaults() {
    return WorkingHours(
      monday: DayHours.open(9, 0, 21, 0),
      tuesday: DayHours.open(9, 0, 21, 0),
      wednesday: DayHours.open(9, 0, 21, 0),
      thursday: DayHours.open(9, 0, 21, 0),
      friday: DayHours.open(9, 0, 22, 0),
      saturday: DayHours.open(10, 0, 22, 0),
      sunday: DayHours.closed(),
    );
  }

  /// Όλη η εβδομάδα κλειστά (placeholder).
  factory WorkingHours.empty() {
    return WorkingHours(
      monday: DayHours.closed(),
      tuesday: DayHours.closed(),
      wednesday: DayHours.closed(),
      thursday: DayHours.closed(),
      friday: DayHours.closed(),
      saturday: DayHours.closed(),
      sunday: DayHours.closed(),
    );
  }

  /// Ώρες σημερινής μέρας.
  DayHours today() {
    return forWeekday(DateTime.now().weekday);
  }

  /// Ώρες για συγκεκριμένη μέρα (1=Δευ, 7=Κυρ).
  DayHours forWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return monday;
      case 2:
        return tuesday;
      case 3:
        return wednesday;
      case 4:
        return thursday;
      case 5:
        return friday;
      case 6:
        return saturday;
      case 7:
        return sunday;
      default:
        return DayHours.closed();
    }
  }

  /// Είναι ανοιχτό τώρα;
  bool isOpenNow() {
    final now = DateTime.now();
    return forWeekday(now.weekday).isOpenAt(now.hour, now.minute);
  }

  Map<String, dynamic> toMap() => {
        'monday': monday.toMap(),
        'tuesday': tuesday.toMap(),
        'wednesday': wednesday.toMap(),
        'thursday': thursday.toMap(),
        'friday': friday.toMap(),
        'saturday': saturday.toMap(),
        'sunday': sunday.toMap(),
      };

  factory WorkingHours.fromMap(Map<String, dynamic> map) => WorkingHours(
        monday: DayHours.fromMap(map['monday'] ?? {}),
        tuesday: DayHours.fromMap(map['tuesday'] ?? {}),
        wednesday: DayHours.fromMap(map['wednesday'] ?? {}),
        thursday: DayHours.fromMap(map['thursday'] ?? {}),
        friday: DayHours.fromMap(map['friday'] ?? {}),
        saturday: DayHours.fromMap(map['saturday'] ?? {}),
        sunday: DayHours.fromMap(map['sunday'] ?? {}),
      );

  WorkingHours copyWith({
    DayHours? monday,
    DayHours? tuesday,
    DayHours? wednesday,
    DayHours? thursday,
    DayHours? friday,
    DayHours? saturday,
    DayHours? sunday,
  }) =>
      WorkingHours(
        monday: monday ?? this.monday,
        tuesday: tuesday ?? this.tuesday,
        wednesday: wednesday ?? this.wednesday,
        thursday: thursday ?? this.thursday,
        friday: friday ?? this.friday,
        saturday: saturday ?? this.saturday,
        sunday: sunday ?? this.sunday,
      );
}

/// Ωράριο μιας ημέρας.
class DayHours {
  final bool closed;
  final int openHour;
  final int openMinute;
  final int closeHour;
  final int closeMinute;

  const DayHours({
    required this.closed,
    required this.openHour,
    required this.openMinute,
    required this.closeHour,
    required this.closeMinute,
  });

  /// Ανοιχτά από ώρα έως ώρα.
  factory DayHours.open(int openH, int openM, int closeH, int closeM) {
    return DayHours(
      closed: false,
      openHour: openH,
      openMinute: openM,
      closeHour: closeH,
      closeMinute: closeM,
    );
  }

  /// Κλειστά όλη μέρα.
  factory DayHours.closed() {
    return const DayHours(
      closed: true,
      openHour: 0,
      openMinute: 0,
      closeHour: 0,
      closeMinute: 0,
    );
  }

  /// Είναι ανοιχτά την συγκεκριμένη ώρα;
  bool isOpenAt(int hour, int minute) {
    if (closed) return false;
    final nowMinutes = hour * 60 + minute;
    final openMinutes = openHour * 60 + openMinute;
    final closeMinutes = closeHour * 60 + closeMinute;
    return nowMinutes >= openMinutes && nowMinutes < closeMinutes;
  }

  /// Format για display.
  String displayText() {
    if (closed) return 'Κλειστά';
    final openStr =
        '${openHour.toString().padLeft(2, '0')}:${openMinute.toString().padLeft(2, '0')}';
    final closeStr =
        '${closeHour.toString().padLeft(2, '0')}:${closeMinute.toString().padLeft(2, '0')}';
    return '$openStr - $closeStr';
  }

  Map<String, dynamic> toMap() => {
        'closed': closed,
        'openHour': openHour,
        'openMinute': openMinute,
        'closeHour': closeHour,
        'closeMinute': closeMinute,
      };

  factory DayHours.fromMap(Map<String, dynamic> map) => DayHours(
        closed: map['closed'] ?? true,
        openHour: map['openHour'] ?? 0,
        openMinute: map['openMinute'] ?? 0,
        closeHour: map['closeHour'] ?? 0,
        closeMinute: map['closeMinute'] ?? 0,
      );
}

/// Ονόματα ημερών για display.
class WeekdayNames {
  static const greekFull = [
    'Δευτέρα',
    'Τρίτη',
    'Τετάρτη',
    'Πέμπτη',
    'Παρασκευή',
    'Σάββατο',
    'Κυριακή'
  ];

  static const greekShort = ['Δευ', 'Τρι', 'Τετ', 'Πεμ', 'Παρ', 'Σαβ', 'Κυρ'];

  static String full(int weekday) => greekFull[weekday - 1];
  static String short(int weekday) => greekShort[weekday - 1];
}
