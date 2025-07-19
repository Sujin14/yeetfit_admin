import '../../data/model/plan_model.dart';

abstract class PlanRepository {
  Future<List<PlanModel>> getClientPlans(String userId);
  Future<bool> assignPlan(String userId, PlanModel plan);
  Future<bool> deletePlan(String userId, String planId, String type);
}
