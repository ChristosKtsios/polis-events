import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';

/// Screen όπου ο χρήστης επιλέγει τύπο λογαριασμού.
/// - Προσωπικός: Browse, save, register
/// - Επαγγελματικός: Έχει επιχείρηση
class AccountTypeScreen extends StatelessWidget {
  const AccountTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Δημιουργία λογαριασμού',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Διάλεξε τον τύπο λογαριασμού που σε εξυπηρετεί',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),

              // Personal option
              _AccountTypeCard(
                title: 'Προσωπικός Λογαριασμός',
                description:
                    'Για να ανακαλύπτεις events, να σώζεις σημεία και να γράφεις κριτικές',
                features: const [
                  'Αποθήκευση αγαπημένων μερών',
                  'Συμμετοχή σε events',
                  'Κριτικές και βαθμολογίες',
                ],
                iconData: Icons.person_outline,
                onTap: () => context.go('/signup/personal'),
              ),

              const SizedBox(height: 16),

              // Business option
              _AccountTypeCard(
                title: 'Επαγγελματικός Λογαριασμός',
                description:
                    'Για επιχειρήσεις, μουσεία, οργανισμούς που θέλουν να εμφανίζονται στην εφαρμογή',
                features: const [
                  'Δημιουργία προφίλ επιχείρησης',
                  'Διαχείριση events και προωθήσεων',
                  'Επικοινωνία με πελάτες',
                ],
                iconData: Icons.business_outlined,
                onTap: () => context.go('/signup/business'),
                highlighted: true,
              ),

              const Spacer(),

              // Already have account
              Center(
                child: TextButton(
                  onPressed: () => context.go('/signin'),
                  child: const Text(
                    'Έχω ήδη λογαριασμό · Σύνδεση',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF185FA5),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> features;
  final IconData iconData;
  final VoidCallback onTap;
  final bool highlighted;

  const _AccountTypeCard({
    required this.title,
    required this.description,
    required this.features,
    required this.iconData,
    required this.onTap,
    this.highlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = highlighted ? const Color(0xFFE6F1FB) : const Color(0xFFF6F9FC);
    final borderColor =
        highlighted ? const Color(0xFF185FA5) : const Color(0xFFE5EFF8);
    final iconColor =
        highlighted ? const Color(0xFF0C447C) : const Color(0xFF185FA5);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: borderColor, width: highlighted ? 1.5 : 1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(iconData, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0C447C),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFF185FA5)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.check_circle_outline,
                          size: 14, color: Color(0xFF185FA5)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0C447C),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
