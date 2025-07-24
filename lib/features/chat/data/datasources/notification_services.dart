import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  Future<NotificationService> init() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: userId)
        .snapshots()
        .listen((snapshot) {
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
        });
      }
    });
  
    return this;
  }
}
