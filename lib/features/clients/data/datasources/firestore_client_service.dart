import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import '../models/client_model.dart';

class FirestoreClientService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<ClientModel>> getClientsByGoal(String goal) {
    try {
      // Use lowercase goal to match upcoming Firestore data
      String formattedGoal = goal.toLowerCase();
      debugPrint('Querying Firestore for goal: $formattedGoal');

      return firestore
          .collection('users')
          .where('goal', isEqualTo: formattedGoal)
          .where('role', isEqualTo: 'user')
          .snapshots()
          .map((snapshot) {
            final clients = snapshot.docs.map((doc) {
              final data = doc.data();
              data['uid'] = doc.id;
              return ClientModel.fromMap(data);
            }).toList();
            debugPrint('Fetched ${clients.length} clients for goal: $formattedGoal');
            return clients;
          });
    } catch (e) {
      debugPrint('Error in getClientsByGoal: $e');
      throw Exception('Failed to stream clients: $e');
    }
  }

  Future<ClientModel?> getClientDetails(String uid) async {
    try {
      debugPrint('Fetching client details for UID: $uid');
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        debugPrint('No client found for UID: $uid');
        return null;
      }
      final data = doc.data()!;
      data['uid'] = doc.id;
      final client = ClientModel.fromMap(data);
      debugPrint('Fetched client: ${client.name}');
      return client;
    } catch (e) {
      debugPrint('Error in getClientDetails: $e');
      throw Exception('Failed to fetch client details: $e');
    }
  }

  Future<List<ClientModel>> getAllClients() async {
    try {
      debugPrint('Fetching all clients');
      final query = await firestore
          .collection('users')
          .where('role', isEqualTo: 'user')
          .get();
      final clients = query.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        return ClientModel.fromMap(data);
      }).toList();
      debugPrint('Fetched ${clients.length} clients');
      return clients;
    } catch (e) {
      debugPrint('Error in getAllClients: $e');
      throw Exception('Failed to get clients: $e');
    }
  }

  Future<bool> updateClient(ClientModel client) async {
    try {
      debugPrint('Updating client: ${client.uid}');
      await firestore.collection('users').doc(client.uid).update(client.toMap());
      debugPrint('Client updated successfully: ${client.uid}');
      return true;
    } catch (e) {
      debugPrint('Error in updateClient: $e');
      return false;
    }
  }
}