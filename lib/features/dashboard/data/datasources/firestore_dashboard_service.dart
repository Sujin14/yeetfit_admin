import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, int>> getClientCounts() async {
    try {
      final weightLoss = await _firestore
          .collection('users')
          .where('goal', isEqualTo: 'weight loss')
          .where('role', isEqualTo: 'user')
          .get();
      final weightGain = await _firestore
          .collection('users')
          .where('goal', isEqualTo: 'weight gain')
          .where('role', isEqualTo: 'user')
          .get();
      final muscleBuilding = await _firestore
          .collection('users')
          .where('goal', isEqualTo: 'muscle building')
          .where('role', isEqualTo: 'user')
          .get();
      return {
        'Weight Loss': weightLoss.docs.length,
        'Weight Gain': weightGain.docs.length,
        'Muscle Building': muscleBuilding.docs.length,
      };
    } catch (e) {
      print('Error fetching client counts: $e');
      return {};
    }
  }
}
