import '../../data/model/plan_model.dart';
import '../repositories/plan_repository.dart';

class GetClientPlans {
  final PlanRepository repository;

  GetClientPlans(this.repository);

  Future<List<PlanModel>> call(String userId) async {
    return await repository.getClientPlans(userId);
  }
}
