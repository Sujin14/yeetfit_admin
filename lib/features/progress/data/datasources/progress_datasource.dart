import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProgressService {
  final FirebaseFirestore firestore;

  FirestoreProgressService(this.firestore);

  Future<Map<String, dynamic>?> getDailyProgress({
    required String uid,
    required String category,
    required String subcategory,
    required String date,
  }) async {
    final docRef = firestore
        .collection('users')
        .doc(uid)
        .collection('progress')
        .doc(category)
        .collection(subcategory)
        .doc(date);

    final doc = await docRef.get();
    return doc.exists ? doc.data() : null;
  }
}
