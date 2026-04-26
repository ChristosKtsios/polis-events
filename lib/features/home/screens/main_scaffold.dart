import 'package:flutter/material.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';

import '../../../core/theme/app_colors.dart';
import '../../calendar/screens/calendar_screen.dart';
import '../../map/screens/map_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'home_screen.dart';
import 'saved_screen.dart';

/// Το κύριο scaffold με το bottom navigation.
/// Περιέχει 5 tabs: Αρχική / Χάρτης / Ημερολόγιο / Αποθηκευμένα / Προφίλ
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final _screens = const [
    HomeScreen(),
    MapScreen(),
    CalendarScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(
            top: BorderSide(color: AppColors.border, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home_outlined, size: 22),
              activeIcon: const Icon(Icons.home, size: 22),
              label: l10n.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.map_outlined, size: 22),
              activeIcon: const Icon(Icons.map, size: 22),
              label: l10n.map,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.calendar_today_outlined, size: 20),
              activeIcon: const Icon(Icons.calendar_today, size: 20),
              label: l10n.calendar,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.bookmark_border, size: 22),
              activeIcon: const Icon(Icons.bookmark, size: 22),
              label: l10n.saved,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person_outline, size: 22),
              activeIcon: const Icon(Icons.person, size: 22),
              label: l10n.profile,
            ),
          ],
        ),
      ),
    );
  }
}
