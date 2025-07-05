import 'package:get/get.dart';
import '../../data/datasources/firestore_dashboard_service.dart';
import '../../data/models/dashboard_stats_model.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/usecases/get_dashboard_stats.dart';

class DashboardController extends GetxController {
  final GetDashboardStats getDashboardStats;
  final stats = Rxn<DashboardStatsModel>();
  final isLoading = false.obs;
  final error = ''.obs;

  DashboardController()
    : getDashboardStats = GetDashboardStats(
        DashboardRepositoryImpl(service: FirestoreDashboardService()),
      );

  @override
  void onInit() {
    super.onInit();
    fetchStats();
  }

  Future<void> fetchStats() async {
    isLoading.value = true;
    error.value = '';
    try {
      final dashboardStats = await getDashboardStats();
      stats.value = dashboardStats;
    } catch (e) {
      error.value = 'Failed to load dashboard stats: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
