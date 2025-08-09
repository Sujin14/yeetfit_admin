// lib/features/settings/widgets/section_title.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
      child: Text(
        title,
        style: AdminTheme.textStyles['title']!.copyWith(fontSize: 16),
      ),
    );
  }
}
