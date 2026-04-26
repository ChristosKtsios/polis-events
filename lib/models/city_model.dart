import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'localized_text.dart';

/// Μοντέλο πόλης.
class City extends Equatable {
  final String id;
  final String slug;
  final LocalizedText name;
  final LocalizedText region;
  final GeoPoint center;
  final double radiusKm;
  final int placesCount;
  final int eventsCount;

  const City({
    required this.id,
    required this.slug,
    required this.name,
    required this.region,
    required this.center,
    this.radiusKm = 10,
    this.placesCount = 0,
    this.eventsCount = 0,
  });

  Map<String, dynamic> toMap() => {
        'slug': slug,
        'name': name.toMap(),
        'region': region.toMap(),
        'center': center,
        'radiusKm': radiusKm,
        'placesCount': placesCount,
        'eventsCount': eventsCount,
      };

  factory City.fromMap(String id, Map<String, dynamic> map) => City(
        id: id,
        slug: map['slug']?.toString() ?? '',
        name: LocalizedText.fromMap(map['name']),
        region: LocalizedText.fromMap(map['region']),
        center: map['center'] as GeoPoint? ?? const GeoPoint(0, 0),
        radiusKm: (map['radiusKm'] as num?)?.toDouble() ?? 10,
        placesCount: (map['placesCount'] as num?)?.toInt() ?? 0,
        eventsCount: (map['eventsCount'] as num?)?.toInt() ?? 0,
      );

  @override
  List<Object?> get props => [id, slug, name, region, center];
}
