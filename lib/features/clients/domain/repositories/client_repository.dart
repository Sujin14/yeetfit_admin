import '../../data/models/client_model.dart';
import '../../data/models/plan_model.dart';

abstract class ClientRepository {
  Stream<List<ClientModel>> getClientsByGoal(String goal);
  Future<ClientModel?> getClientDetails(String uid);
  Future<List<PlanModel>> getClientPlans(String userId);
  Future<bool> assignPlan(String userId, PlanModel plan);
  Future<bool> deletePlan(String userId, String planId, String type);
}
