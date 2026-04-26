import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// Κατηγορίες για μόνιμα σημεία (places).
enum PlaceCategory {
  museum,
  historical,
  cultural,
  gallery,
  library,
  nightlife;

  String get key => name;

  static PlaceCategory fromKey(String key) {
    return PlaceCategory.values.firstWhere(
      (c) => c.key == key,
      orElse: () => PlaceCategory.cultural,
    );
  }

  Color get color {
    switch (this) {
      case PlaceCategory.museum:
        return AppColors.categoryMuseum;
      case PlaceCategory.historical:
        return AppColors.categoryHistorical;
      case PlaceCategory.cultural:
        return AppColors.categoryCultural;
      case PlaceCategory.gallery:
        return AppColors.categoryGallery;
      case PlaceCategory.library:
        return AppColors.categoryLibrary;
      case PlaceCategory.nightlife:
        return AppColors.categoryNightlife;
    }
  }

  Color get bgColor {
    switch (this) {
      case PlaceCategory.museum:
        return AppColors.categoryMuseumBg;
      case PlaceCategory.historical:
        return AppColors.categoryHistoricalBg;
      case PlaceCategory.cultural:
        return AppColors.categoryCulturalBg;
      case PlaceCategory.gallery:
        return AppColors.categoryGalleryBg;
      case PlaceCategory.library:
        return AppColors.categoryLibraryBg;
      case PlaceCategory.nightlife:
        return AppColors.categoryNightlifeBg;
    }
  }

  Color get darkColor {
    switch (this) {
      case PlaceCategory.museum:
        return AppColors.categoryMuseumDark;
      case PlaceCategory.historical:
        return AppColors.categoryHistoricalDark;
      case PlaceCategory.cultural:
        return AppColors.categoryCulturalDark;
      case PlaceCategory.gallery:
        return AppColors.categoryGalleryDark;
      case PlaceCategory.library:
        return AppColors.categoryLibraryDark;
      case PlaceCategory.nightlife:
        return AppColors.categoryNightlifeDark;
    }
  }

  IconData get icon {
    switch (this) {
      case PlaceCategory.museum:
        return Icons.account_balance;
      case PlaceCategory.historical:
        return Icons.castle;
      case PlaceCategory.cultural:
        return Icons.theater_comedy;
      case PlaceCategory.gallery:
        return Icons.palette;
      case PlaceCategory.library:
        return Icons.menu_book;
      case PlaceCategory.nightlife:
        return Icons.local_bar;
    }
  }
}

/// Κατηγορίες για events.
enum EventCategory {
  performance,
  music,
  exhibition,
  festival,
  tour,
  sports;

  String get key => name;

  static EventCategory fromKey(String key) {
    return EventCategory.values.firstWhere(
      (c) => c.key == key,
      orElse: () => EventCategory.performance,
    );
  }

  Color get color {
    switch (this) {
      case EventCategory.performance:
        return AppColors.categoryPerformance;
      case EventCategory.music:
        return AppColors.categoryMusic;
      case EventCategory.exhibition:
        return AppColors.categoryExhibition;
      case EventCategory.festival:
        return AppColors.categoryFestival;
      case EventCategory.tour:
        return AppColors.categoryTour;
      case EventCategory.sports:
        return AppColors.categorySports;
    }
  }

  Color get bgColor {
    switch (this) {
      case EventCategory.performance:
        return AppColors.categoryPerformanceBg;
      case EventCategory.music:
        return AppColors.categoryMusicBg;
      case EventCategory.exhibition:
        return AppColors.categoryExhibitionBg;
      case EventCategory.festival:
        return AppColors.categoryFestivalBg;
      case EventCategory.tour:
        return AppColors.categoryTourBg;
      case EventCategory.sports:
        return AppColors.categorySportsBg;
    }
  }

  Color get darkColor {
    switch (this) {
      case EventCategory.performance:
        return AppColors.categoryPerformanceDark;
      case EventCategory.music:
        return AppColors.categoryMusicDark;
      case EventCategory.exhibition:
        return AppColors.categoryExhibitionDark;
      case EventCategory.festival:
        return AppColors.categoryFestivalDark;
      case EventCategory.tour:
        return AppColors.categoryTourDark;
      case EventCategory.sports:
        return AppColors.categorySportsDark;
    }
  }

  IconData get icon {
    switch (this) {
      case EventCategory.performance:
        return Icons.theaters;
      case EventCategory.music:
        return Icons.music_note;
      case EventCategory.exhibition:
        return Icons.image;
      case EventCategory.festival:
        return Icons.celebration;
      case EventCategory.tour:
        return Icons.map_outlined;
      case EventCategory.sports:
        return Icons.sports_basketball;
    }
  }
}
