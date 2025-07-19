
import 'package:yeetfit_admin/features/plan/domain/repositories/plan_repository.dart';

import '../datasource/firestore_plan_service.dart';
import '../model/plan_model.dart';

class PlanRepositoryImpl implements PlanRepository {
  final FirestorePlanService service;

  PlanRepositoryImpl({required this.service});

  @override
  Future<List<PlanModel>> getClientPlans(String userId) {
    return service.getClientPlans(userId);
  }

  @override
  Future<bool> assignPlan(String userId, PlanModel plan) {
    return service.assignPlan(userId, plan);
  }

  @override
  Future<bool> deletePlan(String userId, String planId, String type) {
    return service.deletePlan(userId, planId, type);
  }
}
