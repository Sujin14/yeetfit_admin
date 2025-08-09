// lib/features/settings/views/about_view.dart
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../core/theme/theme.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutScreen> {
  String version = '';

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((p) => setState(() => version = p.version));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About App', style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['onPrimary'])), backgroundColor: AdminTheme.colors['primary']),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('YeetFit Admin', style: AdminTheme.textStyles['heading']),
              const SizedBox(height: 8),
              Text('Version: $version', style: AdminTheme.textStyles['body']),
              const SizedBox(height: 12),
              Text('Developer: Sujin K Suresh', style: AdminTheme.textStyles['body']),
              const SizedBox(height: 12),
              Text('YeetFit Admin helps manage and monitor user fitness data, offering control over content, analytics, and app configuration in real time.', style: AdminTheme.textStyles['body']),
            ]),
          ),
        ),
      ),
    );
  }
}
