import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';

class ClientProgressSection extends StatelessWidget {
  const ClientProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Daily Progress', style: AdminTheme.textStyles['title']),
        SizedBox(height: 8.h),
        Text('Progress data will be displayed here (To be implemented)', style: AdminTheme.textStyles['body']),
      ],
    );
  }
}
