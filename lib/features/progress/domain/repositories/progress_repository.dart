abstract class ProgressRepository {
  Future<Map<String, dynamic>> getDailyProgress(String uid, String date);
}
