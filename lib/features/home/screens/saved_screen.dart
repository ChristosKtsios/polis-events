import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../models/place_model.dart';
import '../../../services/firestore_service.dart';
import '../../../shared/widgets/event_card.dart';
import '../../../shared/widgets/place_card.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = context.watch<AuthBloc>().state.user;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.saved),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          tabs: [
            Tab(text: l10n.tabEvents),
            Tab(text: l10n.tabPlaces),
          ],
        ),
      ),
      body: user == null
          ? Center(child: Text(l10n.signIn))
          : TabBarView(
              controller: _tab,
              children: [
                _SavedEventsList(ids: user.savedEvents),
                _SavedPlacesList(ids: user.savedPlaces),
              ],
            ),
    );
  }
}

class _SavedEventsList extends StatelessWidget {
  final List<String> ids;
  const _SavedEventsList({required this.ids});

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();
    if (ids.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(context).noResults,
              style: const TextStyle(color: AppColors.textTertiary)));
    }
    return FutureBuilder<List<Event?>>(
      future: Future.wait(ids.map(fs.getEvent)),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final events = snap.data!.whereType<Event>().toList();
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => EventCard(event: events[i]),
        );
      },
    );
  }
}

class _SavedPlacesList extends StatelessWidget {
  final List<String> ids;
  const _SavedPlacesList({required this.ids});

  @override
  Widget build(BuildContext context) {
    final fs = FirestoreService();
    if (ids.isEmpty) {
      return Center(
          child: Text(AppLocalizations.of(context).noResults,
              style: const TextStyle(color: AppColors.textTertiary)));
    }
    return FutureBuilder<List<Place?>>(
      future: Future.wait(ids.map(fs.getPlace)),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final places = snap.data!.whereType<Place>().toList();
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: places.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => PlaceCard(place: places[i]),
        );
      },
    );
  }
}
