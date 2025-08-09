import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  final List<Map<String, String>> faqs = const [
    {
      'q': 'How do I reset a user password?',
      'a': 'Users can reset their own password via the app. Admins cannot see user passwords.'
    },
    {
      'q': 'Where is user data stored?',
      'a': 'User data and progress are stored in Cloud Firestore; profile pictures are also stored in Firestore.'
    },
    {
      'q': 'How do I update my profile picture?',
      'a': 'Go to Edit Profile in settings and choose Camera or Gallery to upload a new picture.'
    },
    {
      'q': 'How to contact support?',
      'a': 'Use the Contact Support screen to send us a message. We will respond by email.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Help & FAQs', style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['onPrimary'])), backgroundColor: AdminTheme.colors['primary']),
      body: ListView(padding: const EdgeInsets.symmetric(vertical: 8), children: [
        ...faqs.map((f) => Card(margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), child: ExpansionTile(title: Text(f['q']!, style: AdminTheme.textStyles['body']), children: [Padding(padding: const EdgeInsets.all(16.0), child: Text(f['a']!, style: AdminTheme.textStyles['caption']))],))),
        const SizedBox(height: 16),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 16.0), child: ElevatedButton.icon(onPressed: () => Get.toNamed('/contact-support'), icon: const Icon(Icons.contact_support), label: const Text('Contact Support'), style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48), backgroundColor: AdminTheme.colors['gradientStart']))),
        const SizedBox(height: 24),
      ]),
    );
  }
}
