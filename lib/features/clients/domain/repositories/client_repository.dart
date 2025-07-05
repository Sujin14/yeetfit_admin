import '../../data/models/client_model.dart';
import '../../data/models/plan_model.dart';
import '../../data/models/progress_model.dart';

abstract class ClientRepository {
  Future<List<ClientModel>> getClientsByGoal(String goal);
  Future<ClientModel?> getClientDetails(String uid);
  Future<List<ProgressModel>> getClientProgress(String uid);
  Future<List<PlanModel>> getClientPlans(String userId);
  Future<bool> assignPlan(String userId, PlanModel plan);
}
