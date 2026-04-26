import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category.dart';
import '../models/city_model.dart';
import '../models/event_model.dart';
import '../models/organization_model.dart';
import '../models/place_model.dart';

/// Service για Firestore queries σε events, places, organizations και cities.
class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  // ── Cities ─────────────────────────────────────────────

  Stream<List<City>> citiesStream() {
    return _db.collection('cities').snapshots().map(
          (snap) => snap.docs.map((d) => City.fromMap(d.id, d.data())).toList(),
        );
  }

  Future<City?> getCity(String id) async {
    final doc = await _db.collection('cities').doc(id).get();
    if (!doc.exists) return null;
    return City.fromMap(doc.id, doc.data()!);
  }

  // ── Events ─────────────────────────────────────────────

  /// Events που παίζουν ΣΗΜΕΡΑ (startDate ≤ τέλος σήμερα && endDate ≥ αρχή σήμερα).
  /// Τα επιστρέφει ταξινομημένα χρονικά.
  Stream<List<Event>> todayEventsStream({required String cityId}) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return _db
        .collection('events')
        .where('cityId', isEqualTo: cityId)
        .where('status', isEqualTo: EventStatus.published.name)
        .where('startDate', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('startDate')
        .snapshots()
        .map((snap) {
      final all = snap.docs.map((d) => Event.fromMap(d.id, d.data())).toList();
      // Κρατάμε μόνο όσα τελειώνουν σήμερα ή αργότερα
      return all.where((e) => e.endDate.isAfter(startOfDay)).toList();
    });
  }

  /// Δημοσιευμένα upcoming events για μια πόλη.
  Stream<List<Event>> upcomingEventsStream({
    required String cityId,
    int limit = 20,
    EventCategory? category,
  }) {
    Query<Map<String, dynamic>> query = _db
        .collection('events')
        .where('cityId', isEqualTo: cityId)
        .where('status', isEqualTo: EventStatus.published.name)
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.now());

    if (category != null) {
      query = query.where('category', isEqualTo: category.key);
    }

    return query
        .orderBy('endDate')
        .orderBy('startDate')
        .limit(limit)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Event.fromMap(d.id, d.data())).toList());
  }

  /// Events που φιλοξενούνται σε συγκεκριμένο place.
  Stream<List<Event>> eventsForPlace(String placeId, {int limit = 10}) {
    return _db
        .collection('events')
        .where('placeId', isEqualTo: placeId)
        .where('status', isEqualTo: EventStatus.published.name)
        .where('endDate', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('endDate')
        .orderBy('startDate')
        .limit(limit)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Event.fromMap(d.id, d.data())).toList());
  }

  /// Events που ανήκουν σε οργανισμό (admin view).
  Stream<List<Event>> eventsForOrganization(String orgId) {
    return _db
        .collection('events')
        .where('organizationId', isEqualTo: orgId)
        .orderBy('startDate', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Event.fromMap(d.id, d.data())).toList());
  }

  Future<Event?> getEvent(String id) async {
    final doc = await _db.collection('events').doc(id).get();
    if (!doc.exists) return null;
    return Event.fromMap(doc.id, doc.data()!);
  }

  Future<String> createEvent(Event event) async {
    final ref = await _db.collection('events').add(event.toMap());
    return ref.id;
  }

  Future<void> updateEvent(Event event) {
    return _db.collection('events').doc(event.id).update(event.toMap());
  }

  Future<void> deleteEvent(String id) {
    return _db.collection('events').doc(id).delete();
  }

  // ── Places ─────────────────────────────────────────────

  Stream<List<Place>> placesStream({
    required String cityId,
    PlaceCategory? category,
    int limit = 30,
  }) {
    Query<Map<String, dynamic>> query = _db
        .collection('places')
        .where('cityId', isEqualTo: cityId)
        .where('published', isEqualTo: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category.key);
    }

    return query
        .orderBy('rating', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Place.fromMap(d.id, d.data())).toList());
  }

  Stream<List<Place>> placesForOrganization(String orgId) {
    return _db
        .collection('places')
        .where('organizationId', isEqualTo: orgId)
        .snapshots()
        .map((snap) =>
            snap.docs.map((d) => Place.fromMap(d.id, d.data())).toList());
  }

  Future<Place?> getPlace(String id) async {
    final doc = await _db.collection('places').doc(id).get();
    if (!doc.exists) return null;
    return Place.fromMap(doc.id, doc.data()!);
  }

  Future<String> createPlace(Place place) async {
    final ref = await _db.collection('places').add(place.toMap());
    return ref.id;
  }

  Future<void> updatePlace(Place place) {
    return _db.collection('places').doc(place.id).update(place.toMap());
  }

  Future<void> deletePlace(String id) {
    return _db.collection('places').doc(id).delete();
  }

  // ── Organizations ──────────────────────────────────────

  Future<Organization?> getOrganization(String id) async {
    final doc = await _db.collection('organizations').doc(id).get();
    if (!doc.exists) return null;
    return Organization.fromMap(doc.id, doc.data()!);
  }

  Future<String> createOrganization(Organization org) async {
    final ref = await _db.collection('organizations').add(org.toMap());
    return ref.id;
  }

  // ── Saved / favorites ─────────────────────────────────

  Future<void> toggleSavedEvent(String uid, String eventId, bool saved) {
    return _db.collection('users').doc(uid).update({
      'savedEvents': saved
          ? FieldValue.arrayUnion([eventId])
          : FieldValue.arrayRemove([eventId]),
    });
  }

  Future<void> toggleSavedPlace(String uid, String placeId, bool saved) {
    return _db.collection('users').doc(uid).update({
      'savedPlaces': saved
          ? FieldValue.arrayUnion([placeId])
          : FieldValue.arrayRemove([placeId]),
    });
  }

  // ── Event registrations ───────────────────────────────

  Future<void> registerForEvent({
    required String eventId,
    required String userId,
    required String name,
    required String email,
    int ticketCount = 1,
  }) async {
    final batch = _db.batch();
    final regRef = _db
        .collection('events')
        .doc(eventId)
        .collection('registrations')
        .doc(userId);
    final eventRef = _db.collection('events').doc(eventId);

    batch.set(regRef, {
      'userId': userId,
      'name': name,
      'email': email,
      'ticketCount': ticketCount,
      'checkedIn': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(eventRef, {
      'currentRegistrations': FieldValue.increment(ticketCount),
    });

    await batch.commit();
  }

  Future<bool> isRegisteredForEvent(String eventId, String userId) async {
    final doc = await _db
        .collection('events')
        .doc(eventId)
        .collection('registrations')
        .doc(userId)
        .get();
    return doc.exists;
  }
}
