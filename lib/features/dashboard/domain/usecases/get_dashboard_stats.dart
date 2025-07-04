import '../../data/models/dashboard_stats_model.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardStats {
  final DashboardRepository repository;

  GetDashboardStats(this.repository);

  Future<DashboardStatsModel> call() async {
    return await repository.getClientCounts();
  }
}
