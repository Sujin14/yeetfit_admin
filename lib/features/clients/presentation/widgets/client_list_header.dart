import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/theme.dart';
import 'client_search_field.dart';

class ClientsListHeader extends StatelessWidget {
  final String goal;
  final bool showSearch;

  const ClientsListHeader({
    super.key,
    required this.goal,
    required this.showSearch,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat(
      'EEEE, dd MMMM yyyy',
    ).format(DateTime.now());

    return Container(
      width: double.infinity,
      height: showSearch ? 180.h : 140.h,
      color: AdminTheme.colors['background'],
      child: Stack(
        children: [
          Positioned(
            top: 1.h,
            right: 30.w,
            child: Image.asset(
              'assets/images/yeet_icon.png',
              width: 100.w,
              height: 100.h,
            ),
          ),

          Padding(
            padding: EdgeInsets.only(
              top: 24.h,
              left: 16.w,
              right: 16.w,
              bottom: showSearch ? 0 : 24.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30.h,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Welcome, Admin!',
                        textStyle: AdminTheme.textStyles['title']!.copyWith(
                          fontSize: 20.sp,
                        ),
                        speed: const Duration(milliseconds: 300),
                        cursor: '',
                      ),
                    ],
                    isRepeatingAnimation: false,
                    totalRepeatCount: 1,
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ),

                SizedBox(height: 4.h),

                AnimatedTextKit(
                  repeatForever: true,
                  pause: const Duration(milliseconds: 100),
                  animatedTexts: [
                    TypewriterAnimatedText(
                      formattedDate,
                      textStyle: AdminTheme.textStyles['body']!.copyWith(
                        color: AdminTheme.colors['primary'],
                      ),
                      speed: const Duration(milliseconds: 300),
                      cursor: '_',
                    ),
                  ],
                ),

                if (showSearch) ...[
                  SizedBox(height: 16.h),
                  ClientsSearchBar(goal: goal),
                  SizedBox(height: 8.h),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
