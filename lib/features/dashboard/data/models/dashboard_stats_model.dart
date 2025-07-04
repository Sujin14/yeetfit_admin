class DashboardStatsModel {
  final int weightLossCount;
  final int weightGainCount;
  final int muscleBuildingCount;

  DashboardStatsModel({
    required this.weightLossCount,
    required this.weightGainCount,
    required this.muscleBuildingCount,
  });

  factory DashboardStatsModel.fromMap(Map<String, int> map) {
    return DashboardStatsModel(
      weightLossCount: map['Weight Loss'] ?? 0,
      weightGainCount: map['Weight Gain'] ?? 0,
      muscleBuildingCount: map['Muscle Building'] ?? 0,
    );
  }
}

extension DashboardStatsExtension on DashboardStatsModel {
  int getCount(String goal) {
    switch (goal) {
      case 'Weight Loss':
        return weightLossCount;
      case 'Weight Gain':
        return weightGainCount;
      case 'Muscle Building':
        return muscleBuildingCount;
      default:
        return 0;
    }
  }
}
