import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:polis_events/l10n/generated/app_localizations.dart';

import '../../../blocs/locale/locale_bloc.dart';
import '../../../core/theme/app_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = context.watch<LocaleBloc>().state.locale.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(l10n.language),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _LanguageTile(
                  label: l10n.greek,
                  code: 'el',
                  selected: currentLocale == 'el',
                ),
                const Divider(
                    height: 0.5,
                    color: AppColors.border,
                    indent: 14,
                    endIndent: 14),
                _LanguageTile(
                  label: l10n.english,
                  code: 'en',
                  selected: currentLocale == 'en',
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(l10n.notifications),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: true,
              onChanged: (v) {},
              title: Text(l10n.upcomingEvents,
                  style: const TextStyle(fontSize: 14)),
              activeThumbColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
      child: Text(text,
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary)),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final String code;
  final bool selected;

  const _LanguageTile({
    required this.label,
    required this.code,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(fontSize: 14)),
      trailing: selected
          ? const Icon(Icons.check_circle,
              color: AppColors.primary, size: 20)
          : null,
      onTap: () {
        context.read<LocaleBloc>().add(LocaleChanged(Locale(code)));
      },
    );
  }
}
