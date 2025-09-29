import 'package:flutter/material.dart';
import '../../../../core/theme/theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool destructive;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.iconColor,
    this.destructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          radius: 22,
          backgroundColor: AdminTheme.colors['surface'],
          child: Icon(icon, color: iconColor ?? AdminTheme.colors['primary']),
        ),
        title: Text(title, style: AdminTheme.textStyles['body']),
        subtitle: subtitle == null ? null : Text(subtitle!, style: AdminTheme.textStyles['caption']),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AdminTheme.colors['textSecondary']),
        onTap: onTap,
      ),
    );
  }
}
