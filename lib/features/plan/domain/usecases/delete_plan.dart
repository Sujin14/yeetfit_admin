import 'package:yeetfit_admin/features/plan/domain/repositories/plan_repository.dart';

class DeletePlan {
  final PlanRepository repository;

  DeletePlan(this.repository);

  Future<bool> call(String userId, String planId, String type) async {
    return await repository.deletePlan(userId, planId, type);
  }
}
