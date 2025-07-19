import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../data/model/plan_model.dart';
import '../../domain/usecases/assign_plan.dart';
import '../../domain/usecases/get_client_plans.dart';
import '../../domain/usecases/delete_plan.dart';
import '../../../../core/theme/theme.dart';

abstract class BasePlanController extends GetxController {
  final AssignPlan assignPlan;
  final GetClientPlans getClientPlans;
  final DeletePlan deletePlan;
  final plans = <PlanModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isEditMode = false.obs;
  final planId = ''.obs;
  final userId = ''.obs;
  final String planType;
  bool isInitialized = false;

  BasePlanController({
    required this.assignPlan,
    required this.getClientPlans,
    required this.deletePlan,
    required this.planType,
  });

  void setupWithArguments(Map<String, dynamic>? args) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId.value = args?['uid'] ?? '';
      isEditMode.value = args?['mode'] == 'edit';
      planId.value = args?['planId'] ?? '';
      if (Get.currentRoute.contains('plan')) {
        initializeForm();
        fetchPlans();
      }
      isInitialized = true;
    });
  }

  void initializeForm();

  Future<void> fetchPlans() async {
    if (userId.value.isEmpty) return;
    isLoading.value = true;
    error.value = '';
    try {
      final fetchedPlans = await getClientPlans(userId.value);
      plans.assignAll(fetchedPlans.where((plan) => plan.type == planType).toList());
    } catch (e) {
      error.value = 'Failed to load plans: $e';
      Get.snackbar('Error', 'Unable to fetch plans. Please try again.',
          backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> savePlan();

  Future<bool> removePlan(String planId) async {
    final confirmed = await showConfirmationDialog('plan');
    if (!confirmed) return false;
    isLoading.value = true;
    try {
      final success = await deletePlan(userId.value, planId, planType);
      if (success) {
        plans.removeWhere((plan) => plan.id == planId);
        Get.snackbar('Success', '$planType plan deleted successfully',
            backgroundColor: AdminTheme.colors['primary'], colorText: AdminTheme.colors['surface']);
      } else {
        error.value = 'Failed to delete plan';
        Get.snackbar('Error', error.value,
            backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      }
      return success;
    } catch (e) {
      error.value = 'Error deleting plan: $e';
      Get.snackbar('Error', error.value,
          backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openPlanForm({required String mode, PlanModel? plan}) async {
    final route = planType == 'diet' ? '/home/diet-plan-management' : '/home/workout-plan-management';
    final result = await Get.toNamed(
      route,
      arguments: {
        'uid': userId.value,
        'type': planType,
        'mode': mode,
        'planId': plan?.id,
        'plan': plan,
      },
    );
    if (result == true) {
      await fetchPlans();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

extension StringExtension on String {
  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}