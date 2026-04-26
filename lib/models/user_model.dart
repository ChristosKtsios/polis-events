import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'working_hours_model.dart';

/// Ρόλοι χρηστών.
enum UserRole {
  user, // Απλός χρήστης
  orgAdmin, // Admin οργανισμού (δήμος/επιχείρηση)
  superAdmin; // Super admin (εγκρίσεις, moderation)

  static UserRole fromKey(String? key) {
    return UserRole.values.firstWhere(
      (r) => r.name == key,
      orElse: () => UserRole.user,
    );
  }
}

/// Τύπος λογαριασμού.
enum AccountType {
  personal, // Απλός χρήστης
  business; // Επαγγελματικός λογαριασμός (έχει επιχείρηση)

  static AccountType fromKey(String? key) {
    return AccountType.values.firstWhere(
      (a) => a.name == key,
      orElse: () => AccountType.personal,
    );
  }
}

/// Status επαγγελματικού λογαριασμού.
enum BusinessStatus {
  pending, // Νέα αίτηση, περιμένει έγκριση
  approved, // Εγκεκριμένος, ενεργός
  rejected, // Απορρίφθηκε
  suspended; // Suspended (αποκλεισμός)

  static BusinessStatus fromKey(String? key) {
    return BusinessStatus.values.firstWhere(
      (s) => s.name == key,
      orElse: () => BusinessStatus.pending,
    );
  }
}

/// Μοντέλο χρήστη.
class AppUser extends Equatable {
  // ── Common fields (όλοι οι χρήστες) ──
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final UserRole role;
  final String? organizationId; // null αν δεν είναι org admin
  final String languageCode; // 'el' ή 'en'
  final String? fcmToken;
  final List<String> savedEvents;
  final List<String> savedPlaces;
  final DateTime createdAt;

  // ── Νέα κοινά πεδία ──
  final String cityId; // Πόλη χρήστη
  final AccountType accountType; // personal ή business

