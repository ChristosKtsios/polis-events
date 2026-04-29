import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/auth/auth_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AuthBloc>().state;
    final user = state.user;
    final isAnonymous = AuthService().isAnonymous;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: _buildBody(context, l10n, user, isAnonymous),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    AppUser? user,
    bool isAnonymous,
  ) {
    // Loading state - μόνο όταν περιμένουμε auth init
    if (user == null && !isAnonymous) {
      return const Center(child: CircularProgressIndicator());
    }

    // Logged-out state - anonymous user ή χωρίς real account
    if (user == null || user.displayName.isEmpty || isAnonymous) {
      return _buildLoggedOutView(context);
    }

    // Logged-in state - πραγματικός χρήστης
    return _buildLoggedInView(context, l10n, user);
  }

  /// Logged-out: "Σύνδεση / Εγγραφή" buttons
  Widget _buildLoggedOutView(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),

            // Hero icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6F1FB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 40,
                  color: Color(0xFF185FA5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            const Text(
              'Δεν έχεις λογαριασμό',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle
            const Text(
              'Δημιούργησε λογαριασμό για να σώζεις\nτα αγαπημένα σου, να γράφεις κριτικές\nκαι να συμμετέχεις σε events',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Sign up button (primary)
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.go('/signup/account-type'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF185FA5),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Δημιουργία λογαριασμού',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Sign in button (outlined)
            SizedBox(
              height: 50,
              child: OutlinedButton(
                onPressed: () => context.go('/signin'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF185FA5), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Σύνδεση',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF185FA5),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Settings / About κάτω
            _tile(context,
                icon: Icons.settings_outlined,
                label: AppLocalizations.of(context).settings,
                onTap: () => context.go('/settings')),
            const SizedBox(height: 6),
            _tile(context,
                icon: Icons.info_outline,
                label: AppLocalizations.of(context).about,
                onTap: () {}),
          ],
        ),
      ),
    );
  }

  /// Logged-in: original profile view
  Widget _buildLoggedInView(
    BuildContext context,
    AppLocalizations l10n,
    AppUser user,
  ) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // User info card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border.all(color: AppColors.border, width: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryBg,
                child: Text(
                  user.displayName.isNotEmpty
                      ? user.displayName[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 24,
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.displayName,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(user.email,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                    if (user.isPendingBusiness) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF4E5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Σε αναμονή έγκρισης',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFB37300),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Admin panel για admins
        if (user.role == UserRole.orgAdmin ||
            user.role == UserRole.superAdmin) ...[
          _tile(context,
              icon: Icons.dashboard_outlined,
              label: l10n.adminPanel,
              onTap: () => context.go('/admin')),
          const SizedBox(height: 6),
        ],

        // Settings, About
        _tile(context,
            icon: Icons.settings_outlined,
            label: l10n.settings,
            onTap: () => context.go('/settings')),
        const SizedBox(height: 6),
        _tile(context,
            icon: Icons.info_outline, label: l10n.about, onTap: () {}),
        const SizedBox(height: 20),

        // Sign out
        OutlinedButton(
          onPressed: () =>
              context.read<AuthBloc>().add(const AuthSignOutRequested()),
          child: Text(l10n.signOut),
        ),
      ],
    );
  }

  Widget _tile(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ListTile(
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border, width: 0.5),
      ),
      leading: Icon(icon, color: AppColors.primary, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}
