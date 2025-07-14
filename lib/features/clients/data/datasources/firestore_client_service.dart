import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';
import '../models/plan_model.dart';

class FirestoreClientService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  Stream<QuerySnapshot> getClientsByGoal(String goal) {
    try {
      print('getClientsByGoalStream: Streaming clients for goal: $goal');
      return firestore
          .collection('users')
          .where('goal', isEqualTo: goal.toLowerCase())
          .where('role', isEqualTo: 'user')
          .snapshots();
    } catch (e) {
      print(
        'getClientsByGoalStream: Error streaming clients for goal "$goal": $e',
      );
      throw Exception('Failed to stream clients: $e');
    }
  }

  Future<ClientModel?> getClientDetails(String uid) async {
    try {
      print('getClientDetails: Fetching details for UID: $uid');
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        print('getClientDetails: No document found for UID: $uid');
        return null;
      }
      final data = doc.data()!;
      data['uid'] = doc.id;
      print('getClientDetails: Document data - $data');
      return ClientModel.fromMap(data);
    } catch (e) {
      print(
        'getClientDetails: Error fetching client details for UID: $uid - $e',
      );
      throw Exception('Failed to fetch client details: $e');
    }
  }

  Future<List<PlanModel>> getClientPlans(String userId) async {
    try {
      print('getClientPlans: Fetching plans for userId: $userId');
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
          print('getClientPlans: Workout plan - $data');
          return PlanModel.fromMap(data);
        }),
        ...diets.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['type'] = 'diet';
          print('getClientPlans: Diet plan - $data');
          return PlanModel.fromMap(data);
        }),
      ];
      print('getClientPlans: Fetched ${plans.length} plans');
      return plans;
    } catch (e) {
      print('getClientPlans: Error fetching plans for userId: $userId - $e');
      throw Exception('Failed to fetch plans: $e');
    }
  }

  Future<bool> assignPlan(String userId, PlanModel plan) async {
    try {
      print(
        'assignPlan: Assigning plan for userId: $userId, type: ${plan.type}',
      );
      final collection = plan.type == 'diet' ? 'diets' : 'workouts';
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .doc(plan.id);
      await docRef.set(plan.toMap());
      print(
        'assignPlan: Plan ${plan.id == null ? "created" : "updated"} successfully for userId: $userId, ID: ${plan.id ?? docRef.id}',
      );
      return true;
    } catch (e) {
      print('assignPlan: Error assigning plan for userId: $userId - $e');
      throw Exception('Failed to assign plan: $e');
    }
  }

  Future<bool> deletePlan(String userId, String planId, String type) async {
    try {
      print(
        'deletePlan: Deleting plan for userId: $userId, planId: $planId, type: $type',
      );
      final collection = type == 'diet' ? 'diets' : 'workouts';
      await firestore
          .collection('users')
          .doc(userId)
          .collection(collection)
          .doc(planId)
          .delete();
      print('deletePlan: Plan deleted successfully');
      return true;
    } catch (e) {
      print('deletePlan: Error deleting plan: $e');
      throw Exception('Failed to delete plan: $e');
    }
  }
}
