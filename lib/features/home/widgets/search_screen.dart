import 'package:flutter/material.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Universal search - ψάχνει σε events + places + categories.
class SearchScreen extends StatefulWidget {
  final String cityId;

  const SearchScreen({super.key, required this.cityId});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  bool _loading = false;

  List<_SearchResult> _places = [];
  List<_SearchResult> _events = [];
  List<_SearchResult> _categories = [];

  // Static categories - μπορεί ο χρήστης να ψάξει πχ "μουσεία"
  static const _allCategories = <_SearchResult>[
    _SearchResult(
        id: 'museum',
        type: _ResultType.category,
        title: 'Μουσεία',
        subtitle: 'Όλα τα μουσεία',
        keywords: ['μουσεία', 'museum', 'μουσείο']),
    _SearchResult(
        id: 'historical',
        type: _ResultType.category,
        title: 'Ιστορικά & Αρχαιολογικά',
        subtitle: 'Ιστορικοί και αρχαιολογικοί χώροι',
        keywords: ['ιστορικά', 'αρχαιολογικά', 'historical', 'archaeological']),
    _SearchResult(
        id: 'cultural',
        type: _ResultType.category,
        title: 'Πολιτιστικά Κέντρα',
        subtitle: 'Πολιτιστικοί χώροι',
        keywords: ['πολιτιστικά', 'cultural']),
    _SearchResult(
        id: 'gallery',
        type: _ResultType.category,
        title: 'Γκαλερί',
        subtitle: 'Πινακοθήκες & εκθέσεις',
        keywords: ['γκαλερί', 'πινακοθήκη', 'gallery']),
    _SearchResult(
        id: 'library',
        type: _ResultType.category,
        title: 'Βιβλιοθήκες',
        subtitle: 'Δημόσιες βιβλιοθήκες',
        keywords: ['βιβλιοθήκη', 'library']),
    _SearchResult(
        id: 'nightlife',
        type: _ResultType.category,
        title: 'Εστίαση & Nightlife',
        subtitle: 'Bars, εστιατόρια, cafes',
        keywords: ['nightlife', 'bar', 'cafe', 'εστιατόριο']),
    _SearchResult(
        id: 'performance',
        type: _ResultType.category,
        title: 'Παραστάσεις',
        subtitle: 'Θεατρικές παραστάσεις',
        keywords: ['παράσταση', 'θέατρο', 'performance']),
    _SearchResult(
        id: 'music',
        type: _ResultType.category,
        title: 'Μουσική & DJ Sets',
        subtitle: 'Live μουσική & DJ',
        keywords: ['μουσική', 'music', 'dj']),
    _SearchResult(
        id: 'exhibition',
        type: _ResultType.category,
        title: 'Εκθέσεις',
        subtitle: 'Εκθέσεις τέχνης',
        keywords: ['έκθεση', 'exhibition']),
    _SearchResult(
        id: 'festival',
        type: _ResultType.category,
        title: 'Φεστιβάλ',
        subtitle: 'Φεστιβάλ & εκδηλώσεις',
        keywords: ['φεστιβάλ', 'festival']),
    _SearchResult(
        id: 'tour',
        type: _ResultType.category,
        title: 'Ξεναγήσεις',
        subtitle: 'Καθοδηγούμενες ξεναγήσεις',
        keywords: ['ξενάγηση', 'tour']),
    _SearchResult(
        id: 'sports',
        type: _ResultType.category,
        title: 'Αθλητικά',
        subtitle: 'Αθλητικές εκδηλώσεις',
        keywords: ['αθλητικά', 'sports']),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    final lower = query.trim().toLowerCase();

    if (lower.isEmpty) {
      setState(() {
        _places = [];
        _events = [];
        _categories = [];
      });
      return;
    }

    setState(() => _loading = true);

    try {
      // Categories - in-memory search
      final matchedCategories = _allCategories
          .where((c) =>
              c.title.toLowerCase().contains(lower) ||
              c.keywords.any((k) => k.toLowerCase().contains(lower)))
          .toList();

      // Places - Firestore search
      final placesSnap = await FirebaseFirestore.instance
          .collection('places')
          .where('cityId', isEqualTo: widget.cityId)
          .where('published', isEqualTo: true)
          .limit(50)
          .get();

      final placeResults = <_SearchResult>[];
      for (final doc in placesSnap.docs) {
        final data = doc.data();
        final nameEl = (data['name']?['el'] as String?)?.toLowerCase() ?? '';
        final nameEn = (data['name']?['en'] as String?)?.toLowerCase() ?? '';
        final tags = (data['tags'] as List?)?.cast<String>() ?? [];
        final tagsLower = tags.map((t) => t.toLowerCase()).toList();

        if (nameEl.contains(lower) ||
            nameEn.contains(lower) ||
            tagsLower.any((t) => t.contains(lower))) {
          placeResults.add(_SearchResult(
            id: doc.id,
            type: _ResultType.place,
            title: data['name']?['el'] ?? doc.id,
            subtitle: data['address']?['el'] ?? '',
            keywords: const [],
          ));
        }
      }

      // Events - Firestore search
      final eventsSnap = await FirebaseFirestore.instance
          .collection('events')
          .where('cityId', isEqualTo: widget.cityId)
          .where('status', isEqualTo: 'published')
          .limit(50)
          .get();

      final eventResults = <_SearchResult>[];
      for (final doc in eventsSnap.docs) {
        final data = doc.data();
        final titleEl = (data['title']?['el'] as String?)?.toLowerCase() ?? '';
        final titleEn = (data['title']?['en'] as String?)?.toLowerCase() ?? '';

        if (titleEl.contains(lower) || titleEn.contains(lower)) {
          final start = (data['startDate'] as Timestamp?)?.toDate();
          final dateStr = start != null
              ? '${start.day}/${start.month} · ${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}'
              : '';
          eventResults.add(_SearchResult(
            id: doc.id,
            type: _ResultType.event,
            title: data['title']?['el'] ?? doc.id,
            subtitle: dateStr,
            keywords: const [],
          ));
        }
      }

      if (mounted) {
        setState(() {
          _categories = matchedCategories;
          _places = placeResults;
          _events = eventResults;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: l10n.searchPlaceholder,
            border: InputBorder.none,
            hintStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.textTertiary,
            ),
          ),
          style: const TextStyle(fontSize: 14),
          onChanged: (v) {
            setState(() => _query = v);
            _search(v);
          },
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () {
                _controller.clear();
                setState(() {
                  _query = '';
                  _places = [];
                  _events = [];
                  _categories = [];
                });
              },
            ),
        ],
      ),
      body: _query.isEmpty
          ? _buildEmptyState()
          : _loading
              ? const Center(child: CircularProgressIndicator())
              : _buildResults(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.search,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ψάξε σε events και σημεία',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Πληκτρολόγησε όνομα, κατηγορία ή λέξη-κλειδί',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final hasResults =
        _places.isNotEmpty || _events.isNotEmpty || _categories.isNotEmpty;

    if (!hasResults) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search_off,
                  size: 48, color: AppColors.textTertiary),
              const SizedBox(height: 16),
              Text(
                'Δεν βρέθηκαν αποτελέσματα για "$_query"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (_places.isNotEmpty) ...[
          const _SectionHeader(title: 'ΣΗΜΕΙΑ'),
          ..._places.map((r) => _ResultRow(
                result: r,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/place/${r.id}');
                },
              )),
        ],
        if (_events.isNotEmpty) ...[
          const _SectionHeader(title: 'EVENTS'),
          ..._events.map((r) => _ResultRow(
                result: r,
                onTap: () {
                  Navigator.of(context).pop();
                  context.go('/event/${r.id}');
                },
              )),
        ],
        if (_categories.isNotEmpty) ...[
          const _SectionHeader(title: 'ΚΑΤΗΓΟΡΙΕΣ'),
          ..._categories.map((r) => _ResultRow(
                result: r,
                onTap: () {
                  Navigator.of(context).pop();
                  // TODO: filter by category
                },
              )),
        ],
        const SizedBox(height: 20),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final _SearchResult result;
  final VoidCallback onTap;

  const _ResultRow({required this.result, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final iconData = _iconForType(result.type);
    final iconColor = _colorForType(result.type);
    final iconBg = _bgColorForType(result.type);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(iconData, size: 18, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (result.subtitle.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      result.subtitle,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 12, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  IconData _iconForType(_ResultType type) {
    switch (type) {
      case _ResultType.place:
        return Icons.place_outlined;
      case _ResultType.event:
        return Icons.event_outlined;
      case _ResultType.category:
        return Icons.category_outlined;
    }
  }

  Color _colorForType(_ResultType type) {
    switch (type) {
      case _ResultType.place:
        return const Color(0xFF0F6E56);
      case _ResultType.event:
        return const Color(0xFF993C1D);
      case _ResultType.category:
        return AppColors.primary;
    }
  }

  Color _bgColorForType(_ResultType type) {
    switch (type) {
      case _ResultType.place:
        return const Color(0xFFE1F5EE);
      case _ResultType.event:
        return const Color(0xFFFAECE7);
      case _ResultType.category:
        return AppColors.primaryBg;
    }
  }
}

enum _ResultType { place, event, category }

class _SearchResult {
  final String id;
  final _ResultType type;
  final String title;
  final String subtitle;
  final List<String> keywords;

  const _SearchResult({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.keywords,
  });
}
