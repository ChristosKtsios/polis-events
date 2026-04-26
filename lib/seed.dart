import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

/// COMPREHENSIVE seed - 25+ real places από όλη την Ήπειρο.
///
/// Πώς τρέχει:
/// 1. Άλλαξε προσωρινά το `lib/main.dart` να καλεί `runApp(const SeedApp());`
/// 2. flutter run
/// 3. Πάτα "Seed Database"
/// 4. Όταν δεις "✅ Done!", σταμάτα και επανέφερε το main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SeedApp());
}

class SeedApp extends StatelessWidget {
  const SeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SeedScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SeedScreen extends StatefulWidget {
  const SeedScreen({super.key});

  @override
  State<SeedScreen> createState() => _SeedScreenState();
}

class _SeedScreenState extends State<SeedScreen> {
  String _status = 'Έτοιμο για seed';
  bool _running = false;

  Future<void> _runSeed() async {
    setState(() {
      _running = true;
      _status = 'Ξεκινάει...';
    });

    try {
      final db = FirebaseFirestore.instance;

      // ─── Cities ─────────────────────────────────
      setState(() => _status = 'Δημιουργία πόλεων...');
      await _seedCities(db);

      // ─── Organizations ─────────────────────────
      setState(() => _status = 'Δημιουργία οργανισμών...');
      await _seedOrganizations(db);

      // ─── Places ─────────────────────────────────
      setState(() => _status = 'Δημιουργία 25+ σημείων...');
      final places = _seedPlaces();
      var i = 0;
      for (final place in places) {
        i++;
        setState(() => _status = 'Adding place $i/${places.length}...');
        await db.collection('places').add(place);
      }

      setState(
          () => _status = '✅ Done! ${places.length} places δημιουργήθηκαν');
    } catch (e) {
      setState(() => _status = '❌ Error: $e');
    } finally {
      setState(() => _running = false);
    }
  }

  Future<void> _seedCities(FirebaseFirestore db) async {
    await db.collection('cities').doc('ioannina').set({
      'slug': 'ioannina',
      'name': {'el': 'Ιωάννινα', 'en': 'Ioannina'},
      'region': {'el': 'Ήπειρος', 'en': 'Epirus'},
      'center': const GeoPoint(39.6650, 20.8537),
      'radiusKm': 25,
    });
  }

  Future<void> _seedOrganizations(FirebaseFirestore db) async {
    await db.collection('organizations').doc('efaioa').set({
      'name': {
        'el': 'Εφορεία Αρχαιοτήτων Ιωαννίνων',
        'en': 'Ephorate of Antiquities of Ioannina'
      },
      'phone': '+302651001089',
      'website': 'https://efaioa.gr',
      'approved': true,
      'createdAt': Timestamp.now(),
    });

    await db.collection('organizations').doc('piop').set({
      'name': {
        'el': 'Πολιτιστικό Ίδρυμα Ομίλου Πειραιώς',
        'en': 'Piraeus Bank Group Cultural Foundation'
      },
      'phone': '+302651064065',
      'website': 'https://www.piop.gr',
      'approved': true,
      'createdAt': Timestamp.now(),
    });

    await db.collection('organizations').doc('demos-ioanniton').set({
      'name': {'el': 'Δήμος Ιωαννιτών', 'en': 'Municipality of Ioannina'},
      'phone': '+302651361200',
      'website': 'https://www.ioannina.gr',
      'approved': true,
      'createdAt': Timestamp.now(),
    });
  }

  // ═══════════════════════════════════════════════════════
  //                 25+ REAL PLACES
  // ═══════════════════════════════════════════════════════

