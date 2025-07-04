import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/firestore_dashboard_service.dart';
import '../models/dashboard_stats_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final FirestoreDashboardService service;

  DashboardRepositoryImpl({required this.service});

  @override
  Future<DashboardStatsModel> getClientCounts() async {
    final counts = await service.getClientCounts();
    return DashboardStatsModel.fromMap(counts);
  }
}
