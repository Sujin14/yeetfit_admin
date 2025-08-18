import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final FirestoreProgressService service;

  ProgressRepositoryImpl(this.service);

  @override
  Future<Map<String, dynamic>> getDailyProgress(String uid, String date) async {
    final progressTypes = {
      'water': 'water',
      'weight': 'weight',
      'steps': 'steps',
      'sleep': 'sleep',
      'food/daily_goals': 'daily_goals',
    };

    final results = <String, dynamic>{};

    for (final entry in progressTypes.entries) {
      final data = await service.getDailyProgress(
        uid: uid,
        category: entry.key.split('/')[0],
        subcategory: entry.value,
        date: date,
      );
      print('Progress for ${entry.key}: $data');
      results[entry.key] = data;
    }

    print('Final progress results: $results');
    return results;
  }
}