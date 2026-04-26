import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/date_utils.dart' as du;
import '../../../services/firestore_service.dart';
import '../widgets/category_explore_grid.dart';
import '../widgets/today_tab.dart';
import '../widgets/city_picker_sheet.dart';
import '../widgets/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _fs = FirestoreService();

  // Επιλεγμένη πόλη + απόσταση (default: Ιωάννινα, 15km).
  String _selectedCityId = 'ioannina';
  String _selectedCityName = 'Ιωάννινα';
  int _selectedRadiusKm = 15;

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

  Future<void> _openCityPicker() async {
    final result = await showModalBottomSheet<CityPickerResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CityPickerSheet(
        currentCityId: _selectedCityId,
        currentRadiusKm: _selectedRadiusKm,
      ),
    );

    if (result != null) {
      setState(() {
        _selectedCityId = result.cityId;
        _selectedCityName = result.cityName;
        _selectedRadiusKm = result.radiusKm;
      });
    }
  }

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SearchScreen(cityId: _selectedCityId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SafeArea(
      child: Column(
        children: [
          _Header(
            cityName: _selectedCityName,
            radiusKm: _selectedRadiusKm,
            onLocationTap: _openCityPicker,
            onSearchTap: _openSearch,
          ),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                  bottom: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: TabBar(
              controller: _tab,
              indicatorColor: AppColors.primary,
              indicatorWeight: 2,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              tabs: [
                Tab(text: l10n.tabToday),
                Tab(text: l10n.tabDiscover),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tab,
              children: [
                TodayTab(cityId: _selectedCityId, fs: _fs),
                const _DiscoverTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String cityName;
  final int radiusKm;
  final VoidCallback onLocationTap;
  final VoidCallback onSearchTap;

  const _Header({
    required this.cityName,
    required this.radiusKm,
    required this.onLocationTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final authState = context.watch<AuthBloc>().state;
    final user = authState.user;
    final hasName = user?.displayName.isNotEmpty == true;

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: onLocationTap,
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on,
                                size: 14, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              '$cityName · ${radiusKm}km',
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary),
                            ),
                            const SizedBox(width: 2),
                            const Icon(Icons.keyboard_arrow_down,
                                size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      hasName
                          ? '${du.DateUtils.greetingForTime(DateTime.now(), context)}, ${user!.displayName.split(' ').first}'
                          : l10n.whatToDiscover,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/profile'),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryBg,
                  child: hasName
                      ? Text(
                          user!.displayName[0].toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : const Icon(
                          Icons.person_outline,
                          size: 22,
                          color: AppColors.primaryDark,
                        ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search,
                      size: 18, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(l10n.searchPlaceholder,
                      style: const TextStyle(
                          fontSize: 14, color: AppColors.textTertiary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscoverTab extends StatelessWidget {
  const _DiscoverTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      children: const [
        SizedBox(height: 8),
        CategoryExploreGrid(),
        SizedBox(height: 20),
      ],
    );
  }
}
