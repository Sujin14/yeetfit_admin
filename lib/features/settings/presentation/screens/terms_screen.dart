import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Terms of Service',
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
                    'Terms of Service',
                    style: AdminTheme.textStyles['heading'],
                  ),
                  const SizedBox(height: 12),
                  Text('1. Acceptance', style: AdminTheme.textStyles['title']),
                  const SizedBox(height: 6),
                  Text(
                    'By using YeetFit Admin you accept these terms. Admin features must be used per local laws and policies.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '2. Admin responsibilities',
                    style: AdminTheme.textStyles['title'],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Admins are responsible for user data management, respecting privacy and not misusing admin privileges.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '3. Limitation of liability',
                    style: AdminTheme.textStyles['title'],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'The company is not liable for indirect damages resulting from admin actions. Use the app responsibly.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '4. Modifications',
                    style: AdminTheme.textStyles['title'],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'We may update terms; important updates will be communicated to admins.',
                    style: AdminTheme.textStyles['body'],
                  ),
                  const SizedBox(height: 8),
                  Text('5. Contact', style: AdminTheme.textStyles['title']),
                  const SizedBox(height: 6),
                  Text(
                    'Questions about these terms: terms@yeetfit.app',
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
