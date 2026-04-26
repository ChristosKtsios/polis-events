import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_el.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('el'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In el, this message translates to:
  /// **'Polis Events'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In el, this message translates to:
  /// **'Αρχική'**
  String get home;

  /// No description provided for @map.
  ///
  /// In el, this message translates to:
  /// **'Χάρτης'**
  String get map;

  /// No description provided for @calendar.
  ///
  /// In el, this message translates to:
  /// **'Ημερολόγιο'**
  String get calendar;

  /// No description provided for @saved.
  ///
  /// In el, this message translates to:
  /// **'Αποθηκευμένα'**
  String get saved;

  /// No description provided for @profile.
  ///
  /// In el, this message translates to:
  /// **'Προφίλ'**
  String get profile;

  /// No description provided for @greetingMorning.
  ///
  /// In el, this message translates to:
  /// **'Καλημέρα'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In el, this message translates to:
  /// **'Καλησπέρα'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In el, this message translates to:
  /// **'Καλό βράδυ'**
  String get greetingEvening;

  /// No description provided for @whatToDiscover.
  ///
  /// In el, this message translates to:
  /// **'Τι θες να ανακαλύψεις;'**
  String get whatToDiscover;

  /// No description provided for @searchPlaceholder.
  ///
  /// In el, this message translates to:
  /// **'Αναζήτηση σε events & σημεία...'**
  String get searchPlaceholder;

  /// No description provided for @tabToday.
  ///
  /// In el, this message translates to:
  /// **'Σήμερα'**
  String get tabToday;

  /// No description provided for @tabDiscover.
  ///
  /// In el, this message translates to:
  /// **'Ανακάλυψε'**
  String get tabDiscover;

  /// No description provided for @tabEvents.
  ///
  /// In el, this message translates to:
  /// **'Events'**
  String get tabEvents;

  /// No description provided for @tabPlaces.
  ///
  /// In el, this message translates to:
  /// **'Σημεία'**
  String get tabPlaces;

  /// No description provided for @explore.
  ///
  /// In el, this message translates to:
  /// **'Εξερεύνησε'**
  String get explore;

  /// No description provided for @thisWeek.
  ///
  /// In el, this message translates to:
  /// **'Αυτή τη βδομάδα'**
  String get thisWeek;

  /// No description provided for @popularPlaces.
  ///
  /// In el, this message translates to:
  /// **'Δημοφιλή σημεία'**
  String get popularPlaces;

  /// No description provided for @upcomingEvents.
  ///
  /// In el, this message translates to:
  /// **'Επόμενα events'**
  String get upcomingEvents;

  /// No description provided for @nearYou.
  ///
  /// In el, this message translates to:
  /// **'Κοντά σου'**
  String get nearYou;

  /// No description provided for @places.
  ///
  /// In el, this message translates to:
  /// **'Σημεία'**
  String get places;

  /// No description provided for @timeSlotAfternoon.
  ///
  /// In el, this message translates to:
  /// **'Απόγευμα (12:00 - 17:00)'**
  String get timeSlotAfternoon;

  /// No description provided for @timeSlotEvening.
  ///
  /// In el, this message translates to:
  /// **'Βράδυ (17:00 - 21:00)'**
  String get timeSlotEvening;

  /// No description provided for @timeSlotNight.
  ///
  /// In el, this message translates to:
  /// **'Αργά (21:00 - 00:00)'**
  String get timeSlotNight;

  /// No description provided for @openPlacesNow.
  ///
  /// In el, this message translates to:
  /// **'Ανοιχτά τώρα'**
  String get openPlacesNow;

  /// No description provided for @seeWholeWeek.
  ///
  /// In el, this message translates to:
  /// **'Δες όλη τη βδομάδα'**
  String get seeWholeWeek;

  /// No description provided for @nowLive.
  ///
  /// In el, this message translates to:
  /// **'ΤΩΡΑ'**
  String get nowLive;

  /// No description provided for @nowUpcoming.
  ///
  /// In el, this message translates to:
  /// **'ΕΠΟΜΕΝΟ'**
  String get nowUpcoming;

  /// No description provided for @happeningNow.
  ///
  /// In el, this message translates to:
  /// **'Γίνεται τώρα'**
  String get happeningNow;

  /// No description provided for @startsInMinutes.
  ///
  /// In el, this message translates to:
  /// **'Ξεκινά σε {minutes}\''**
  String startsInMinutes(int minutes);

  /// No description provided for @noEventsToday.
  ///
  /// In el, this message translates to:
  /// **'Κανένα event σήμερα'**
  String get noEventsToday;

  /// No description provided for @noEventsTodayHint.
  ///
  /// In el, this message translates to:
  /// **'Δες τι γίνεται αυτή τη βδομάδα ή εξερεύνησε σημεία'**
  String get noEventsTodayHint;

  /// No description provided for @categoryMuseums.
  ///
  /// In el, this message translates to:
  /// **'Μουσεία'**
  String get categoryMuseums;

  /// No description provided for @categoryHistorical.
  ///
  /// In el, this message translates to:
  /// **'Ιστορικά & Αρχαιολογικά'**
  String get categoryHistorical;

  /// No description provided for @categoryCulturalCenters.
  ///
  /// In el, this message translates to:
  /// **'Πολιτιστικά κέντρα'**
  String get categoryCulturalCenters;

  /// No description provided for @categoryGalleries.
  ///
  /// In el, this message translates to:
  /// **'Γκαλερί'**
  String get categoryGalleries;

  /// No description provided for @categoryLibraries.
  ///
  /// In el, this message translates to:
  /// **'Βιβλιοθήκες'**
  String get categoryLibraries;

  /// No description provided for @categoryNightlife.
  ///
  /// In el, this message translates to:
  /// **'Εστίαση & Nightlife'**
  String get categoryNightlife;

  /// No description provided for @categoryPerformances.
  ///
  /// In el, this message translates to:
  /// **'Παραστάσεις'**
  String get categoryPerformances;

  /// No description provided for @categoryMusic.
  ///
  /// In el, this message translates to:
  /// **'Μουσική & DJ Sets'**
  String get categoryMusic;

  /// No description provided for @categoryExhibitions.
  ///
  /// In el, this message translates to:
  /// **'Εκθέσεις'**
  String get categoryExhibitions;

  /// No description provided for @categoryFestivals.
  ///
  /// In el, this message translates to:
  /// **'Φεστιβάλ'**
  String get categoryFestivals;

  /// No description provided for @categoryTours.
  ///
  /// In el, this message translates to:
  /// **'Ξεναγήσεις'**
  String get categoryTours;

  /// No description provided for @categorySports.
  ///
  /// In el, this message translates to:
  /// **'Αθλητικά'**
  String get categorySports;

  /// No description provided for @placesCount.
  ///
  /// In el, this message translates to:
  /// **'{count} σημεία'**
  String placesCount(int count);

  /// No description provided for @eventsCount.
  ///
  /// In el, this message translates to:
  /// **'{count} events'**
  String eventsCount(int count);

  /// No description provided for @eventsThisWeek.
  ///
  /// In el, this message translates to:
  /// **'{count} events αυτή τη βδομάδα'**
  String eventsThisWeek(int count);

  /// No description provided for @openNow.
  ///
  /// In el, this message translates to:
  /// **'Ανοιχτό'**
  String get openNow;

  /// No description provided for @closed.
  ///
  /// In el, this message translates to:
  /// **'Κλειστά'**
  String get closed;

  /// No description provided for @closedNow.
  ///
  /// In el, this message translates to:
  /// **'Κλειστό'**
  String get closedNow;

  /// No description provided for @opensAt.
  ///
  /// In el, this message translates to:
  /// **'Ανοίγει στις {time}'**
  String opensAt(String time);

  /// No description provided for @openingHours.
  ///
  /// In el, this message translates to:
  /// **'Ωράριο λειτουργίας'**
  String get openingHours;

  /// No description provided for @today.
  ///
  /// In el, this message translates to:
  /// **'Σήμερα'**
  String get today;

  /// No description provided for @tomorrow.
  ///
  /// In el, this message translates to:
  /// **'Αύριο'**
  String get tomorrow;

  /// No description provided for @admission.
  ///
  /// In el, this message translates to:
  /// **'Είσοδος'**
  String get admission;

  /// No description provided for @free.
  ///
  /// In el, this message translates to:
  /// **'Δωρεάν'**
  String get free;

  /// No description provided for @price.
  ///
  /// In el, this message translates to:
  /// **'Τιμή'**
  String get price;

  /// No description provided for @directions.
  ///
  /// In el, this message translates to:
  /// **'Οδηγίες'**
  String get directions;

  /// No description provided for @call.
  ///
  /// In el, this message translates to:
  /// **'Κλήση'**
  String get call;

  /// No description provided for @website.
  ///
  /// In el, this message translates to:
  /// **'Site'**
  String get website;

  /// No description provided for @book.
  ///
  /// In el, this message translates to:
  /// **'Κράτηση'**
  String get book;

  /// No description provided for @share.
  ///
  /// In el, this message translates to:
  /// **'Κοινοποίηση'**
  String get share;

  /// No description provided for @save.
  ///
  /// In el, this message translates to:
  /// **'Αποθήκευση'**
  String get save;

  /// No description provided for @registerForEvent.
  ///
  /// In el, this message translates to:
  /// **'Δήλωσε συμμετοχή'**
  String get registerForEvent;

  /// No description provided for @registered.
  ///
  /// In el, this message translates to:
  /// **'Εγγεγραμμένος'**
  String get registered;

  /// No description provided for @exhibitionsAndEvents.
  ///
  /// In el, this message translates to:
  /// **'Εκθέσεις & Events'**
  String get exhibitionsAndEvents;

  /// No description provided for @reviewsWithCount.
  ///
  /// In el, this message translates to:
  /// **'{count} κριτικές'**
  String reviewsWithCount(int count);

  /// No description provided for @distanceKm.
  ///
  /// In el, this message translates to:
  /// **'{distance}km μακριά'**
  String distanceKm(String distance);

  /// No description provided for @distanceM.
  ///
  /// In el, this message translates to:
  /// **'{distance}m μακριά'**
  String distanceM(String distance);

  /// No description provided for @signIn.
  ///
  /// In el, this message translates to:
  /// **'Σύνδεση'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In el, this message translates to:
  /// **'Εγγραφή'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In el, this message translates to:
  /// **'Αποσύνδεση'**
  String get signOut;

  /// No description provided for @email.
  ///
  /// In el, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In el, this message translates to:
  /// **'Κωδικός'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In el, this message translates to:
  /// **'Ονοματεπώνυμο'**
  String get fullName;

  /// No description provided for @signInWithGoogle.
  ///
  /// In el, this message translates to:
  /// **'Σύνδεση με Google'**
  String get signInWithGoogle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In el, this message translates to:
  /// **'Έχεις ήδη λογαριασμό;'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In el, this message translates to:
  /// **'Δεν έχεις λογαριασμό;'**
  String get dontHaveAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In el, this message translates to:
  /// **'Ξέχασες τον κωδικό;'**
  String get forgotPassword;

  /// No description provided for @language.
  ///
  /// In el, this message translates to:
  /// **'Γλώσσα'**
  String get language;

  /// No description provided for @greek.
  ///
  /// In el, this message translates to:
  /// **'Ελληνικά'**
  String get greek;

  /// No description provided for @english.
  ///
  /// In el, this message translates to:
  /// **'Αγγλικά'**
  String get english;

  /// No description provided for @settings.
  ///
  /// In el, this message translates to:
  /// **'Ρυθμίσεις'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In el, this message translates to:
  /// **'Ειδοποιήσεις'**
  String get notifications;

  /// No description provided for @about.
  ///
  /// In el, this message translates to:
  /// **'Σχετικά'**
  String get about;

  /// No description provided for @adminPanel.
  ///
  /// In el, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @activeEvents.
  ///
  /// In el, this message translates to:
  /// **'Ενεργά events'**
  String get activeEvents;

  /// No description provided for @totalRegistrations.
  ///
  /// In el, this message translates to:
  /// **'Εγγραφές'**
  String get totalRegistrations;

  /// No description provided for @viewsLastWeek.
  ///
  /// In el, this message translates to:
  /// **'Προβολές (7 μέρες)'**
  String get viewsLastWeek;

  /// No description provided for @totalSaved.
  ///
  /// In el, this message translates to:
  /// **'Αποθηκεύσεις'**
  String get totalSaved;

  /// No description provided for @myEvents.
  ///
  /// In el, this message translates to:
  /// **'Τα events μου'**
  String get myEvents;

  /// No description provided for @myPlaces.
  ///
  /// In el, this message translates to:
  /// **'Τα σημεία μου'**
  String get myPlaces;

  /// No description provided for @newEvent.
  ///
  /// In el, this message translates to:
  /// **'Νέο event'**
  String get newEvent;

  /// No description provided for @newPlace.
  ///
  /// In el, this message translates to:
  /// **'Νέο σημείο'**
  String get newPlace;

  /// No description provided for @statusActive.
  ///
  /// In el, this message translates to:
  /// **'Ενεργό'**
  String get statusActive;

  /// No description provided for @statusDraft.
  ///
  /// In el, this message translates to:
  /// **'Πρόχειρο'**
  String get statusDraft;

  /// No description provided for @statusPending.
  ///
  /// In el, this message translates to:
  /// **'Εκκρεμεί'**
  String get statusPending;

  /// No description provided for @formTitleEl.
  ///
  /// In el, this message translates to:
  /// **'Τίτλος (Ελληνικά)'**
  String get formTitleEl;

  /// No description provided for @formTitleEn.
  ///
  /// In el, this message translates to:
  /// **'Title (Αγγλικά)'**
  String get formTitleEn;

  /// No description provided for @formDescriptionEl.
  ///
  /// In el, this message translates to:
  /// **'Περιγραφή (Ελληνικά)'**
  String get formDescriptionEl;

  /// No description provided for @formDescriptionEn.
  ///
  /// In el, this message translates to:
  /// **'Description (Αγγλικά)'**
  String get formDescriptionEn;

  /// No description provided for @formCategory.
  ///
  /// In el, this message translates to:
  /// **'Κατηγορία'**
  String get formCategory;

  /// No description provided for @formStartDate.
  ///
  /// In el, this message translates to:
  /// **'Από'**
  String get formStartDate;

  /// No description provided for @formEndDate.
  ///
  /// In el, this message translates to:
  /// **'Έως'**
  String get formEndDate;

  /// No description provided for @formLocation.
  ///
  /// In el, this message translates to:
  /// **'Τοποθεσία'**
  String get formLocation;

  /// No description provided for @formSelectOnMap.
  ///
  /// In el, this message translates to:
  /// **'Επιλογή από χάρτη'**
  String get formSelectOnMap;

  /// No description provided for @formUploadImages.
  ///
  /// In el, this message translates to:
  /// **'+ Ανέβασμα εικόνων'**
  String get formUploadImages;

  /// No description provided for @formSaveDraft.
  ///
  /// In el, this message translates to:
  /// **'Πρόχειρο'**
  String get formSaveDraft;

  /// No description provided for @formPublish.
  ///
  /// In el, this message translates to:
  /// **'Δημοσίευση'**
  String get formPublish;

  /// No description provided for @monday.
  ///
  /// In el, this message translates to:
  /// **'Δευτέρα'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In el, this message translates to:
  /// **'Τρίτη'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In el, this message translates to:
  /// **'Τετάρτη'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In el, this message translates to:
  /// **'Πέμπτη'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In el, this message translates to:
  /// **'Παρασκευή'**
  String get friday;

  /// No description provided for @saturday.
  ///
  /// In el, this message translates to:
  /// **'Σάββατο'**
  String get saturday;

  /// No description provided for @sunday.
  ///
  /// In el, this message translates to:
  /// **'Κυριακή'**
  String get sunday;

  /// No description provided for @loading.
  ///
  /// In el, this message translates to:
  /// **'Φόρτωση...'**
  String get loading;

  /// No description provided for @errorGeneric.
  ///
  /// In el, this message translates to:
  /// **'Κάτι πήγε στραβά'**
  String get errorGeneric;

  /// No description provided for @retry.
  ///
  /// In el, this message translates to:
  /// **'Προσπάθησε ξανά'**
  String get retry;

  /// No description provided for @noResults.
  ///
  /// In el, this message translates to:
  /// **'Δεν βρέθηκαν αποτελέσματα'**
  String get noResults;

  /// No description provided for @seeAll.
  ///
  /// In el, this message translates to:
  /// **'Όλα'**
  String get seeAll;

  /// No description provided for @welcomeUser.
  ///
  /// In el, this message translates to:
  /// **'Γεια σου, {name}'**
  String welcomeUser(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['el', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
