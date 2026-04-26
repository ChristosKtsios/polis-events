/// Data για όλες τις κατηγορίες και υποκατηγορίες του app.
///
/// Δομή:
/// - Category (π.χ. "Πολιτισμός") περιέχει
/// - Subcategories (π.χ. "Μουσεία", "Αρχαιολογικά")
/// - Κάθε subcategory έχει list από firestore category aliases
///   ώστε να φιλτράρουμε τα places.
class SubcategoryInfo {
  final String id;
  final String label;
  final String description;

  /// Firestore category values που ψάχνουμε.
  final List<String> firestoreCategories;

  const SubcategoryInfo({
    required this.id,
    required this.label,
    required this.description,
    required this.firestoreCategories,
  });
}

class CategoryInfo {
  final String id;
  final String label;
  final List<SubcategoryInfo> subcategories;

  const CategoryInfo({
    required this.id,
    required this.label,
    required this.subcategories,
  });
}

class CategoriesData {
  static const all = <CategoryInfo>[
    CategoryInfo(
      id: 'culture',
      label: 'Πολιτισμός',
      subcategories: [
        SubcategoryInfo(
          id: 'museums',
          label: 'Μουσεία',
          description:
              'Αρχαιολογικά, βυζαντινά, λαογραφικά μουσεία και θεματικές συλλογές.',
          firestoreCategories: ['museum'],
        ),
        SubcategoryInfo(
          id: 'archaeological',
          label: 'Αρχαιολογικά',
          description:
              'Αρχαιολογικοί χώροι και ιστορικά μνημεία ελεύθερης πρόσβασης ή με εισιτήριο.',
          firestoreCategories: ['historical', 'archaeological'],
        ),
        SubcategoryInfo(
          id: 'galleries',
          label: 'Πινακοθήκες',
          description:
              'Δημοτικές και ιδιωτικές πινακοθήκες με μόνιμες και περιοδικές εκθέσεις τέχνης.',
          firestoreCategories: ['gallery'],
        ),
        SubcategoryInfo(
          id: 'libraries',
          label: 'Βιβλιοθήκες',
          description:
              'Δημόσιες και πανεπιστημιακές βιβλιοθήκες με χώρους μελέτης και αναγνωστήρια.',
          firestoreCategories: ['library'],
        ),
        SubcategoryInfo(
          id: 'castles',
          label: 'Κάστρα & Φρούρια',
          description:
              'Βυζαντινά και νεότερα οχυρωματικά μνημεία ανοιχτά για επίσκεψη.',
          firestoreCategories: ['castle'],
        ),
      ],
    ),
    CategoryInfo(
      id: 'shows',
      label: 'Παραστάσεις & Σινεμά',
      subcategories: [
        SubcategoryInfo(
          id: 'theater',
          label: 'Θέατρο',
          description: 'Θεατρικές παραστάσεις σε δημοτικά και ιδιωτικά θέατρα.',
          firestoreCategories: ['theater', 'performance'],
        ),
        SubcategoryInfo(
          id: 'cinema',
          label: 'Σινεμά',
          description:
              'Κινηματογραφικές αίθουσες και multiplex με τρέχουσες προβολές.',
          firestoreCategories: ['cinema'],
        ),
        SubcategoryInfo(
          id: 'dance',
          label: 'Χορός & Όπερα',
          description: 'Χορευτικές παραστάσεις, μπαλέτο και οπερατικά event.',
          firestoreCategories: ['dance', 'opera'],
        ),
      ],
    ),
    CategoryInfo(
      id: 'exhibitions',
      label: 'Εκθέσεις & Φεστιβάλ',
      subcategories: [
        SubcategoryInfo(
          id: 'art_exhibitions',
          label: 'Εκθέσεις τέχνης',
          description: 'Περιοδικές εκθέσεις σύγχρονης και κλασικής τέχνης.',
          firestoreCategories: ['exhibition'],
        ),
        SubcategoryInfo(
          id: 'festivals',
          label: 'Φεστιβάλ',
          description: 'Πολιτιστικά, μουσικά και θεματικά φεστιβάλ της πόλης.',
          firestoreCategories: ['festival'],
        ),
        SubcategoryInfo(
          id: 'fairs',
          label: 'Παζάρια & Bazaars',
          description:
              'Εμποροπανηγύρεις, χριστουγεννιάτικα παζάρια και open markets.',
          firestoreCategories: ['fair'],
        ),
      ],
    ),
    CategoryInfo(
      id: 'tours',
      label: 'Ξεναγήσεις & Φύση',
      subcategories: [
        SubcategoryInfo(
          id: 'walking_tours',
          label: 'Walking tours',
          description: 'Καθοδηγούμενες ξεναγήσεις στην πόλη με ξεναγό.',
          firestoreCategories: ['tour', 'walking_tour'],
        ),
        SubcategoryInfo(
          id: 'parks',
          label: 'Πάρκα & Λίμνες',
          description: 'Δημοτικά πάρκα, λίμνες και χώροι αναψυχής.',
          firestoreCategories: ['nature', 'park', 'lake'],
        ),
        SubcategoryInfo(
          id: 'trails',
          label: 'Μονοπάτια',
          description:
              'Πεζοπορικές διαδρομές, μονοπάτια Ζαγορίου και ορεινά routes.',
          firestoreCategories: ['trail', 'hiking'],
        ),
        SubcategoryInfo(
          id: 'caves',
          label: 'Σπήλαια & Γεφύρια',
          description: 'Φυσικά σπήλαια και ιστορικά πέτρινα γεφύρια.',
          firestoreCategories: ['cave', 'bridge'],
        ),
      ],
    ),
    CategoryInfo(
      id: 'sports',
      label: 'Αθλητικά',
      subcategories: [
        SubcategoryInfo(
          id: 'gyms',
          label: 'Γυμναστήρια',
          description: 'Γυμναστήρια ομαδικών μαθημάτων, fitness και CrossFit.',
          firestoreCategories: ['gym'],
        ),
        SubcategoryInfo(
          id: 'pools',
          label: 'Κολυμβητήρια',
          description:
              'Κλειστά και ανοιχτά κολυμβητήρια για ενήλικες και παιδιά.',
          firestoreCategories: ['pool', 'swimming'],
        ),
        SubcategoryInfo(
          id: 'fields',
          label: 'Γήπεδα',
          description: 'Γήπεδα 5x5, 6x6, 9x9 ποδοσφαίρου, μπάσκετ και τένις.',
          firestoreCategories: ['field', 'stadium'],
        ),
        SubcategoryInfo(
          id: 'padel',
          label: 'Padel',
          description: 'Γήπεδα padel για κρατήσεις και ομαδικές προπονήσεις.',
          firestoreCategories: ['padel'],
        ),
      ],
    ),
    CategoryInfo(
      id: 'leisure',
      label: 'Έξοδος & Hobbies',
      subcategories: [
        SubcategoryInfo(
          id: 'bars',
          label: 'Bars',
          description: 'Bars, cocktail bars και live music venues.',
          firestoreCategories: ['bar', 'nightlife'],
        ),
        SubcategoryInfo(
          id: 'cafes',
          label: 'Cafés',
          description: 'Καφετέριες, brunch spots και specialty coffee.',
          firestoreCategories: ['cafe'],
        ),
        SubcategoryInfo(
          id: 'restaurants',
          label: 'Εστιατόρια',
          description:
              'Παραδοσιακές ταβέρνες, σύγχρονα εστιατόρια και bistros.',
          firestoreCategories: ['restaurant'],
        ),
        SubcategoryInfo(
          id: 'workshops',
          label: 'Workshops',
          description:
              'Δημιουργικά εργαστήρια, μαθήματα και educational programs.',
          firestoreCategories: ['workshop', 'hobbies'],
        ),
      ],
    ),
  ];

  /// Επιστρέφει τη CategoryInfo με βάση το id.
  static CategoryInfo? find(String id) {
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Επιστρέφει τη SubcategoryInfo από category + subcategory ids.
  static SubcategoryInfo? findSub(String catId, String subId) {
    final cat = find(catId);
    if (cat == null) return null;
    try {
      return cat.subcategories.firstWhere((s) => s.id == subId);
    } catch (_) {
      return null;
    }
  }
}