  // ── Business-only πεδία (null για personal) ──
  final String? businessName;
  final String? ownerName;
  final String? phone;
  final String? vatNumber;
  final String? businessAddress;
  final String? businessCategory; // museum, gym, restaurant, κτλ
  final String? logoUrl;
  final String? description;
  final WorkingHours? workingHours;
  final BusinessStatus? businessStatus;
  final String? adminNotes; // Notes από superAdmin

  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.role = UserRole.user,
    this.organizationId,
    this.languageCode = 'el',
    this.fcmToken,
    this.savedEvents = const [],
    this.savedPlaces = const [],
    required this.createdAt,
    this.cityId = 'ioannina',
    this.accountType = AccountType.personal,
    this.businessName,
    this.ownerName,
    this.phone,
    this.vatNumber,
    this.businessAddress,
    this.businessCategory,
    this.logoUrl,
    this.description,
    this.workingHours,
    this.businessStatus,
    this.adminNotes,
  });

  // ── Helper getters ──

  /// Είναι ο χρήστης approved business;
  bool get isApprovedBusiness =>
      accountType == AccountType.business &&
      businessStatus == BusinessStatus.approved;

  /// Είναι ο χρήστης pending business;
  bool get isPendingBusiness =>
      accountType == AccountType.business &&
      businessStatus == BusinessStatus.pending;

  /// Είναι ο χρήστης rejected business;
  bool get isRejectedBusiness =>
      accountType == AccountType.business &&
      businessStatus == BusinessStatus.rejected;

  /// Είναι personal account;
  bool get isPersonal => accountType == AccountType.personal;

  /// Είναι business account (any status);
  bool get isBusiness => accountType == AccountType.business;

  Map<String, dynamic> toMap() => {
        'uid': uid,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'role': role.name,
        'organizationId': organizationId,
        'languageCode': languageCode,
        'fcmToken': fcmToken,
        'savedEvents': savedEvents,
        'savedPlaces': savedPlaces,
        'createdAt': Timestamp.fromDate(createdAt),
        'cityId': cityId,
        'accountType': accountType.name,
        if (businessName != null) 'businessName': businessName,
        if (ownerName != null) 'ownerName': ownerName,
        if (phone != null) 'phone': phone,
        if (vatNumber != null) 'vatNumber': vatNumber,
        if (businessAddress != null) 'businessAddress': businessAddress,
        if (businessCategory != null) 'businessCategory': businessCategory,
        if (logoUrl != null) 'logoUrl': logoUrl,
        if (description != null) 'description': description,
        if (workingHours != null) 'workingHours': workingHours!.toMap(),
        if (businessStatus != null) 'businessStatus': businessStatus!.name,
        if (adminNotes != null) 'adminNotes': adminNotes,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        uid: map['uid']?.toString() ?? '',
        email: map['email']?.toString() ?? '',
        displayName: map['displayName']?.toString() ?? '',
        photoUrl: map['photoUrl']?.toString(),
        role: UserRole.fromKey(map['role']?.toString()),
        organizationId: map['organizationId']?.toString(),
        languageCode: map['languageCode']?.toString() ?? 'el',
        fcmToken: map['fcmToken']?.toString(),
        savedEvents: List<String>.from(map['savedEvents'] ?? []),
        savedPlaces: List<String>.from(map['savedPlaces'] ?? []),
        createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        cityId: map['cityId']?.toString() ?? 'ioannina',
        accountType: AccountType.fromKey(map['accountType']?.toString()),
        businessName: map['businessName']?.toString(),
        ownerName: map['ownerName']?.toString(),
        phone: map['phone']?.toString(),
        vatNumber: map['vatNumber']?.toString(),
        businessAddress: map['businessAddress']?.toString(),
        businessCategory: map['businessCategory']?.toString(),
        logoUrl: map['logoUrl']?.toString(),
        description: map['description']?.toString(),
        workingHours: map['workingHours'] != null
            ? WorkingHours.fromMap(
                Map<String, dynamic>.from(map['workingHours']))
            : null,
        businessStatus: map['businessStatus'] != null
            ? BusinessStatus.fromKey(map['businessStatus']?.toString())
            : null,
        adminNotes: map['adminNotes']?.toString(),
      );

  AppUser copyWith({
    String? displayName,
    String? photoUrl,
    UserRole? role,
    String? organizationId,
    String? languageCode,
    String? fcmToken,
    List<String>? savedEvents,
    List<String>? savedPlaces,
    String? cityId,
    AccountType? accountType,
    String? businessName,
    String? ownerName,
    String? phone,
    String? vatNumber,
    String? businessAddress,
    String? businessCategory,
    String? logoUrl,
    String? description,
    WorkingHours? workingHours,
    BusinessStatus? businessStatus,
    String? adminNotes,
  }) =>
      AppUser(
        uid: uid,
        email: email,
        displayName: displayName ?? this.displayName,
        photoUrl: photoUrl ?? this.photoUrl,
        role: role ?? this.role,
        organizationId: organizationId ?? this.organizationId,
        languageCode: languageCode ?? this.languageCode,
        fcmToken: fcmToken ?? this.fcmToken,
        savedEvents: savedEvents ?? this.savedEvents,
        savedPlaces: savedPlaces ?? this.savedPlaces,
        createdAt: createdAt,
        cityId: cityId ?? this.cityId,
        accountType: accountType ?? this.accountType,
        businessName: businessName ?? this.businessName,
        ownerName: ownerName ?? this.ownerName,
        phone: phone ?? this.phone,
        vatNumber: vatNumber ?? this.vatNumber,
        businessAddress: businessAddress ?? this.businessAddress,
        businessCategory: businessCategory ?? this.businessCategory,
        logoUrl: logoUrl ?? this.logoUrl,
        description: description ?? this.description,
        workingHours: workingHours ?? this.workingHours,
        businessStatus: businessStatus ?? this.businessStatus,
        adminNotes: adminNotes ?? this.adminNotes,
      );

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoUrl,
        role,
        organizationId,
        languageCode,
        fcmToken,
        savedEvents,
        savedPlaces,
        createdAt,
        cityId,
        accountType,
        businessName,
        ownerName,
        phone,
        vatNumber,
        businessAddress,
        businessCategory,
        logoUrl,
        description,
        workingHours,
        businessStatus,
        adminNotes,
      ];
}
