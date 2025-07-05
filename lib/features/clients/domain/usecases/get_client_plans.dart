import '../../data/models/plan_model.dart';
import '../repositories/client_repository.dart';

class GetClientPlans {
  final ClientRepository repository;

  GetClientPlans(this.repository);

  Future<List<PlanModel>> call(String userId) async {
    return await repository.getClientPlans(userId);
  }
}
