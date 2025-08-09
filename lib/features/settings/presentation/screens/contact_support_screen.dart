import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/contact_support_controller.dart';

class ContactSupportScreen extends StatelessWidget {
  const ContactSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ContactSupportController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Support',
          style: AdminTheme.textStyles['title']!.copyWith(
            color: AdminTheme.colors['onPrimary'],
          ),
        ),
        backgroundColor: AdminTheme.colors['primary'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (v) => c.name.value = v,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AdminTheme.colors['inputBackground'],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (v) => c.email.value = v,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AdminTheme.colors['inputBackground'],
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                onChanged: (v) => c.message.value = v,
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: AdminTheme.colors['inputBackground'],
                ),
                maxLines: null,
                expands: true,
              ),
            ),
            const SizedBox(height: 12),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AdminTheme.colors['primary'],
                ),
                onPressed: c.isLoading.value ? null : c.send,
                child: c.isLoading.value
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Send'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
