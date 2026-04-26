import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/category_labels.dart';
import '../../../core/utils/date_utils.dart' as du;
import '../../../models/event_model.dart';
import '../../../models/place_model.dart';
import '../../../services/firestore_service.dart';

class PlaceDetailScreen extends StatefulWidget {
  final String placeId;
  const PlaceDetailScreen({super.key, required this.placeId});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  final _fs = FirestoreService();
  Place? _place;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final place = await _fs.getPlace(widget.placeId);
    if (!mounted) return;
    setState(() {
      _place = place;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_place == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(AppLocalizations.of(context).noResults)),
      );
    }

    final place = _place!;
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    final category = place.category;
    final isOpen = place.isOpenNow();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(Icons.arrow_back, color: AppColors.textPrimary),
              ),
              onPressed: () => context.go('/'),
            ),
            actions: [
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white70,
                  child:
                      Icon(Icons.favorite_border, color: AppColors.textPrimary),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: place.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: place.images.first,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: category.bgColor),
                      errorWidget: (_, __, ___) =>
                          Container(color: category.bgColor),
                    )
                  : Container(
                      color: category.bgColor,
                      alignment: Alignment.center,
                      child: Icon(category.icon,
                          size: 60, color: category.darkColor),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: category.bgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          CategoryLabels.placeLabel(category, context),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: category.darkColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:
                              isOpen ? AppColors.successBg : AppColors.errorBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          isOpen ? l10n.openNow : l10n.closedNow,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: isOpen
                                ? AppColors.successDark
                                : AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    place.name.value(locale),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  if (place.rating > 0) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            size: 14, color: Color(0xFFEF9F27)),
                        const SizedBox(width: 4),
                        Text(place.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(width: 4),
                        Text(l10n.reviewsWithCount(place.reviewCount),
                            style: const TextStyle(
                                fontSize: 12, color: AppColors.textTertiary)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.directions, size: 16),
                          label: Text(l10n.directions),
                          onPressed: () => _openDirections(place),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (place.phone != null)
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.phone_outlined, size: 16),
                            label: Text(l10n.call),
                            onPressed: () =>
                                launchUrl(Uri.parse('tel:${place.phone}')),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    place.description.value(locale),
                    style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),

                  // Opening hours
                  _OpeningHoursCard(place: place),
                  const SizedBox(height: 16),

                  // Address
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 18, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(place.address.value(locale),
                                style: const TextStyle(fontSize: 13))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Events που φιλοξενεί
                  Text(l10n.upcomingEvents,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary)),
                  const SizedBox(height: 10),
                  StreamBuilder<List<Event>>(
                    stream: _fs.eventsForPlace(place.id),
                    builder: (context, snap) {
                      final events = snap.data ?? [];
                      if (events.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(l10n.noResults,
                              style: const TextStyle(
                                  color: AppColors.textTertiary)),
                        );
                      }
                      return Column(
                        children: events
                            .map((e) => _PlaceEventListItem(event: e))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openDirections(Place place) async {
    final lat = place.location.latitude;
    final lng = place.location.longitude;
    final url = Uri.parse(
        'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}

class _OpeningHoursCard extends StatelessWidget {
  final Place place;
  const _OpeningHoursCard({required this.place});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hours = place.openingHours;
    final now = DateTime.now();

    Widget row(String day, DayHours h, {bool bold = false}) {
      final text =
          h.closed ? l10n.closed : '${h.openTime ?? ''} - ${h.closeTime ?? ''}';
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(day,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                    color: bold
                        ? AppColors.textPrimary
                        : AppColors.textSecondary)),
            Text(text,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
                    color: bold
                        ? (place.isOpenNow()
                            ? AppColors.successDark
                            : AppColors.error)
                        : AppColors.textSecondary)),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.openingHours,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          row(l10n.today, hours.forDay(now.weekday), bold: true),
          row(l10n.monday, hours.monday),
          row(l10n.tuesday, hours.tuesday),
          row(l10n.wednesday, hours.wednesday),
          row(l10n.thursday, hours.thursday),
          row(l10n.friday, hours.friday),
          row(l10n.saturday, hours.saturday),
          row(l10n.sunday, hours.sunday),
        ],
      ),
    );
  }
}

class _PlaceEventListItem extends StatelessWidget {
  final Event event;
  const _PlaceEventListItem({required this.event});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    return GestureDetector(
      onTap: () => context.go('/event/${event.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title.value(locale),
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(du.DateUtils.formatEventDate(event.startDate, locale),
                      style: const TextStyle(
                          fontSize: 11, color: AppColors.textTertiary)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: event.category.bgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                CategoryLabels.eventLabel(event.category, context),
                style: TextStyle(
                  fontSize: 10,
                  color: event.category.darkColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
