import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Result από τον city picker.
class CityPickerResult {
  final String cityId;
  final String cityName;
  final int radiusKm;

  const CityPickerResult({
    required this.cityId,
    required this.cityName,
    required this.radiusKm,
  });
}

/// City picker - ο χρήστης ψάχνει την πόλη του.
class CityPickerSheet extends StatefulWidget {
  final String currentCityId;
  final int currentRadiusKm;

  const CityPickerSheet({
    super.key,
    required this.currentCityId,
    required this.currentRadiusKm,
  });

  @override
  State<CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<CityPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';
  late double _radiusKm;
  String _selectedCityId = '';
  String _selectedCityName = '';

  // Πλήρης λίστα πόλεων (σε production θα έρχεται από Firestore).
  static const _allCities = <_City>[
    _City('ioannina', 'Ιωάννινα', 'Ήπειρος'),
    _City('arta', 'Άρτα', 'Ήπειρος'),
    _City('preveza', 'Πρέβεζα', 'Ήπειρος'),
    _City('igoumenitsa', 'Ηγουμενίτσα', 'Ήπειρος'),
    _City('athens', 'Αθήνα', 'Αττική'),
    _City('thessaloniki', 'Θεσσαλονίκη', 'Κεντρική Μακεδονία'),
    _City('patra', 'Πάτρα', 'Δυτική Ελλάδα'),
    _City('larisa', 'Λάρισα', 'Θεσσαλία'),
    _City('volos', 'Βόλος', 'Θεσσαλία'),
    _City('heraklion', 'Ηράκλειο', 'Κρήτη'),
    _City('chania', 'Χανιά', 'Κρήτη'),
    _City('rethymno', 'Ρέθυμνο', 'Κρήτη'),
    _City('rhodes', 'Ρόδος', 'Νότιο Αιγαίο'),
    _City('corfu', 'Κέρκυρα', 'Ιόνια Νησιά'),
    _City('zakynthos', 'Ζάκυνθος', 'Ιόνια Νησιά'),
    _City('mytilene', 'Μυτιλήνη', 'Βόρειο Αιγαίο'),
    _City('kalamata', 'Καλαμάτα', 'Πελοπόννησος'),
    _City('nafplio', 'Ναύπλιο', 'Πελοπόννησος'),
    _City('tripoli', 'Τρίπολη', 'Πελοπόννησος'),
    _City('chalcis', 'Χαλκίδα', 'Στερεά Ελλάδα'),
    _City('kavala', 'Καβάλα', 'Ανατολική Μακεδονία'),
    _City('alexandroupoli', 'Αλεξανδρούπολη', 'Ανατολική Μακεδονία'),
    _City('xanthi', 'Ξάνθη', 'Ανατολική Μακεδονία'),
    _City('komotini', 'Κομοτηνή', 'Ανατολική Μακεδονία'),
    _City('serres', 'Σέρρες', 'Κεντρική Μακεδονία'),
    _City('katerini', 'Κατερίνη', 'Κεντρική Μακεδονία'),
    _City('veria', 'Βέροια', 'Κεντρική Μακεδονία'),
    _City('kozani', 'Κοζάνη', 'Δυτική Μακεδονία'),
    _City('florina', 'Φλώρινα', 'Δυτική Μακεδονία'),
    _City('kastoria', 'Καστοριά', 'Δυτική Μακεδονία'),
    _City('grevena', 'Γρεβενά', 'Δυτική Μακεδονία'),
    _City('trikala', 'Τρίκαλα', 'Θεσσαλία'),
    _City('karditsa', 'Καρδίτσα', 'Θεσσαλία'),
    _City('lamia', 'Λαμία', 'Στερεά Ελλάδα'),
    _City('agrinio', 'Αγρίνιο', 'Δυτική Ελλάδα'),
    _City('messolonghi', 'Μεσολόγγι', 'Δυτική Ελλάδα'),
    _City('pyrgos', 'Πύργος', 'Δυτική Ελλάδα'),
  ];

  @override
  void initState() {
    super.initState();
    _radiusKm = widget.currentRadiusKm.toDouble();
    final current = _allCities.firstWhere((c) => c.id == widget.currentCityId,
        orElse: () => _allCities.first);
    _selectedCityId = current.id;
    _selectedCityName = current.name;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_City> get _filtered {
    if (_query.isEmpty) return [];
    final lower = _query.toLowerCase();
    return _allCities
        .where((c) =>
            c.name.toLowerCase().contains(lower) ||
            c.region.toLowerCase().contains(lower))
        .take(8)
        .toList();
  }

  String _radiusLabel(double v) {
    final r = v.round();
    if (r <= 5) return 'Πολύ κοντά';
    if (r <= 15) return 'Κοντά';
    if (r <= 30) return 'Σε λογική απόσταση';
    return 'Πιο μακριά';
  }

  void _apply() {
    Navigator.of(context).pop(
      CityPickerResult(
        cityId: _selectedCityId,
        cityName: _selectedCityName,
        radiusKm: _radiusKm.round(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: Text(
              'Πού είσαι;',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Επιλεγμένη πόλη
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                border: Border(
                  left: BorderSide(color: AppColors.primary, width: 3),
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.location_on,
                      size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    _selectedCityName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Search input
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Άλλαξε πόλη...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: AppColors.textTertiary,
                  ),
                  prefixIcon: Icon(Icons.search,
                      size: 18, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                style: const TextStyle(fontSize: 14),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
          ),

          // Search results
          if (_filtered.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border, width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView(
                shrinkWrap: true,
                children: _filtered.map((city) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCityId = city.id;
                        _selectedCityName = city.name;
                        _searchController.clear();
                        _query = '';
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  city.name,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  city.region,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward,
                              size: 14, color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // Divider
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Divider(height: 1, color: AppColors.border),
          ),

          // Radius slider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Πόσο μακριά;',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _radiusLabel(_radiusKm),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Text('Κοντά',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textTertiary)),
                    Expanded(
                      child: Slider(
                        value: _radiusKm,
                        min: 1,
                        max: 50,
                        divisions: 49,
                        activeColor: AppColors.primary,
                        inactiveColor: AppColors.surfaceVariant,
                        onChanged: (v) => setState(() => _radiusKm = v),
                      ),
                    ),
                    const Text('Μακρυά',
                        style: TextStyle(
                            fontSize: 11, color: AppColors.textTertiary)),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Δείξε σε ακτίνα ${_radiusKm.round()} km',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Apply button
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _apply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Εφαρμογή',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _City {
  final String id;
  final String name;
  final String region;

  const _City(this.id, this.name, this.region);
}
