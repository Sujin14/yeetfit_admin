import '../../data/models/client_model.dart';
import '../repositories/client_repository.dart';

class GetClientsByGoal {
  final ClientRepository repository;

  GetClientsByGoal(this.repository);

  Stream<List<ClientModel>> call(String goal) {
    return repository.getClientsByGoal(goal);
  }
}