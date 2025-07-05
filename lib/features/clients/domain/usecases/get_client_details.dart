import '../../data/models/client_model.dart';
import '../repositories/client_repository.dart';

class GetClientDetails {
  final ClientRepository repository;

  GetClientDetails(this.repository);

  Future<ClientModel?> call(String uid) async {
    return await repository.getClientDetails(uid);
  }
}
