import 'package:flutter/material.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/utils/category_labels.dart';
import '../../../models/event_model.dart';
import '../../../models/place_model.dart';
import '../../../services/firestore_service.dart';

/// Το "Σήμερα" tab - δείχνει τι γίνεται αυτή τη στιγμή και σήμερα.
/// Χωρίζει τα events σε time slots: Τώρα / Απόγευμα / Βράδυ.
class TodayTab extends StatelessWidget {
  final String cityId;
  final FirestoreService fs;

  const TodayTab({super.key, required this.cityId, required this.fs});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Event>>(
      stream: fs.todayEventsStream(cityId: cityId),
      builder: (context, eventsSnap) {
        if (eventsSnap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final events = eventsSnap.data ?? [];
        final l10n = AppLocalizations.of(context);
        final now = DateTime.now();

        if (events.isEmpty) {
          return _EmptyTodayState(l10n: l10n);
        }

        // Group events by time slot
        final live = events.where((e) => e.isLive).toList();
        final startingSoon = events.where((e) {
          if (!e.isUpcoming) return false;
          final diff = e.startDate.difference(now);
          return diff.inMinutes > 0 && diff.inMinutes <= 60;
        }).toList();
        final afternoon = _filterByHourRange(events, 12, 17);
        final evening = _filterByHourRange(events, 17, 21);
        final night = _filterByHourRange(events, 21, 24);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _DateHeader(now: now, eventCount: events.length),
            const SizedBox(height: 14),

            // ── LIVE NOW / STARTING SOON highlight ──
            if (live.isNotEmpty || startingSoon.isNotEmpty) ...[
              _NowHighlight(
                live: live,
                startingSoon: startingSoon,
              ),
              const SizedBox(height: 16),
            ],

            // ── Time slots ──
            if (_hasFutureIn(afternoon, now))
              _TimeSlotSection(
                title: l10n.timeSlotAfternoon,
                events: _futureOnly(afternoon, now),
              ),
            if (_hasFutureIn(evening, now))
              _TimeSlotSection(
                title: l10n.timeSlotEvening,
                events: _futureOnly(evening, now),
              ),
            if (_hasFutureIn(night, now))
              _TimeSlotSection(
                title: l10n.timeSlotNight,
                events: _futureOnly(night, now),
              ),

            const SizedBox(height: 8),

            // ── Open places now ──
            _OpenPlacesNow(cityId: cityId, fs: fs),

            const SizedBox(height: 20),

            // CTA για όλη τη βδομάδα
            Center(
              child: TextButton(
                onPressed: () {
                  // TODO: switch to calendar tab
                },
                child: Text(
                  '${l10n.seeWholeWeek} →',
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  List<Event> _filterByHourRange(
      List<Event> events, int startHour, int endHour) {
    return events.where((e) {
      final h = e.startDate.hour;
      return h >= startHour && h < endHour;
    }).toList();
  }

  List<Event> _futureOnly(List<Event> events, DateTime now) {
    return events.where((e) => e.startDate.isAfter(now)).toList();
  }

  bool _hasFutureIn(List<Event> events, DateTime now) {
    return events.any((e) => e.startDate.isAfter(now));
  }
}

// ─── Date header ─────────────────────────────────────────

class _DateHeader extends StatelessWidget {
  final DateTime now;
  final int eventCount;

  const _DateHeader({required this.now, required this.eventCount});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = _formatDate(now, locale, l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateStr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          l10n.eventsCount(eventCount),
          style: const TextStyle(fontSize: 12, color: AppColors.textTertiary),
        ),
      ],
    );
  }

  String _formatDate(DateTime d, String locale, AppLocalizations l10n) {
    final weekdays = locale == 'el'
        ? [
            'Δευτέρα',
            'Τρίτη',
            'Τετάρτη',
            'Πέμπτη',
            'Παρασκευή',
            'Σάββατο',
            'Κυριακή'
          ]
        : [
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday',
            'Sunday'
          ];
    final months = locale == 'el'
        ? [
            'Ιαν',
            'Φεβ',
            'Μαρ',
            'Απρ',
            'Μάι',
            'Ιουν',
            'Ιουλ',
            'Αυγ',
            'Σεπ',
            'Οκτ',
            'Νοε',
            'Δεκ'
          ]
        : [
            'Jan',
            'Feb',
            'Mar',
            'Apr',
            'May',
            'Jun',
            'Jul',
            'Aug',
            'Sep',
            'Oct',
            'Nov',
            'Dec'
          ];
    return '${weekdays[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }
}

// ─── "Τώρα" highlight ───────────────────────────────────

class _NowHighlight extends StatelessWidget {
  final List<Event> live;
  final List<Event> startingSoon;

  const _NowHighlight({required this.live, required this.startingSoon});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final now = DateTime.now();

    final event = live.isNotEmpty ? live.first : startingSoon.first;
    final isLive = live.isNotEmpty;

    String subtitle;
    if (isLive) {
      subtitle = l10n.happeningNow;
    } else {
      final minutes = event.startDate.difference(now).inMinutes;
      subtitle = l10n.startsInMinutes(minutes);
    }

    return GestureDetector(
      onTap: () => context.go('/event/${event.id}'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primaryBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isLive ? AppColors.error : AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    isLive ? l10n.nowLive : l10n.nowUpcoming,
                    style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              event.title.value(locale),
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryDark),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle + (event.isFree ? '  ·  ${l10n.free}' : ''),
              style: const TextStyle(fontSize: 12, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Time slot section ──────────────────────────────────

class _TimeSlotSection extends StatelessWidget {
  final String title;
  final List<Event> events;

  const _TimeSlotSection({required this.title, required this.events});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 6),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary),
          ),
        ),
        for (final e in events)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _TimelineEventCard(event: e),
          ),
      ],
    );
  }
}

