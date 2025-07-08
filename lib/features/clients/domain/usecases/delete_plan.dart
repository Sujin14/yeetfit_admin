import '../repositories/client_repository.dart';

class DeletePlan {
  final ClientRepository repository;

  DeletePlan(this.repository);

  Future<bool> call(String userId, String planId, String type) async {
    return await repository.deletePlan(userId, planId, type);
  }
}
