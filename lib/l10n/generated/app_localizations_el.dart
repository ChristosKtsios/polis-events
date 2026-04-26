// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appName => 'Polis Events';

  @override
  String get home => 'Αρχική';

  @override
  String get map => 'Χάρτης';

  @override
  String get calendar => 'Ημερολόγιο';

  @override
  String get saved => 'Αποθηκευμένα';

  @override
  String get profile => 'Προφίλ';

  @override
  String get greetingMorning => 'Καλημέρα';

  @override
  String get greetingAfternoon => 'Καλησπέρα';

  @override
  String get greetingEvening => 'Καλό βράδυ';

  @override
  String get whatToDiscover => 'Τι θες να ανακαλύψεις;';

  @override
  String get searchPlaceholder => 'Αναζήτηση σε events & σημεία...';

  @override
  String get tabToday => 'Σήμερα';

  @override
  String get tabDiscover => 'Ανακάλυψε';

  @override
  String get tabEvents => 'Events';

  @override
  String get tabPlaces => 'Σημεία';

  @override
  String get explore => 'Εξερεύνησε';

  @override
  String get thisWeek => 'Αυτή τη βδομάδα';

  @override
  String get popularPlaces => 'Δημοφιλή σημεία';

  @override
  String get upcomingEvents => 'Επόμενα events';

  @override
  String get nearYou => 'Κοντά σου';

  @override
  String get places => 'Σημεία';

  @override
  String get timeSlotAfternoon => 'Απόγευμα (12:00 - 17:00)';

  @override
  String get timeSlotEvening => 'Βράδυ (17:00 - 21:00)';

  @override
  String get timeSlotNight => 'Αργά (21:00 - 00:00)';

  @override
  String get openPlacesNow => 'Ανοιχτά τώρα';

  @override
  String get seeWholeWeek => 'Δες όλη τη βδομάδα';

  @override
  String get nowLive => 'ΤΩΡΑ';

  @override
  String get nowUpcoming => 'ΕΠΟΜΕΝΟ';

  @override
  String get happeningNow => 'Γίνεται τώρα';

  @override
  String startsInMinutes(int minutes) {
    return 'Ξεκινά σε $minutes\'';
  }

  @override
  String get noEventsToday => 'Κανένα event σήμερα';

  @override
  String get noEventsTodayHint =>
      'Δες τι γίνεται αυτή τη βδομάδα ή εξερεύνησε σημεία';

  @override
  String get categoryMuseums => 'Μουσεία';

  @override
  String get categoryHistorical => 'Ιστορικά & Αρχαιολογικά';

  @override
  String get categoryCulturalCenters => 'Πολιτιστικά κέντρα';

  @override
  String get categoryGalleries => 'Γκαλερί';

  @override
  String get categoryLibraries => 'Βιβλιοθήκες';

  @override
  String get categoryNightlife => 'Εστίαση & Nightlife';

  @override
  String get categoryPerformances => 'Παραστάσεις';

  @override
  String get categoryMusic => 'Μουσική & DJ Sets';

  @override
  String get categoryExhibitions => 'Εκθέσεις';

  @override
  String get categoryFestivals => 'Φεστιβάλ';

  @override
  String get categoryTours => 'Ξεναγήσεις';

  @override
  String get categorySports => 'Αθλητικά';

  @override
  String placesCount(int count) {
    return '$count σημεία';
  }

  @override
  String eventsCount(int count) {
    return '$count events';
  }

  @override
  String eventsThisWeek(int count) {
    return '$count events αυτή τη βδομάδα';
  }

  @override
  String get openNow => 'Ανοιχτό';

  @override
  String get closed => 'Κλειστά';

  @override
  String get closedNow => 'Κλειστό';

  @override
  String opensAt(String time) {
    return 'Ανοίγει στις $time';
  }

  @override
  String get openingHours => 'Ωράριο λειτουργίας';

  @override
  String get today => 'Σήμερα';

  @override
  String get tomorrow => 'Αύριο';

  @override
  String get admission => 'Είσοδος';

  @override
  String get free => 'Δωρεάν';

  @override
  String get price => 'Τιμή';

  @override
  String get directions => 'Οδηγίες';

  @override
  String get call => 'Κλήση';

  @override
  String get website => 'Site';

  @override
  String get book => 'Κράτηση';

  @override
  String get share => 'Κοινοποίηση';

  @override
  String get save => 'Αποθήκευση';

  @override
  String get registerForEvent => 'Δήλωσε συμμετοχή';

  @override
  String get registered => 'Εγγεγραμμένος';

  @override
  String get exhibitionsAndEvents => 'Εκθέσεις & Events';

  @override
  String reviewsWithCount(int count) {
    return '$count κριτικές';
  }

  @override
  String distanceKm(String distance) {
    return '${distance}km μακριά';
  }

  @override
  String distanceM(String distance) {
    return '${distance}m μακριά';
  }

  @override
  String get signIn => 'Σύνδεση';

  @override
  String get signUp => 'Εγγραφή';

  @override
  String get signOut => 'Αποσύνδεση';

  @override
  String get email => 'Email';

  @override
  String get password => 'Κωδικός';

  @override
  String get fullName => 'Ονοματεπώνυμο';

  @override
  String get signInWithGoogle => 'Σύνδεση με Google';

  @override
  String get alreadyHaveAccount => 'Έχεις ήδη λογαριασμό;';

  @override
  String get dontHaveAccount => 'Δεν έχεις λογαριασμό;';

  @override
  String get forgotPassword => 'Ξέχασες τον κωδικό;';

  @override
  String get language => 'Γλώσσα';

  @override
  String get greek => 'Ελληνικά';

  @override
  String get english => 'Αγγλικά';

  @override
  String get settings => 'Ρυθμίσεις';

  @override
  String get notifications => 'Ειδοποιήσεις';

  @override
  String get about => 'Σχετικά';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get activeEvents => 'Ενεργά events';

  @override
  String get totalRegistrations => 'Εγγραφές';

  @override
  String get viewsLastWeek => 'Προβολές (7 μέρες)';

  @override
  String get totalSaved => 'Αποθηκεύσεις';

  @override
  String get myEvents => 'Τα events μου';

  @override
  String get myPlaces => 'Τα σημεία μου';

  @override
  String get newEvent => 'Νέο event';

  @override
  String get newPlace => 'Νέο σημείο';

  @override
  String get statusActive => 'Ενεργό';

  @override
  String get statusDraft => 'Πρόχειρο';

  @override
  String get statusPending => 'Εκκρεμεί';

  @override
  String get formTitleEl => 'Τίτλος (Ελληνικά)';

  @override
  String get formTitleEn => 'Title (Αγγλικά)';

  @override
  String get formDescriptionEl => 'Περιγραφή (Ελληνικά)';

  @override
  String get formDescriptionEn => 'Description (Αγγλικά)';

  @override
  String get formCategory => 'Κατηγορία';

  @override
  String get formStartDate => 'Από';

  @override
  String get formEndDate => 'Έως';

  @override
  String get formLocation => 'Τοποθεσία';

  @override
  String get formSelectOnMap => 'Επιλογή από χάρτη';

  @override
  String get formUploadImages => '+ Ανέβασμα εικόνων';

  @override
  String get formSaveDraft => 'Πρόχειρο';

  @override
  String get formPublish => 'Δημοσίευση';

  @override
  String get monday => 'Δευτέρα';

  @override
  String get tuesday => 'Τρίτη';

  @override
  String get wednesday => 'Τετάρτη';

  @override
  String get thursday => 'Πέμπτη';

  @override
  String get friday => 'Παρασκευή';

  @override
  String get saturday => 'Σάββατο';

  @override
  String get sunday => 'Κυριακή';

  @override
  String get loading => 'Φόρτωση...';

  @override
  String get errorGeneric => 'Κάτι πήγε στραβά';

  @override
  String get retry => 'Προσπάθησε ξανά';

  @override
  String get noResults => 'Δεν βρέθηκαν αποτελέσματα';

  @override
  String get seeAll => 'Όλα';

  @override
  String welcomeUser(String name) {
    return 'Γεια σου, $name';
  }
}
