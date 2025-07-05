import '../../data/models/client_model.dart';
import '../repositories/client_repository.dart';

class GetClientsByGoal {
  final ClientRepository repository;

  GetClientsByGoal(this.repository);

  Future<List<ClientModel>> call(String goal) async {
    return await repository.getClientsByGoal(goal);
  }
}
