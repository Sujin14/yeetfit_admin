import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../clients/data/models/client_model.dart';

class FirestoreClientService {
  final FirebaseFirestore _firestore;

  FirestoreClientService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<ClientModel?> getClientDetails(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return ClientModel.fromMap(doc.data()!);
    }
    return null;
  }
}