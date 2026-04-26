import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/data/subcategories_data.dart';

/// Screen που εμφανίζει τις υποκατηγορίες μιας κατηγορίας.
/// Π.χ. "Πολιτισμός" → Μουσεία, Αρχαιολογικά, Πινακοθήκες, ...
class CategoryScreen extends StatelessWidget {
  final String categoryId;
  final String cityId;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    this.cityId = 'ioannina',
  });

  @override
  Widget build(BuildContext context) {
    final category = CategoriesData.find(categoryId);

    if (category == null) {
      return _buildNotFound(context);
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          category.label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: category.subcategories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final sub = category.subcategories[i];
          return _SubcategoryTile(
            categoryId: categoryId,
            sub: sub,
            cityId: cityId,
          );
        },
      ),
    );
  }

  Widget _buildNotFound(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Text('Κατηγορία δε βρέθηκε',
            style: TextStyle(color: AppColors.textTertiary)),
      ),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  final String categoryId;
  final SubcategoryInfo sub;
  final String cityId;

  const _SubcategoryTile({
    required this.categoryId,
    required this.sub,
    required this.cityId,
  });

  // Γαλάζια παλέτα της εφαρμογής
  static const _bg = Color(0xFFE6F1FB);
  static const _border = Color(0xFFB5D4F4);
  static const _text = Color(0xFF0C447C);
  static const _muted = Color(0xFF185FA5);

  /// Count places στη subcategory για visual feedback.
  Stream<int> _placeCountStream() {
    if (sub.firestoreCategories.isEmpty) {
      return Stream.value(0);
    }
    return FirebaseFirestore.instance
        .collection('places')
        .where('cityId', isEqualTo: cityId)
        .where('category', whereIn: sub.firestoreCategories)
        .where('published', isEqualTo: true)
        .snapshots()
        .map((s) => s.docs.length);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/category/$categoryId/sub/${sub.id}'),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _bg,
          border: Border.all(color: _border, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    sub.label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _text,
                    ),
                  ),
                ),
                StreamBuilder<int>(
                  stream: _placeCountStream(),
                  builder: (context, snap) {
                    final count = snap.data ?? 0;
                    return Text(
                      count > 0 ? '$count σημεία' : '',
                      style: const TextStyle(
                        fontSize: 11,
                        color: _muted,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 6),
                const Icon(Icons.chevron_right, size: 18, color: _muted),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              sub.description,
              style: const TextStyle(
                fontSize: 12,
                color: _muted,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
