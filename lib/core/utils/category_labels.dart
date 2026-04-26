import 'package:flutter/material.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';

import '../../models/category.dart';

/// Βοηθός για να παίρνουμε localized labels των κατηγοριών.
class CategoryLabels {
  CategoryLabels._();

  static String placeLabel(PlaceCategory c, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (c) {
      case PlaceCategory.museum:
        return l10n.categoryMuseums;
      case PlaceCategory.historical:
        return l10n.categoryHistorical;
      case PlaceCategory.cultural:
        return l10n.categoryCulturalCenters;
      case PlaceCategory.gallery:
        return l10n.categoryGalleries;
      case PlaceCategory.library:
        return l10n.categoryLibraries;
      case PlaceCategory.nightlife:
        return l10n.categoryNightlife;
    }
  }

  static String eventLabel(EventCategory c, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (c) {
      case EventCategory.performance:
        return l10n.categoryPerformances;
      case EventCategory.music:
        return l10n.categoryMusic;
      case EventCategory.exhibition:
        return l10n.categoryExhibitions;
      case EventCategory.festival:
        return l10n.categoryFestivals;
      case EventCategory.tour:
        return l10n.categoryTours;
      case EventCategory.sports:
        return l10n.categorySports;
    }
  }
}
