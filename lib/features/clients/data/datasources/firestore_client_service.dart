import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';

class FirestoreClientService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<ClientModel>> getClientsByGoal(String goal) {
  try {
    print('getClientsByGoalStream: Streaming clients for goal: $goal');
    return firestore
        .collection('users')
        .where('goal', isEqualTo: goal.toLowerCase())
        .where('role', isEqualTo: 'user')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['uid'] = doc.id;
            return ClientModel.fromMap(data);
          }).toList();
        });
  } catch (e) {
    print('getClientsByGoalStream: Error - $e');
    throw Exception('Failed to stream clients: $e');
  }
}


  Future<ClientModel?> getClientDetails(String uid) async {
    try {
      print('getClientDetails: Fetching details for UID: $uid');
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      final data = doc.data()!;
      data['uid'] = doc.id;
      return ClientModel.fromMap(data);
    } catch (e) {
      print('getClientDetails: Error - $e');
      throw Exception('Failed to fetch client details: $e');
    }
  }

  Future<List<ClientModel>> getAllClients() async {
    try {
      final query = await firestore
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();
      return query.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return ClientModel.fromMap(data);
      }).toList();
    } catch (e) {
      print('getAllClients: Error - $e');
      throw Exception('Failed to get clients: $e');
    }
  }

  Future<bool> updateClient(ClientModel client) async {
    try {
      await firestore.collection('users').doc(client.uid).update(client.toMap());
      return true;
    } catch (e) {
      print('updateClient: Error - $e');
      return false;
    }
  }
}