// ─── Timeline event card ────────────────────────────────

class _TimelineEventCard extends StatelessWidget {
  final Event event;

  const _TimelineEventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final time = _formatTime(event.startDate);
    final duration = _formatDuration(event.endDate.difference(event.startDate));

    return GestureDetector(
      onTap: () => context.go('/event/${event.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              // Time column
              Container(
                width: 60,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(color: AppColors.border, width: 0.5),
                  ),
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      time,
                      style: const TextStyle(
                          fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    if (duration != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        duration,
                        style: const TextStyle(
                            fontSize: 9, color: AppColors.textTertiary),
                      ),
                    ],
                  ],
                ),
              ),
              // Details column
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.title.value(locale),
                        style: const TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        event.address.value(locale),
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: event.category.bgColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              CategoryLabels.eventLabel(
                                  event.category, context),
                              style: TextStyle(
                                  fontSize: 9, color: event.category.darkColor),
                            ),
                          ),
                          if (event.isFree)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.successBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppLocalizations.of(context).free,
                                style: const TextStyle(
                                    fontSize: 9, color: AppColors.successDark),
                              ),
                            )
                          else if (event.priceFrom != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.warningBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${event.priceFrom!.toStringAsFixed(0)}€',
                                style: const TextStyle(
                                    fontSize: 9, color: AppColors.warningDark),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String? _formatDuration(Duration d) {
    if (d.inMinutes < 30) return null;
    if (d.inHours < 1) return '${d.inMinutes}\''; // μόνο λεπτά
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}\'';
  }
}

// ─── Open places now ────────────────────────────────────

class _OpenPlacesNow extends StatelessWidget {
  final String cityId;
  final FirestoreService fs;

  const _OpenPlacesNow({required this.cityId, required this.fs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return StreamBuilder<List<Place>>(
      stream: fs.placesStream(cityId: cityId, limit: 50),
      builder: (context, snap) {
        final allPlaces = snap.data ?? [];
        final openNow = allPlaces.where((p) => p.isOpenNow()).take(3).toList();

        if (openNow.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.openPlacesNow,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary),
                  ),
                  Text(
                    '${openNow.length} ${l10n.places.toLowerCase()}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textTertiary),
                  ),
                ],
              ),
            ),
            for (final p in openNow)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _OpenPlaceRow(place: p),
              ),
          ],
        );
      },
    );
  }
}

class _OpenPlaceRow extends StatelessWidget {
  final Place place;

  const _OpenPlaceRow({required this.place});

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);

    return GestureDetector(
      onTap: () => context.go('/place/${place.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border, width: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: place.category.bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                place.category.icon,
                size: 18,
                color: place.category.darkColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name.value(locale),
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CategoryLabels.placeLabel(place.category, context),
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                l10n.openNow,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.successDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty state ────────────────────────────────────────

class _EmptyTodayState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyTodayState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.event_busy_outlined,
                size: 32,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.noEventsToday,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.noEventsTodayHint,
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
