import 'package:flutter/material.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';

import '../../../models/event_model.dart';
import '../../../services/firestore_service.dart';
import '../../../shared/widgets/event_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _fs = FirestoreService();
  static const _selectedCityId = 'ioannina';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.calendar)),
      body: StreamBuilder<List<Event>>(
        stream: _fs.upcomingEventsStream(cityId: _selectedCityId, limit: 50),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final events = snap.data ?? [];
          if (events.isEmpty) return Center(child: Text(l10n.noResults));

          // Group events by date
          final grouped = <DateTime, List<Event>>{};
          for (final e in events) {
            final key =
                DateTime(e.startDate.year, e.startDate.month, e.startDate.day);
            grouped.putIfAbsent(key, () => []).add(e);
          }
          final dates = grouped.keys.toList()..sort();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dates.length,
            itemBuilder: (_, i) {
              final date = dates[i];
              final dayEvents = grouped[date]!;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${date.day}/${date.month}/${date.year}',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ),
                    for (final e in dayEvents)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: EventCard(event: e),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
