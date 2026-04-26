import 'package:shared_preferences/shared_preferences.dart';

/// Service για τοπικές ρυθμίσεις (locale, θέμα κλπ).
class PreferencesService {
  static const _kLanguageCode = 'language_code';
  static const _kSelectedCityId = 'selected_city_id';

  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static Future<PreferencesService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PreferencesService(prefs);
  }

  String? get languageCode => _prefs.getString(_kLanguageCode);
  Future<void> setLanguageCode(String code) =>
      _prefs.setString(_kLanguageCode, code);

  String? get selectedCityId => _prefs.getString(_kSelectedCityId);
  Future<void> setSelectedCityId(String id) =>
      _prefs.setString(_kSelectedCityId, id);
}
