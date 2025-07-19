import '../../domain/repositories/client_repository.dart';
import '../datasources/firestore_client_service.dart';
import '../models/client_model.dart';

class ClientRepositoryImpl implements ClientRepository {
  final FirestoreClientService service;

  ClientRepositoryImpl(this.service);

  @override
  Future<List<ClientModel>> getAllClients() {
    return service.getAllClients();
  }

  @override
  Stream<List<ClientModel>> getClientsByGoal(String goal) {
    return service.getClientsByGoal(goal);
  }

  @override
  Future<ClientModel?> getClientById(String id) {
    return service.getClientDetails(id);
  }

  @override
  Future<ClientModel?> getClientDetails(String uid) {
    return service.getClientDetails(uid);
  }

  @override
  Future<bool> updateClient(ClientModel client) {
    return service.updateClient(client);
  }
}
