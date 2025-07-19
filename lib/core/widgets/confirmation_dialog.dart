import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/theme.dart';

Future<bool> showConfirmationDialog(String item) async {
    return await Get.dialog<bool>(
          AlertDialog(
            title: Text('Confirm Delete'),
            content: Text('Are you sure you want to delete this $item?'),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text('Cancel', style: TextStyle(color: AdminTheme.colors['textSecondary'])),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text('Delete', style: TextStyle(color: AdminTheme.colors['error'])),
              ),
            ],
          ),
        ) ??
        false;
  }