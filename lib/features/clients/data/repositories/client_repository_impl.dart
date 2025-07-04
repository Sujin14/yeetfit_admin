import '../../domain/repositories/client_repository.dart';
import '../datasources/firestore_client_service.dart';
import '../models/client_model.dart';
import '../models/plan_model.dart';
import '../models/progress_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final FirestoreClientService service;

  ClientRepositoryImpl({required this.service});

  @override
  Future<List<ClientModel>> getClientsByGoal(String goal) {
    return service.getClientsByGoal(goal);
  }

  @override
  Future<ClientModel?> getClientDetails(String uid) {
    return service.getClientDetails(uid);
  }

  @override
  Future<List<ProgressModel>> getClientProgress(String uid) {
    return service.getClientProgress(uid);
  }

  @override
  Future<List<PlanModel>> getClientPlans(String userId) {
    return service.getClientPlans(userId);
  }

  @override
  Future<bool> assignPlan(String userId, PlanModel plan) {
    return service.assignPlan(userId, plan);
  }
}
