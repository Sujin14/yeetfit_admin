import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/plan_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/assign_plan.dart';

class PlanController extends GetxController {
  final AssignPlan assignPlan;
  final FirestoreClientService _service;
  final isLoading = false.obs;
  final error = ''.obs;

  PlanController()
    : assignPlan = AssignPlan(
        ClientRepositoryImpl(service: FirestoreClientService()),
      ),
      _service = FirestoreClientService();

  Future<bool> assignClientPlan(String userId, PlanModel plan) async {
    isLoading.value = true;
    error.value = '';
    try {
      print(
        'assignClientPlan: Processing plan for userId: $userId, type: ${plan.type}, id: ${plan.id}',
      );
      final collection = plan.type == 'diet' ? 'diets' : 'workouts';
      if (plan.id.isNotEmpty) {
        // Update existing plan
        await _service.firestore
            .collection(collection)
            .doc(plan.id)
            .update(plan.toMap());
        print(
          'assignClientPlan: Plan updated successfully for userId: $userId, ID: ${plan.id}',
        );
      } else {
        // Add new plan
        final docRef = await _service.firestore
            .collection(collection)
            .add(plan.toMap());
        await docRef.update({'id': docRef.id});
        print(
          'assignClientPlan: Plan assigned successfully for userId: $userId, ID: ${docRef.id}',
        );
      }
      return true;
    } catch (e) {
      error.value = 'Failed to process plan: $e';
      print('assignClientPlan: Error for userId: $userId - $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<PlanModel>> getClientPlans(String userId) async {
    return await _service.getClientPlans(userId);
  }

  Future<void> deletePlan(String planId, String type) async {
    try {
      print('deletePlan: Deleting $type plan with ID: $planId');
      final collection = type == 'diet' ? 'diets' : 'workouts';
      await _service.firestore.collection(collection).doc(planId).delete();
      print('deletePlan: Successfully deleted $type plan with ID: $planId');
    } catch (e) {
      print('deletePlan: Error deleting $type plan with ID: $planId - $e');
      throw Exception('Failed to delete $type plan: $e');
    }
  }
}
