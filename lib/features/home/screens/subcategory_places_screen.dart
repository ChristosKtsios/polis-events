import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/data/subcategories_data.dart';
import '../widgets/place_detail_bottom_sheet.dart';

/// Subcategory places list - compact rows, 3+ visible.
/// Tap opens bottom sheet με χάρτη + φωτογραφίες + info.
class SubcategoryPlacesScreen extends StatelessWidget {
  final String categoryId;
  final String subcategoryId;
  final String cityId;

  const SubcategoryPlacesScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    this.cityId = 'ioannina',
  });

  @override
  Widget build(BuildContext context) {
    final sub = CategoriesData.findSub(categoryId, subcategoryId);

    if (sub == null) {
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
          sub.label,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('places')
            .where('cityId', isEqualTo: cityId)
            .where('category', whereIn: sub.firestoreCategories)
            .where('published', isEqualTo: true)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snap.data?.docs ?? [];

          if (docs.isEmpty) {
            return _buildEmpty(sub);
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 6),
            itemBuilder: (context, i) => _CompactPlaceCard(doc: docs[i]),
          );
        },
      ),
    );
  }

  Widget _buildEmpty(SubcategoryInfo sub) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFE6F1FB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.search_off,
                size: 32,
                color: Color(0xFF185FA5),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Δεν βρέθηκαν προτεινόμενα',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              'Για ${sub.label.toLowerCase()} σε αυτή την πόλη',
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        child: Text('Υποκατηγορία δε βρέθηκε'),
      ),
    );
  }
}

/// Compact card - 3+ visible per screen.
class _CompactPlaceCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const _CompactPlaceCard({required this.doc});

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>;
    final name = (data['name']?['el'] as String?) ?? doc.id;
    final address = (data['address']?['el'] as String?) ?? '';
    final priceFrom = data['priceFrom'] as num?;
    final isFree = data['isFree'] == true;
    final rating = (data['rating'] as num?)?.toDouble();
    final images = (data['images'] as List?)?.cast<String>() ?? [];
    final imageUrl = images.isNotEmpty ? images.first : null;

    return InkWell(
      onTap: () => _openBottomSheet(context),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: const Color(0xFFE5EFF8), width: 0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 56,
                height: 56,
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _placeholder(),
                        loadingBuilder: (ctx, child, prog) {
                          if (prog == null) return child;
                          return _placeholder();
                        },
                      )
                    : _placeholder(),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      if (isFree)
                        const Text(
                          'Δωρεάν',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1D9E75),
                          ),
                        )
                      else if (priceFrom != null)
                        Text(
                          '€${priceFrom.toInt()}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      if (rating != null) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Text('·',
                              style: TextStyle(
                                  fontSize: 10, color: AppColors.textTertiary)),
                        ),
                        Text(
                          '★ ${rating.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (address.isNotEmpty) ...[
                    const SizedBox(height: 1),
                    Text(
                      address,
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 20, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }

  void _openBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PlaceDetailBottomSheet(doc: doc),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFE6F1FB),
      child: const Icon(
        Icons.image_outlined,
        size: 22,
        color: Color(0xFF185FA5),
      ),
    );
  }
}
