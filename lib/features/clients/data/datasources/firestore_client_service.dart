import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/client_model.dart';
import '../models/plan_model.dart';
import '../models/progress_model.dart';

class FirestoreClientService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<ClientModel>> getClientsByGoal(String goal) async {
    try {
      print('getClientsByGoal: Fetching clients for goal: $goal');
      final query = await firestore
          .collection('users')
          .where('goal', isEqualTo: goal.toLowerCase())
          .where('role', isEqualTo: 'user')
          .get();
      final clients = query.docs.map((doc) {
        final data = doc.data();
        data['uid'] = doc.id;
        print(
          'getClientsByGoal: Found client - UID: ${doc.id}, Name: ${data['name']}',
        );
        return ClientModel.fromMap(data);
      }).toList();
      print('getClientsByGoal: Fetched ${clients.length} clients');
      return clients;
    } catch (e) {
      print('getClientsByGoal: Error fetching clients for goal "$goal": $e');
      return [];
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

  Future<List<ProgressModel>> getClientProgress(String uid) async {
    try {
      print('getClientProgress: Fetching progress for UID: $uid');
      final query = await firestore
          .collection('users')
          .doc(uid)
          .collection('progress')
          .orderBy('date', descending: true)
          .get();
      final progress = query.docs.map((doc) {
        final data = doc.data();
        print('getClientProgress: Progress entry - Date: ${data['date']}');
        return ProgressModel.fromMap(data);
      }).toList();
      print('getClientProgress: Fetched ${progress.length} progress entries');
      return progress;
    } catch (e) {
      print('getClientProgress: Error fetching progress for UID: $uid - $e');
      return [];
    }
  }

  Future<List<PlanModel>> getClientPlans(String userId) async {
    try {
      print('getClientPlans: Fetching plans for userId: $userId');
      final workouts = await firestore
          .collection('workouts')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      final diets = await firestore
          .collection('diets')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      final plans = [
        ...workouts.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['title'] = data['title'] ?? 'Workout Plan ${doc.id}';
          print('getClientPlans: Workout plan - $data');
          return PlanModel.fromMap(data);
        }),
        ...diets.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          data['title'] = data['title'] ?? 'Diet Plan ${doc.id}';
          print('getClientPlans: Diet plan - $data');
          return PlanModel.fromMap(data);
        }),
      ];
      print('getClientPlans: Fetched ${plans.length} plans');
      return plans;
    } catch (e) {
      print('getClientPlans: Error fetching plans for userId: $userId - $e');
      return [];
    }
  }

  Future<bool> assignPlan(String userId, PlanModel plan) async {
    try {
      print(
        'assignPlan: Assigning plan for userId: $userId, type: ${plan.type}',
      );
      final collection = plan.type == 'diet' ? 'diets' : 'workouts';
      final docRef = await firestore.collection(collection).add(plan.toMap());
      await docRef.update({'id': docRef.id});
      print(
        'assignPlan: Plan assigned successfully for userId: $userId, ID: ${docRef.id}',
      );
      return true;
    } catch (e) {
      print('assignPlan: Error assigning plan for userId: $userId - $e');
      return false;
    }
  }
}
