import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Discover grid - 6 περιληπτικά γαλάζια κουμπιά κατηγοριών.
/// Tap → ανοίγει subcategory screen.
///
/// V4: Με header text "Ανακάλυψε τι συμβαίνει σήμερα στην πόλη σου".
class CategoryExploreGrid extends StatelessWidget {
  const CategoryExploreGrid({super.key});

  static const _categories = <_Category>[
    _Category(id: 'culture', label: 'Πολιτισμός'),
    _Category(id: 'shows', label: 'Παραστάσεις\n& Σινεμά'),
    _Category(id: 'exhibitions', label: 'Εκθέσεις\n& Φεστιβάλ'),
    _Category(id: 'tours', label: 'Ξεναγήσεις\n& Φύση'),
    _Category(id: 'sports', label: 'Αθλητικά'),
    _Category(id: 'leisure', label: 'Έξοδος\n& Hobbies'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header text
        const Padding(
          padding: EdgeInsets.fromLTRB(4, 4, 4, 16),
          child: Text(
            'Ανακάλυψε τι συμβαίνει σήμερα στην πόλη σου',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ),

        // Grid με 6 κατηγορίες
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children:
              _categories.map((c) => _CategoryButton(category: c)).toList(),
        ),
      ],
    );
  }
}

class _Category {
  final String id;
  final String label;
  const _Category({required this.id, required this.label});
}

class _CategoryButton extends StatelessWidget {
  final _Category category;
  const _CategoryButton({required this.category});

  static const _bg = Color(0xFFE6F1FB);
  static const _border = Color(0xFFB5D4F4);
  static const _text = Color(0xFF0C447C);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.go('/category/${category.id}'),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: _bg,
            border: Border.all(color: _border, width: 1),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(14),
          child: Text(
            category.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _text,
              height: 1.25,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
