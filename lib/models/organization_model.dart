import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'localized_text.dart';

/// Τύπος οργανισμού.
enum OrganizationType {
  municipality,   // Δήμος
  business,       // Επιχείρηση (μαγαζί, club, εστιατόριο, bar)
  cultural,       // Πολιτιστικός φορέας (μουσείο, θέατρο)
  other;

  static OrganizationType fromKey(String? key) {
    return OrganizationType.values.firstWhere(
      (t) => t.name == key,
      orElse: () => OrganizationType.other,
    );
  }
}

/// Μοντέλο οργανισμού - δήμοι, επιχειρήσεις, πολιτιστικοί φορείς.
class Organization extends Equatable {
  final String id;
  final LocalizedText name;
  final OrganizationType type;
  final String cityId;
  final String? logoUrl;
  final LocalizedText description;
  final String? phone;
  final String? email;
  final String? website;
  final List<String> adminUids;
  final bool approved;
  final DateTime createdAt;

  const Organization({
    required this.id,
    required this.name,
    required this.type,
    required this.cityId,
    this.logoUrl,
    required this.description,
    this.phone,
    this.email,
    this.website,
    this.adminUids = const [],
    this.approved = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'name': name.toMap(),
        'type': type.name,
        'cityId': cityId,
        'logoUrl': logoUrl,
        'description': description.toMap(),
        'phone': phone,
        'email': email,
        'website': website,
        'adminUids': adminUids,
        'approved': approved,
        'createdAt': Timestamp.fromDate(createdAt),
      };

  factory Organization.fromMap(String id, Map<String, dynamic> map) =>
      Organization(
        id: id,
        name: LocalizedText.fromMap(map['name']),
        type: OrganizationType.fromKey(map['type']?.toString()),
        cityId: map['cityId']?.toString() ?? '',
        logoUrl: map['logoUrl']?.toString(),
        description: LocalizedText.fromMap(map['description']),
        phone: map['phone']?.toString(),
        email: map['email']?.toString(),
        website: map['website']?.toString(),
        adminUids: List<String>.from(map['adminUids'] ?? []),
        approved: map['approved'] == true,
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );

  @override
  List<Object?> get props =>
      [id, name, type, cityId, logoUrl, adminUids, approved];
}
