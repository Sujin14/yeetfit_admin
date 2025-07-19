import '../../data/model/plan_model.dart';
import '../repositories/plan_repository.dart';

class AssignPlan {
  final PlanRepository repository;

  AssignPlan(this.repository);

  Future<bool> call(String userId, PlanModel plan) async {
    return await repository.assignPlan(userId, plan);
  }
}
