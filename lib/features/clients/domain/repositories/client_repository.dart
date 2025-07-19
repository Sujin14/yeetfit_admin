import '../../data/models/client_model.dart';

abstract class ClientRepository {
  Future<List<ClientModel>> getAllClients();
  Stream<List<ClientModel>> getClientsByGoal(String goal);
  Future<ClientModel?> getClientById(String id);
  Future<ClientModel?> getClientDetails(String uid);
  Future<bool> updateClient(ClientModel client);
}
