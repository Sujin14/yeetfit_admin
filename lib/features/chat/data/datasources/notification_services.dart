import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';

class NotificationService extends GetxService {
  StreamSubscription<QuerySnapshot>? _chatSubscription;

  @override
  void onClose() {
    _chatSubscription?.cancel();
    super.onClose();
  }

  Future<NotificationService> init() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return this;
    }

    _chatSubscription = FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .listen(
          (snapshot) {
            for (var chat in snapshot.docs) {
              FirebaseFirestore.instance
                  .collection('chats')
                  .doc(chat.id)
                  .collection('messages')
                  .where('participants', arrayContains: userId)
                  .where('status', isEqualTo: 'sent')
                  .get()
                  .then((messages) {
                    for (var msg in messages.docs) {
                      msg.reference.update({'status': 'delivered'});
                    }
                  })
                  .catchError((e) {
                    Get.snackbar(
                      'Error',
                      'Failed to update message status: $e',
                      backgroundColor: AdminTheme.colors['error'],
                      colorText: AdminTheme.colors['onError'],
                    );
                  });
            }
          },
          onError: (e) {
            Get.snackbar(
              'Error',
              'Failed to load chats: $e',
              backgroundColor: AdminTheme.colors['error'],
              colorText: AdminTheme.colors['onError'],
            );
          },
        );

    return this;
  }
}
