// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Polis Events';

  @override
  String get home => 'Home';

  @override
  String get map => 'Map';

  @override
  String get calendar => 'Calendar';

  @override
  String get saved => 'Saved';

  @override
  String get profile => 'Profile';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get whatToDiscover => 'What would you like to discover?';

  @override
  String get searchPlaceholder => 'Search events & places...';

  @override
  String get tabToday => 'Today';

  @override
  String get tabDiscover => 'Discover';

  @override
  String get tabEvents => 'Events';

  @override
  String get tabPlaces => 'Places';

  @override
  String get explore => 'Explore';

  @override
  String get thisWeek => 'This week';

  @override
  String get popularPlaces => 'Popular places';

  @override
  String get upcomingEvents => 'Upcoming events';

  @override
  String get nearYou => 'Near you';

  @override
  String get places => 'Places';

  @override
  String get timeSlotAfternoon => 'Afternoon (12:00 - 17:00)';

  @override
  String get timeSlotEvening => 'Evening (17:00 - 21:00)';

  @override
  String get timeSlotNight => 'Late (21:00 - 00:00)';

  @override
  String get openPlacesNow => 'Open now';

  @override
  String get seeWholeWeek => 'See the whole week';

  @override
  String get nowLive => 'NOW';

  @override
  String get nowUpcoming => 'NEXT';

  @override
  String get happeningNow => 'Happening now';

  @override
  String startsInMinutes(int minutes) {
    return 'Starts in $minutes\'';
  }

  @override
  String get noEventsToday => 'No events today';

  @override
  String get noEventsTodayHint =>
      'See what\'s coming up this week or explore places';

  @override
  String get categoryMuseums => 'Museums';

  @override
  String get categoryHistorical => 'Historical & Archaeological';

  @override
  String get categoryCulturalCenters => 'Cultural centers';

  @override
  String get categoryGalleries => 'Galleries';

  @override
  String get categoryLibraries => 'Libraries';

  @override
  String get categoryNightlife => 'Food & Nightlife';

  @override
  String get categoryPerformances => 'Performances';

  @override
  String get categoryMusic => 'Music & DJ Sets';

  @override
  String get categoryExhibitions => 'Exhibitions';

  @override
  String get categoryFestivals => 'Festivals';

  @override
  String get categoryTours => 'Tours';

  @override
  String get categorySports => 'Sports';

  @override
  String placesCount(int count) {
    return '$count places';
  }

  @override
  String eventsCount(int count) {
    return '$count events';
  }

  @override
  String eventsThisWeek(int count) {
    return '$count events this week';
  }

  @override
  String get openNow => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get closedNow => 'Closed';

  @override
  String opensAt(String time) {
    return 'Opens at $time';
  }

  @override
  String get openingHours => 'Opening hours';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get admission => 'Admission';

  @override
  String get free => 'Free';

  @override
  String get price => 'Price';

  @override
  String get directions => 'Directions';

  @override
  String get call => 'Call';

  @override
  String get website => 'Site';

  @override
  String get book => 'Book';

  @override
  String get share => 'Share';

  @override
  String get save => 'Save';

  @override
  String get registerForEvent => 'Register';

  @override
  String get registered => 'Registered';

  @override
  String get exhibitionsAndEvents => 'Exhibitions & Events';

  @override
  String reviewsWithCount(int count) {
    return '$count reviews';
  }

  @override
  String distanceKm(String distance) {
    return '${distance}km away';
  }

  @override
  String distanceM(String distance) {
    return '${distance}m away';
  }

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Sign up';

  @override
  String get signOut => 'Sign out';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full name';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get language => 'Language';

  @override
  String get greek => 'Greek';

  @override
  String get english => 'English';

  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get about => 'About';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get activeEvents => 'Active events';

  @override
  String get totalRegistrations => 'Registrations';

  @override
  String get viewsLastWeek => 'Views (7 days)';

  @override
  String get totalSaved => 'Saves';

  @override
  String get myEvents => 'My events';

  @override
  String get myPlaces => 'My places';

  @override
  String get newEvent => 'New event';

  @override
  String get newPlace => 'New place';

  @override
  String get statusActive => 'Active';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusPending => 'Pending';

  @override
  String get formTitleEl => 'Title (Greek)';

  @override
  String get formTitleEn => 'Title (English)';

  @override
  String get formDescriptionEl => 'Description (Greek)';

  @override
  String get formDescriptionEn => 'Description (English)';

  @override
  String get formCategory => 'Category';

  @override
  String get formStartDate => 'From';

  @override
  String get formEndDate => 'To';

  @override
  String get formLocation => 'Location';

  @override
  String get formSelectOnMap => 'Pick on map';

  @override
  String get formUploadImages => '+ Upload images';

  @override
  String get formSaveDraft => 'Draft';

  @override
  String get formPublish => 'Publish';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get loading => 'Loading...';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get retry => 'Try again';

  @override
  String get noResults => 'No results';

  @override
  String get seeAll => 'See all';

  @override
  String welcomeUser(String name) {
    return 'Hi, $name';
  }
}
