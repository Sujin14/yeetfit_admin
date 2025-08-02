import '../repositories/progress_repository.dart';

class GetDailyProgress {
  final ProgressRepository repository;

  GetDailyProgress(this.repository);

  Future<Map<String, dynamic>> call(String uid, String date) {
    return repository.getDailyProgress(uid, date);
  }
}
