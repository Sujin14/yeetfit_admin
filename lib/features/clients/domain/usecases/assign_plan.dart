import '../../data/models/plan_model.dart';
import '../repositories/client_repository.dart';

class AssignPlan {
  final ClientRepository repository;

  AssignPlan(this.repository);

  Future<bool> call(String userId, PlanModel plan) async {
    return await repository.assignPlan(userId, plan);
  }
}
