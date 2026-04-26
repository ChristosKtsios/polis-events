import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/category_labels.dart';
import '../../models/place_model.dart';

/// Card που εμφανίζει ένα μόνιμο σημείο.
class PlaceCard extends StatelessWidget {
  final Place place;

  const PlaceCard({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    final isOpen = place.isOpenNow();
    final category = place.category;

    return GestureDetector(
      onTap: () => context.go('/place/${place.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: place.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: place.images.first,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: category.bgColor),
                      errorWidget: (_, __, ___) =>
                          Container(color: category.bgColor),
                    )
                  : Container(
                      color: category.bgColor,
                      alignment: Alignment.center,
                      child: Icon(category.icon,
                          size: 32, color: category.darkColor),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          place.name.value(locale),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: category.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          CategoryLabels.placeLabel(category, context),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: category.darkColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.address.value(locale),
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        isOpen ? l10n.openNow : l10n.closedNow,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isOpen ? AppColors.success : AppColors.error,
                        ),
                      ),
                      if (place.rating > 0) ...[
                        const SizedBox(width: 8),
                        const Text('·',
                            style: TextStyle(color: AppColors.textTertiary)),
                        const SizedBox(width: 8),
                        const Icon(Icons.star,
                            size: 12, color: Color(0xFFEF9F27)),
                        const SizedBox(width: 2),
                        Text(
                          place.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
