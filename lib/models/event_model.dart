import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'category.dart';
import 'localized_text.dart';

/// Κατάσταση event.
enum EventStatus {
  draft,
  published,
  cancelled,
  ended;

  static EventStatus fromKey(String? key) {
    return EventStatus.values.firstWhere(
      (s) => s.name == key,
      orElse: () => EventStatus.draft,
    );
  }
}

/// Μοντέλο εκδήλωσης (event).
class Event extends Equatable {
  final String id;
  final LocalizedText title;
  final LocalizedText description;
  final EventCategory category;
  final String organizationId;
  final String cityId;

  /// Αν το event φιλοξενείται σε ένα μόνιμο place, εδώ είναι το id του.
  /// Αν είναι σε ελεύθερη τοποθεσία (π.χ. πλατεία), είναι null.
  final String? placeId;

  final DateTime startDate;
  final DateTime endDate;
  final GeoPoint location;
  final LocalizedText address;

  final List<String> images;
  final double? priceFrom;
  final bool isFree;
  final bool ticketRequired;
  final int? capacity;
  final int currentRegistrations;

  final EventStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.organizationId,
    required this.cityId,
    this.placeId,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.address,
    this.images = const [],
    this.priceFrom,
    this.isFree = false,
    this.ticketRequired = false,
    this.capacity,
    this.currentRegistrations = 0,
    this.status = EventStatus.draft,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isUpcoming => startDate.isAfter(DateTime.now());
  bool get isLive =>
      DateTime.now().isAfter(startDate) && DateTime.now().isBefore(endDate);
  bool get isPast => endDate.isBefore(DateTime.now());
  bool get isSoldOut =>
      capacity != null && currentRegistrations >= capacity!;

  Map<String, dynamic> toMap() => {
        'title': title.toMap(),
        'description': description.toMap(),
        'category': category.key,
        'organizationId': organizationId,
        'cityId': cityId,
        'placeId': placeId,
        'startDate': Timestamp.fromDate(startDate),
        'endDate': Timestamp.fromDate(endDate),
        'location': location,
        'address': address.toMap(),
        'images': images,
        'priceFrom': priceFrom,
        'isFree': isFree,
        'ticketRequired': ticketRequired,
        'capacity': capacity,
        'currentRegistrations': currentRegistrations,
        'status': status.name,
        'createdAt': Timestamp.fromDate(createdAt),
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  factory Event.fromMap(String id, Map<String, dynamic> map) => Event(
        id: id,
        title: LocalizedText.fromMap(map['title']),
        description: LocalizedText.fromMap(map['description']),
        category: EventCategory.fromKey(map['category']?.toString() ?? ''),
        organizationId: map['organizationId']?.toString() ?? '',
        cityId: map['cityId']?.toString() ?? '',
        placeId: map['placeId']?.toString(),
        startDate: (map['startDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        endDate: (map['endDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        location: map['location'] as GeoPoint? ?? const GeoPoint(0, 0),
        address: LocalizedText.fromMap(map['address']),
        images: List<String>.from(map['images'] ?? []),
        priceFrom: (map['priceFrom'] as num?)?.toDouble(),
        isFree: map['isFree'] == true,
        ticketRequired: map['ticketRequired'] == true,
        capacity: (map['capacity'] as num?)?.toInt(),
        currentRegistrations:
            (map['currentRegistrations'] as num?)?.toInt() ?? 0,
        status: EventStatus.fromKey(map['status']?.toString()),
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: (map['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        cityId,
        placeId,
        startDate,
        endDate,
        status,
      ];
}
