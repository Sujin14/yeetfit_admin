import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: AdminTheme.textStyles['title']!.copyWith(
            color: AdminTheme.colors['onPrimary'],
          ),
        ),
        backgroundColor: AdminTheme.colors['primary'],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Privacy Policy',
                    style: AdminTheme.textStyles['heading'],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. Data Controller',
                    style: AdminTheme.textStyles['title'],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'YeetFit (the Company) collects and processes personal data of admins and users for app functionality and support.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2. Data Collected',
                    style: AdminTheme.textStyles['title'],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'We collect: name, email, profile photo, usage data, device identifiers and any health-related info users voluntarily supply. Profile photos are stored in Firebase Storage; other metadata is stored in Firestore.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3. Purpose & Legal Basis',
                    style: AdminTheme.textStyles['title'],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Data is used to provide the service, communicate with users, and improve the product. Processing is necessary for contract performance and legitimate interests.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '4. Data Sharing',
                    style: AdminTheme.textStyles['title'],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'We do not sell personal data. We may share data with service providers (Firebase) and third-parties only under strict contractual obligations.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '5. Data Retention',
                    style: AdminTheme.textStyles['title'],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'We retain data as long as needed for the service or as required by law. Admins can request deletion via support.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text('6. Your Rights', style: AdminTheme.textStyles['title']),
                  const SizedBox(height: 6),
                  Text(
                    'Access, correction, deletion, and portability requests can be made via contact support (privacy@yeetfit.app).',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text('7. Security', style: AdminTheme.textStyles['title']),
                  const SizedBox(height: 6),
                  Text(
                    'We use Firebase security rules and industry-standard protections for data in transit.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text('8. Contact', style: AdminTheme.textStyles['title']),
                  const SizedBox(height: 6),
                  Text(
                    'For privacy requests email: privacy@yeetfit.app',
                    style: AdminTheme.textStyles['body'],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
