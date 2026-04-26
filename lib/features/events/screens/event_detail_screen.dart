import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/category_labels.dart';
import '../../../core/utils/date_utils.dart' as du;
import '../../../models/event_model.dart';
import '../../../services/firestore_service.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  final _fs = FirestoreService();
  Event? _event;
  bool _loading = true;
  bool _isRegistered = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final event = await _fs.getEvent(widget.eventId);
    if (!mounted) return;
    if (event != null) {
      final user = context.read<AuthBloc>().state.user;
      if (user != null) {
        _isRegistered = await _fs.isRegisteredForEvent(event.id, user.uid);
      }
    }
    if (!mounted) return;
    setState(() {
      _event = event;
      _loading = false;
    });
  }

  Future<void> _register() async {
    final user = context.read<AuthBloc>().state.user;
    if (user == null || _event == null) return;
    await _fs.registerForEvent(
      eventId: _event!.id,
      userId: user.uid,
      name: user.displayName,
      email: user.email,
    );
    if (!mounted) return;
    setState(() => _isRegistered = true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_event == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(AppLocalizations.of(context).noResults)),
      );
    }

    final event = _event!;
    final locale = Localizations.localeOf(context).languageCode;
    final l10n = AppLocalizations.of(context);
    final category = event.category;

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
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Colors.white70,
                  child: Icon(Icons.share, color: AppColors.textPrimary),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: event.images.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: event.images.first,
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
                          CategoryLabels.eventLabel(category, context),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: category.darkColor,
                          ),
                        ),
                      ),
                      if (event.isLive) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('LIVE',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.title.value(locale),
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    label:
                        du.DateUtils.formatEventDate(event.startDate, locale),
                    subtitle:
                        'Έως ${du.DateUtils.formatEventDate(event.endDate, locale)}',
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: event.address.value(locale),
                  ),
                  const SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.euro_outlined,
                    label: event.isFree
                        ? l10n.free
                        : event.priceFrom != null
                            ? '${event.priceFrom!.toStringAsFixed(0)}€'
                            : '-',
                  ),
                  const SizedBox(height: 24),
                  Text(
                    event.description.value(locale),
                    style: const TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  if (event.ticketRequired)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isRegistered || event.isSoldOut || event.isPast
                                ? null
                                : _register,
                        child: Text(_isRegistered
                            ? l10n.registered
                            : event.isSoldOut
                                ? 'Sold out'
                                : l10n.registerForEvent),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;

  const _InfoRow({
    required this.icon,
    required this.label,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500)),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textTertiary)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
