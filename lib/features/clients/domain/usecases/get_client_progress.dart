import '../../data/models/progress_model.dart';
import '../repositories/client_repository.dart';

class GetClientProgress {
  final ClientRepository repository;

  GetClientProgress(this.repository);

  Future<List<ProgressModel>> call(String uid) async {
    return await repository.getClientProgress(uid);
  }
}
