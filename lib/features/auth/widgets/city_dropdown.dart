import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Dropdown picker για τις 35+ ελληνικές πόλεις.
/// Used in signup forms.
class CityDropdown extends StatelessWidget {
  final String? selectedCityId;
  final ValueChanged<String?> onChanged;
  final String? label;

  const CityDropdown({
    super.key,
    required this.selectedCityId,
    required this.onChanged,
    this.label,
  });

  // Λίστα πόλεων - id + ελληνικό όνομα
  static const cities = <Map<String, String>>[
    {'id': 'athens', 'name': 'Αθήνα'},
    {'id': 'thessaloniki', 'name': 'Θεσσαλονίκη'},
    {'id': 'patras', 'name': 'Πάτρα'},
    {'id': 'heraklion', 'name': 'Ηράκλειο'},
    {'id': 'larisa', 'name': 'Λάρισα'},
    {'id': 'volos', 'name': 'Βόλος'},
    {'id': 'ioannina', 'name': 'Ιωάννινα'},
    {'id': 'trikala', 'name': 'Τρίκαλα'},
    {'id': 'serres', 'name': 'Σέρρες'},
    {'id': 'chania', 'name': 'Χανιά'},
    {'id': 'lamia', 'name': 'Λαμία'},
    {'id': 'rhodes', 'name': 'Ρόδος'},
    {'id': 'alexandroupoli', 'name': 'Αλεξανδρούπολη'},
    {'id': 'kavala', 'name': 'Καβάλα'},
    {'id': 'katerini', 'name': 'Κατερίνη'},
    {'id': 'kalamata', 'name': 'Καλαμάτα'},
    {'id': 'agrinio', 'name': 'Αγρίνιο'},
    {'id': 'corfu', 'name': 'Κέρκυρα'},
    {'id': 'kozani', 'name': 'Κοζάνη'},
    {'id': 'arta', 'name': 'Άρτα'},
    {'id': 'preveza', 'name': 'Πρέβεζα'},
    {'id': 'igoumenitsa', 'name': 'Ηγουμενίτσα'},
    {'id': 'metsovo', 'name': 'Μέτσοβο'},
    {'id': 'kastoria', 'name': 'Καστοριά'},
    {'id': 'florina', 'name': 'Φλώρινα'},
    {'id': 'grevena', 'name': 'Γρεβενά'},
    {'id': 'edessa', 'name': 'Έδεσσα'},
    {'id': 'veroia', 'name': 'Βέροια'},
    {'id': 'naoussa', 'name': 'Νάουσα'},
    {'id': 'drama', 'name': 'Δράμα'},
    {'id': 'xanthi', 'name': 'Ξάνθη'},
    {'id': 'komotini', 'name': 'Κομοτηνή'},
    {'id': 'mytilini', 'name': 'Μυτιλήνη'},
    {'id': 'chios', 'name': 'Χίος'},
    {'id': 'syros', 'name': 'Σύρος'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 6, left: 4),
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF6F9FC),
            border: Border.all(color: const Color(0xFFE5EFF8), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCityId,
              isExpanded: true,
              hint: const Text(
                'Επίλεξε πόλη',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textTertiary,
                ),
              ),
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.textTertiary),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
              items: cities.map((city) {
                return DropdownMenuItem<String>(
                  value: city['id']!,
                  child: Text(city['name']!),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
