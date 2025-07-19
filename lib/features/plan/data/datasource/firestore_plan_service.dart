import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/plan_model.dart';

class FirestorePlanService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<PlanModel>> getClientPlans(String userId) async {
    try {
      final workouts = await firestore
          .collection('users')
          .doc(userId)
          .collection('workouts')
          .orderBy('createdAt', descending: true)
          .get();
      final diets = await firestore
          .collection('users')
          .doc(userId)
          .collection('diets')
          .orderBy('createdAt', descending: true)
          .get();
      final plans = [
        ...workouts.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['type'] = 'workout';
          return PlanModel.fromMap(data);
        }),
        ...diets.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['type'] = 'diet';
          return PlanModel.fromMap(data);
        }),
      ];
      return plans;
    } catch (e) {
      print('getClientPlans: Error - $e');
      throw Exception('Failed to fetch plans: $e');
    }
  }

  Future<bool> assignPlan(String userId, PlanModel plan) async {
    try {
      final collection = plan.type == 'diet' ? 'diets' : 'workouts';
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .doc(plan.id);
      await docRef.set(plan.toMap());
      return true;
    } catch (e) {
      print('assignPlan: Error - $e');
      throw Exception('Failed to assign plan: $e');
    }
  }

  Future<bool> deletePlan(String userId, String planId, String type) async {
    try {
      final collection = type == 'diet' ? 'diets' : 'workouts';
      await firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .doc(planId)
          .delete();
      return true;
    } catch (e) {
      print('deletePlan: Error - $e');
      throw Exception('Failed to delete plan: $e');
    }
  }
}
