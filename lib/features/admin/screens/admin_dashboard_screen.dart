import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/event_model.dart';
import '../../../services/firestore_service.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = context.watch<AuthBloc>().state.user;
    final orgId = user?.organizationId;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.adminPanel)),
      body: orgId == null
          ? Center(child: Text(l10n.noResults))
          : _AdminContent(orgId: orgId),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text(l10n.newEvent),
        icon: const Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _AdminContent extends StatelessWidget {
  final String orgId;
  const _AdminContent({required this.orgId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fs = FirestoreService();

    return StreamBuilder<List<Event>>(
      stream: fs.eventsForOrganization(orgId),
      builder: (context, snap) {
        final events = snap.data ?? [];
        final active =
            events.where((e) => e.status == EventStatus.published).length;
        final totalReg =
            events.fold<int>(0, (s, e) => s + e.currentRegistrations);

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '$active',
                    label: l10n.activeEvents,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    value: '$totalReg',
                    label: l10n.totalRegistrations,
                    color: AppColors.categoryHistorical,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(l10n.myEvents,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            for (final e in events)
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border:
                      Border.all(color: AppColors.border, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.title.el,
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text(_statusLabel(e.status, l10n),
                              style: TextStyle(
                                fontSize: 11,
                                color: _statusColor(e.status),
                              )),
                        ],
                      ),
                    ),
                    Text('${e.currentRegistrations}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  String _statusLabel(EventStatus s, AppLocalizations l10n) {
    switch (s) {
      case EventStatus.published:
        return l10n.statusActive;
      case EventStatus.draft:
        return l10n.statusDraft;
      case EventStatus.cancelled:
        return 'Cancelled';
      case EventStatus.ended:
        return 'Ended';
    }
  }

  Color _statusColor(EventStatus s) {
    switch (s) {
      case EventStatus.published:
        return AppColors.success;
      case EventStatus.draft:
        return AppColors.warning;
      case EventStatus.cancelled:
        return AppColors.error;
      case EventStatus.ended:
        return AppColors.textTertiary;
    }
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatCard(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