  List<Map<String, dynamic>> _seedPlaces() {
    final now = Timestamp.now();
    return [
      // ════════ ΜΟΥΣΕΙΑ (10) ════════

      _place(
        name: 'Αρχαιολογικό Μουσείο Ιωαννίνων',
        nameEn: 'Archaeological Museum of Ioannina',
        description:
            'Στεγάζει σημαντικά ευρήματα από όλη την Ήπειρο, από τη Μέση Παλαιολιθική έως τη Ρωμαϊκή εποχή. Περιλαμβάνει τα μολύβδινα ελάσματα του μαντείου της Δωδώνης.',
        category: 'museum',
        lat: 39.6677,
        lng: 20.8506,
        address: 'Πλατεία 25ης Μαρτίου 6, 45221 Ιωάννινα',
        priceFrom: 10,
        rating: 4.5,
        reviewCount: 234,
        phone: '+302651001089',
        website: 'https://efaioa.gr',
        image:
            'https://images.unsplash.com/photo-1565060169187-5284e0a9f906?w=800',
        organizationId: 'efaioa',
        now: now,
      ),

      _place(
        name: 'Βυζαντινό Μουσείο Ιωαννίνων',
        nameEn: 'Byzantine Museum of Ioannina',
        description:
            'Στο Ιτς Καλέ μέσα στο Κάστρο. Ιστορία και τέχνη Ηπείρου από 4ο έως 19ο αιώνα. Σημαντικές βυζαντινές εικόνες.',
        category: 'museum',
        lat: 39.6688,
        lng: 20.8579,
        address: 'Κάστρο Ιωαννίνων, Ιτς Καλέ',
        priceFrom: 6,
        rating: 4.6,
        reviewCount: 187,
        phone: '+302651025989',
        image:
            'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=800',
        organizationId: 'efaioa',
        now: now,
      ),

      _place(
        name: 'Μουσείο Αργυροτεχνίας ΠΙΟΠ',
        nameEn: 'Silversmithing Museum',
        description:
            'Σύγχρονο θεματικό μουσείο για την ηπειρώτικη αργυροτεχνία στον δυτικό προμαχώνα του Ιτς Καλέ.',
        category: 'museum',
        lat: 39.6695,
        lng: 20.8590,
        address: 'Ακρόπολη Ιτς Καλέ, Κάστρο Ιωαννίνων',
        priceFrom: 4,
        rating: 4.7,
        reviewCount: 312,
        phone: '+302651064065',
        website: 'https://www.piop.gr',
        image:
            'https://images.unsplash.com/photo-1554907984-15263bfd63bd?w=800',
        organizationId: 'piop',
        now: now,
      ),

      _place(
        name: 'Δημοτικό Μουσείο - Τζαμί Ασλάν Πασά',
        nameEn: 'Municipal Museum - Aslan Pasha Mosque',
        description:
            'Στεγάζεται στο ιστορικό Τζαμί Ασλάν Πασά (1618). Πολιτιστική κληρονομιά τριών κοινοτήτων: ορθόδοξης, μουσουλμανικής, εβραϊκής.',
        category: 'museum',
        lat: 39.6710,
        lng: 20.8595,
        address: 'Κάστρο Ιωαννίνων (βόρειο τμήμα)',
        priceFrom: 4,
        rating: 4.4,
        reviewCount: 156,
        phone: '+302651026356',
        image:
            'https://images.unsplash.com/photo-1564399580075-52ca6d11ef03?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Μουσείο Παύλου Βρέλλη',
        nameEn: 'Pavlos Vrellis Museum',
        description:
            'Μουσείο κέρινων ομοιωμάτων με σκηνές από την ελληνική ιστορία. 12 χλμ ν.Α από Ιωάννινα στο Μπιζάνι.',
        category: 'museum',
        lat: 39.5778,
        lng: 20.8489,
        address: 'Μπιζάνι, 12χλμ Ε.Ο. Ιωαννίνων-Άρτας',
        priceFrom: 6,
        rating: 4.5,
        reviewCount: 478,
        phone: '+302651092128',
        website: 'https://www.vrellis.gr',
        image:
            'https://images.unsplash.com/photo-1577720580479-7d839d829c73?w=800',
        organizationId: 'efaioa',
        now: now,
      ),

      _place(
        name: 'Δημοτική Πινακοθήκη Ιωαννίνων',
        nameEn: 'Municipal Gallery of Ioannina',
        description:
            'Νεοκλασικό κτίριο του 1890. Μόνιμη και περιοδικές εκθέσεις Ελλήνων ζωγράφων.',
        category: 'gallery',
        lat: 39.6643,
        lng: 20.8523,
        address: 'Νούτσου 2, Ιωάννινα',
        priceFrom: 2,
        rating: 4.3,
        reviewCount: 89,
        phone: '+302651039580',
        image:
            'https://images.unsplash.com/photo-1580136607086-d3b75f3e0f0a?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Μουσείο Εθνικής Αντίστασης',
        nameEn: 'National Resistance Museum',
        description:
            'Τέσσερις αίθουσες με υλικό από την Εθνική Αντίσταση κατά της Γερμανικής κατοχής.',
        category: 'museum',
        lat: 39.6690,
        lng: 20.8550,
        address: 'Πλατεία Α. Παπανδρέου, Ιωάννινα',
        priceFrom: 4,
        rating: 4.5,
        reviewCount: 67,
        phone: '+302651026356',
        image:
            'https://images.unsplash.com/photo-1551817958-d9d86fb29431?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Λαογραφικό Μουσείο Πανεπιστημίου',
        nameEn: 'Folklore Museum (University)',
        description:
            'Πλούσιες λαογραφικές συλλογές από την Ήπειρο σε ιστορικό κτίριο του 19ου αιώνα.',
        category: 'museum',
        lat: 39.6149,
        lng: 20.8410,
        address: 'Πανεπιστημιούπολη Ιωαννίνων, 45110',
        priceFrom: 1,
        rating: 4.4,
        reviewCount: 53,
        image:
            'https://images.unsplash.com/photo-1566127992631-137a642a90f4?w=800',
        organizationId: 'efaioa',
        now: now,
      ),

      _place(
        name: 'Πινακοθήκη Ε. Αβέρωφ',
        nameEn: 'Averoff Gallery',
        description:
            '250 έργα σημαντικών Ελλήνων ζωγράφων, χαρακτών και γλυπτών 19ου-20ού αιώνα. Στο Μέτσοβο.',
        category: 'gallery',
        lat: 39.7724,
        lng: 21.1841,
        address: 'Μέτσοβο 44200',
        priceFrom: 5,
        rating: 4.8,
        reviewCount: 562,
        phone: '+302656041210',
        website: 'https://www.averoffmuseum.gr',
        image:
            'https://images.unsplash.com/photo-1554907984-15263bfd63bd?w=800',
        organizationId: 'piop',
        now: now,
      ),

      // ════════ ΑΡΧΑΙΟΛΟΓΙΚΑ (5) ════════

      _place(
        name: 'Αρχαιολογικός Χώρος Δωδώνης',
        nameEn: 'Archaeological Site of Dodona',
        description:
            'Το αρχαιότερο μαντείο των Ελλήνων στον Δία. Θέατρο 17.000 θέσεων, ιερό, βουλευτήριο, ακρόπολη. 22 χλμ νότια.',
        category: 'archaeological',
        lat: 39.5467,
        lng: 20.7878,
        address: 'Δωδώνη, 45500 (22 χλμ νότια Ιωαννίνων)',
        priceFrom: 15,
        rating: 4.7,
        reviewCount: 423,
        phone: '+302651082287',
        website: 'https://efaioa.gr',
        image:
            'https://images.unsplash.com/photo-1599893350516-f7b6ae8c0a91?w=800',
        organizationId: 'efaioa',
        now: now,
      ),

      _place(
        name: 'Κάστρο Ιωαννίνων',
        nameEn: 'Ioannina Castle',
        description:
            'Βυζαντινό κάστρο 6ου αιώνα. Περιέχει το Ιτς Καλέ, Τζαμί Ασλάν Πασά και πολλά μουσεία. Δωρεάν είσοδος.',
        category: 'castle',
        lat: 39.6688,
        lng: 20.8579,
        address: 'Κάστρο Ιωαννίνων, Παλιά Πόλη',
        isFree: true,
        rating: 4.7,
        reviewCount: 892,
        image:
            'https://images.unsplash.com/photo-1558005530-a7958896ec60?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Αρχαιολογικό Μουσείο Νικόπολης',
        nameEn: 'Archaeological Museum of Nicopolis',
        description:
            'Νέο μουσείο στην είσοδο της Πρέβεζας. Ευρήματα από τη Νικόπολη, την πόλη της Νίκης του Ακτίου.',
        category: 'museum',
        lat: 38.9595,
        lng: 20.7569,
        address: '5o χλμ Λεωφ. Πρέβεζας-Άρτας, Πρέβεζα',
        priceFrom: 4,
        rating: 4.6,
        reviewCount: 245,
        phone: '+302682089892',
        website: 'https://nicopolismuseum.gr',
        image:
            'https://images.unsplash.com/photo-1565060169187-5284e0a9f906?w=800',
        organizationId: 'efaioa',
        now: now,
      ),

      _place(
        name: 'Αρχαιολογικό Μουσείο Άρτας',
        nameEn: 'Archaeological Museum of Arta',
        description:
            'Έκθεση αφιερωμένη στην αρχαία Αμβρακία. Νεκροταφεία, δημόσιος και ιδιωτικός βίος.',
        category: 'museum',
        lat: 39.1583,
        lng: 20.9806,
        address: 'Περιοχή Τρίγωνο, 47100 Άρτα',
        priceFrom: 4,
        rating: 4.5,
        reviewCount: 156,
        phone: '+302681021191',
        image:
            'https://images.unsplash.com/photo-1582555172866-f73bb12a2ab3?w=800',
        organizationId: 'efaioa',
        now: now,
      ),

      _place(
        name: 'Αρχαιολογικό Μουσείο Ηγουμενίτσας',
        nameEn: 'Archaeological Museum of Igoumenitsa',
        description: 'Σύγχρονο μουσείο με ευρήματα από την αρχαία Θεσπρωτία.',
        category: 'museum',
        lat: 39.5025,
        lng: 20.2654,
        address: '28ης Οκτωβρίου 2, 46100 Ηγουμενίτσα',
        priceFrom: 5,
        rating: 4.4,
        reviewCount: 98,
        phone: '+302665028539',
        website: 'http://igoumenitsamuseum.gr',
        image:
            'https://images.unsplash.com/photo-1588417326253-0fe28c10ec18?w=800',
        organizationId: 'efaioa',
        now: now,
      ),

      // ════════ ΦΥΣΗ (5) ════════

      _place(
        name: 'Νησάκι Ιωαννίνων',
        nameEn: 'Ioannina Island',
        description:
            'Το μοναδικό κατοικημένο νησί σε λίμνη στην Ελλάδα. 7 βυζαντινά μοναστήρια. Πρόσβαση με καραβάκι.',
        category: 'lake',
        lat: 39.6753,
        lng: 20.8753,
        address: 'Νησί Ιωαννίνων, Λίμνη Παμβώτιδα',
        isFree: true,
        rating: 4.8,
        reviewCount: 1245,
        image:
            'https://images.unsplash.com/photo-1602345263767-e95b25fe1faa?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Σπήλαιο Περάματος',
        nameEn: 'Perama Cave',
        description:
            'Ένα από τα ωραιότερα σπήλαια στον κόσμο. 14.800 τ.μ. με σταλακτίτες ηλικίας 1.500.000 ετών.',
        category: 'cave',
        lat: 39.6920,
        lng: 20.8480,
        address: 'Πέραμα Ιωαννίνων (5 χλμ από κέντρο)',
        priceFrom: 7,
        rating: 4.8,
        reviewCount: 587,
        phone: '+302651081521',
        website: 'https://www.spilaio-perama.gr',
        image:
            'https://images.unsplash.com/photo-1542640244-7e672d6cef4e?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Φαράγγι Βίκου',
        nameEn: 'Vikos Gorge',
        description:
            'Ένα από τα βαθύτερα φαράγγια στον κόσμο. Πεζοπορία 6 ωρών μέσα από το εθνικό πάρκο. Στο Ζαγόρι.',
        category: 'trail',
        lat: 39.9667,
        lng: 20.7333,
        address: 'Μονοδένδρι, Ζαγόρι',
        isFree: true,
        rating: 4.9,
        reviewCount: 723,
        image:
            'https://images.unsplash.com/photo-1551632811-561732d1e306?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Δρακολίμνη Τύμφης',
        nameEn: 'Dragon Lake of Tymfi',
        description:
            'Αλπική λίμνη σε υψόμετρο 2.000μ. Απαιτητική πεζοπορία αλλά μοναδική θέα.',
        category: 'lake',
        lat: 39.9833,
        lng: 20.8167,
        address: 'Όρος Τύμφη, Ζαγόρι',
        isFree: true,
        rating: 4.9,
        reviewCount: 412,
        image:
            'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Παραλίμνιο Πάρκο',
        nameEn: 'Lakeside Park',
        description:
            'Ψυχαγωγικό πάρκο δίπλα στη λίμνη Παμβώτιδα. Ποδηλατόδρομος, πεζόδρομοι, παιδικές χαρές.',
        category: 'park',
        lat: 39.6620,
        lng: 20.8770,
        address: 'Ακτή Μιαούλη, Ιωάννινα',
        isFree: true,
        rating: 4.6,
        reviewCount: 289,
        image:
            'https://images.unsplash.com/photo-1500964757637-c85e8a162699?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      // ════════ ΑΘΛΗΤΙΚΑ (4) ════════

      _place(
        name: 'Epirus Sports & Health Center',
        nameEn: 'Epirus Sports & Health Center',
        description:
            'Το μεγαλύτερο και πιο ολοκληρωμένο Κέντρο Αθλητισμού. Γυμναστήριο, κολυμβητήριο, γήπεδα 5x5, ακαδημία ποδοσφαίρου.',
        category: 'gym',
        lat: 39.6450,
        lng: 20.8200,
        address: 'Νεοχωρόπουλο, Ιωάννινα',
        priceFrom: 30,
        rating: 4.7,
        reviewCount: 421,
        phone: '+302651046735',
        website: 'https://epirussport.gr',
        image:
            'https://images.unsplash.com/photo-1571902943202-507ec2618e8f?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Αθλητικό Κέντρο Λιμνοπούλας',
        nameEn: 'Limnopoula Sports Center',
        description:
            'Πρώην ΕΑΝΚΙ. Κλειστό γυμναστήριο, γήπεδο ποδοσφαίρου, μπάσκετ, τένις, κολυμβητήριο. Δίπλα στη λίμνη.',
        category: 'field',
        lat: 39.6580,
        lng: 20.8650,
        address: 'Παραλίμνια Λεωφόρος, Ιωάννινα',
        priceFrom: 5,
        rating: 4.5,
        reviewCount: 178,
        image:
            'https://images.unsplash.com/photo-1459865264687-595d652de67e?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Titans Gym',
        nameEn: 'Titans Gym',
        description:
            'Muay Thai, MMA, Cross Training, Kickbox, Πυγμαχία, Pilates Reformer.',
        category: 'gym',
        lat: 39.6720,
        lng: 20.8390,
        address: 'Ιωάννινα',
        priceFrom: 40,
        rating: 4.8,
        reviewCount: 156,
        website: 'https://titansgym.gr',
        image:
            'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      _place(
        name: 'Παραλίμνιο Park - Γήπεδα 5Χ5',
        nameEn: 'Paralimnio Park 5x5 Fields',
        description:
            'Γήπεδα 5Χ5, 6Χ6, 9Χ9 ποδοσφαίρου με τάπητες 4G. Ψυχαγωγικό Πάρκο Παραλίμνιο.',
        category: 'field',
        lat: 39.6610,
        lng: 20.8780,
        address: 'Ακτή Μιαούλη, Παραλίμνιο, Ιωάννινα',
        priceFrom: 30,
        rating: 4.6,
        reviewCount: 298,
        image:
            'https://images.unsplash.com/photo-1551958219-acbc608c6377?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      // ════════ ΣΙΝΕΜΑ (1) ════════

      _place(
        name: 'ODEON Paralimnio Ioannina',
        nameEn: 'ODEON Paralimnio',
        description:
            'Σύγχρονος κινηματογράφος με πολλαπλές αίθουσες. Premiere ταινίες, 3D, Dolby Atmos.',
        category: 'cinema',
        lat: 39.6605,
        lng: 20.8775,
        address: 'Παραλίμνιο, Ακτή Μιαούλη, Ιωάννινα',
        priceFrom: 8,
        rating: 4.5,
        reviewCount: 645,
        website: 'http://www.odeon.gr',
        image:
            'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=800',
        organizationId: 'demos-ioanniton',
        now: now,
      ),

      // ════════ HOBBIES / WORKSHOPS (1) ════════

      _place(
        name: 'Παιδικό Εργαστήρι Πινακοθήκης Αβέρωφ',
        nameEn: 'Averoff Gallery Children Workshop',
        description:
            'Δημιουργικά εργαστήρια ζωγραφικής και τέχνης για παιδιά στο Μέτσοβο.',
        category: 'workshop',
        lat: 39.7724,
        lng: 21.1841,
        address: 'Πινακοθήκη Αβέρωφ, Μέτσοβο',
        priceFrom: 5,
        rating: 4.7,
        reviewCount: 67,
        phone: '+302656041210',
        website: 'https://www.averoffmuseum.gr',
        image:
            'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800',
        organizationId: 'piop',
        now: now,
      ),
    ];
  }

  Map<String, dynamic> _place({
    required String name,
    required String nameEn,
    required String description,
    required String category,
    required double lat,
    required double lng,
    required String address,
    num? priceFrom,
    bool isFree = false,
    required double rating,
    required int reviewCount,
    String? phone,
    String? website,
    required String image,
    required String organizationId,
    required Timestamp now,
  }) {
    return {
      'name': {'el': name, 'en': nameEn},
      'description': {'el': description, 'en': nameEn},
      'category': category,
      'cityId': 'ioannina',
      'organizationId': organizationId,
      'location': GeoPoint(lat, lng),
      'address': {'el': address, 'en': address},
      'priceFrom': priceFrom,
      'isFree': isFree,
      'images': [image],
      if (phone != null) 'phone': phone,
      if (website != null) 'website': website,
      'rating': rating,
      'reviewCount': reviewCount,
      'published': true,
      'createdAt': now,
      'updatedAt': now,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polis Events Seed')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Comprehensive Seed',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '25+ ΠΡΑΓΜΑΤΙΚΑ μουσεία, αρχαιολογικοί χώροι, αθλητικά κέντρα, σινεμά, φύση από Ιωάννινα και Ήπειρο.',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _running ? null : _runSeed,
              child: Text(_running ? 'Τρέχει...' : 'Seed Database'),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.grey[200],
              child: Text(_status),
            ),
          ],
        ),
      ),
    );
  }
}
