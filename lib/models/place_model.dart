import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'category.dart';
import 'localized_text.dart';

/// Ωράριο μιας ημέρας. `null` intervals = κλειστά.
class DayHours extends Equatable {
  final String? openTime;   // "08:30"
  final String? closeTime;  // "16:00"
  final bool closed;

  const DayHours({this.openTime, this.closeTime, this.closed = false});

  Map<String, dynamic> toMap() => {
        'openTime': openTime,
        'closeTime': closeTime,
        'closed': closed,
      };

  factory DayHours.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const DayHours(closed: true);
    return DayHours(
      openTime: map['openTime']?.toString(),
      closeTime: map['closeTime']?.toString(),
      closed: map['closed'] == true,
    );
  }

  @override
  List<Object?> get props => [openTime, closeTime, closed];
}

/// Ωράριο λειτουργίας για όλη τη βδομάδα.
class OpeningHours extends Equatable {
  final DayHours monday;
  final DayHours tuesday;
  final DayHours wednesday;
  final DayHours thursday;
  final DayHours friday;
  final DayHours saturday;
  final DayHours sunday;

  const OpeningHours({
    this.monday = const DayHours(closed: true),
    this.tuesday = const DayHours(closed: true),
    this.wednesday = const DayHours(closed: true),
    this.thursday = const DayHours(closed: true),
    this.friday = const DayHours(closed: true),
    this.saturday = const DayHours(closed: true),
    this.sunday = const DayHours(closed: true),
  });

  /// Επιστρέφει το DayHours για ένα DateTime (1 = Δευτέρα, 7 = Κυριακή).
  DayHours forDay(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return monday;
      case DateTime.tuesday:
        return tuesday;
      case DateTime.wednesday:
        return wednesday;
      case DateTime.thursday:
        return thursday;
      case DateTime.friday:
        return friday;
      case DateTime.saturday:
        return saturday;
      case DateTime.sunday:
        return sunday;
      default:
        return const DayHours(closed: true);
    }
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

  factory OpeningHours.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const OpeningHours();
    return OpeningHours(
      monday: DayHours.fromMap(map['monday']),
      tuesday: DayHours.fromMap(map['tuesday']),
      wednesday: DayHours.fromMap(map['wednesday']),
      thursday: DayHours.fromMap(map['thursday']),
      friday: DayHours.fromMap(map['friday']),
      saturday: DayHours.fromMap(map['saturday']),
      sunday: DayHours.fromMap(map['sunday']),
    );
  }

  @override
  List<Object?> get props =>
      [monday, tuesday, wednesday, thursday, friday, saturday, sunday];
}

/// Μοντέλο μόνιμου σημείου ενδιαφέροντος.
class Place extends Equatable {
  final String id;
  final LocalizedText name;
  final LocalizedText description;
  final PlaceCategory category;
  final String? organizationId;
  final String cityId;
  final GeoPoint location;
  final LocalizedText address;
  final OpeningHours openingHours;
  final LocalizedText? admissionInfo;
  final double? priceFrom;
  final bool isFree;
  final List<String> images;
  final String? phone;
  final String? website;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final bool published;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Place({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    this.organizationId,
    required this.cityId,
    required this.location,
    required this.address,
    required this.openingHours,
    this.admissionInfo,
    this.priceFrom,
    this.isFree = false,
    this.images = const [],
    this.phone,
    this.website,
    this.tags = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.published = false,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Ελέγχει αν είναι ανοιχτό τώρα.
  bool isOpenNow([DateTime? now]) {
    final d = now ?? DateTime.now();
    final todayHours = openingHours.forDay(d.weekday);
    if (todayHours.closed) return false;
    if (todayHours.openTime == null || todayHours.closeTime == null) {
      return false;
    }
    final open = _parseTime(todayHours.openTime!);
    final close = _parseTime(todayHours.closeTime!);
    if (open == null || close == null) return false;
    final minutesNow = d.hour * 60 + d.minute;
    if (close > open) {
      return minutesNow >= open && minutesNow < close;
    } else {
      return minutesNow >= open || minutesNow < close;
    }
  }

  int? _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    if (parts.length != 2) return null;
    final h = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    if (h == null || m == null) return null;
    return h * 60 + m;
  }

  Map<String, dynamic> toMap() => {
        'name': name.toMap(),
        'description': description.toMap(),
        'category': category.key,
        'organizationId': organizationId,
        'cityId': cityId,
        'location': location,
        'address': address.toMap(),
        'openingHours': openingHours.toMap(),
        'admissionInfo': admissionInfo?.toMap(),
        'priceFrom': priceFrom,
        'isFree': isFree,
        'images': images,
        'phone': phone,
        'website': website,
        'tags': tags,
        'rating': rating,
        'reviewCount': reviewCount,
        'published': published,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  factory Place.fromMap(String id, Map<String, dynamic> map) => Place(
        id: id,
        name: LocalizedText.fromMap(map['name']),
        description: LocalizedText.fromMap(map['description']),
        category: PlaceCategory.fromKey(map['category']?.toString() ?? ''),
        organizationId: map['organizationId']?.toString(),
        cityId: map['cityId']?.toString() ?? '',
        location: map['location'] as GeoPoint? ?? const GeoPoint(0, 0),
        address: LocalizedText.fromMap(map['address']),
        openingHours: OpeningHours.fromMap(map['openingHours']),
        admissionInfo: map['admissionInfo'] != null
            ? LocalizedText.fromMap(map['admissionInfo'])
            : null,
        priceFrom: (map['priceFrom'] as num?)?.toDouble(),
        isFree: map['isFree'] == true,
        images: List<String>.from(map['images'] ?? []),
        phone: map['phone']?.toString(),
        website: map['website']?.toString(),
        tags: List<String>.from(map['tags'] ?? []),
        rating: (map['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: (map['reviewCount'] as num?)?.toInt() ?? 0,
        published: map['published'] == true,
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        cityId,
        location,
        published,
      ];
}
