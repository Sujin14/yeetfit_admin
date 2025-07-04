import '../../data/models/dashboard_stats_model.dart';

abstract class DashboardRepository {
  Future<DashboardStatsModel> getClientCounts();
}
