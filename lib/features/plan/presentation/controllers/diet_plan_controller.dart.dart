import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../data/datasource/firestore_plan_service.dart';
import '../../data/model/plan_model.dart';
import '../../data/repositories/plan_repository_impl.dart';
import '../../domain/usecases/assign_plan.dart';
import '../../domain/usecases/get_client_plans.dart';
import '../../domain/usecases/delete_plan.dart';
import 'base_plan_controller.dart.dart';


class DietPlanController extends BasePlanController {
  final meals = <Map<String, dynamic>>[].obs;

  DietPlanController()
      : super(
          assignPlan: AssignPlan(PlanRepositoryImpl(service: FirestorePlanService())),
          getClientPlans: GetClientPlans(PlanRepositoryImpl(service: FirestorePlanService())),
          deletePlan: DeletePlan(PlanRepositoryImpl(service: FirestorePlanService())),
          planType: 'diet',
        );

  @override
  void initializeForm() {
    isLoading.value = true;
    final args = Get.arguments;
    userId.value = args?['uid'] ?? '';
    isEditMode.value = args?['mode'] == 'edit';
    planId.value = args?['planId'] ?? '';

    titleController.clear();
    descriptionController.clear();
    meals.clear();

    if (isEditMode.value && args?['plan'] != null) {
      final PlanModel plan = args['plan'];
      titleController.text = plan.title;
      descriptionController.text = plan.details['description']?.toString() ?? '';
      meals.assignAll(
        (plan.details['meals'] as List).map((meal) {
          return {
            'name': meal['name'] ?? '',
            'controllers': {
              'name': TextEditingController(text: meal['name'] ?? ''),
            },
            'foods': (meal['foods'] as List).map((food) {
              return {
                'name': food['name'] ?? '',
                'quantity': food['quantity'].toString(),
                'calories': food['calories'].toString(),
                'unit': food['unit'] ?? 'g',
                'description': food['description'] ?? '',
                'controllers': {
                  'name': TextEditingController(text: food['name'] ?? ''),
                  'quantity': TextEditingController(text: food['quantity'].toString()),
                  'calories': TextEditingController(text: food['calories'].toString()),
                  'description': TextEditingController(text: food['description'] ?? ''),
                },
              };
            }).toList(),
          };
        }).toList(),
      );
    } else {
      addMeal();
    }
    isLoading.value = false;
  }

  void addMeal() {
    meals.add({
      'name': '',
      'controllers': {'name': TextEditingController()},
      'foods': [
        {
          'name': '',
          'quantity': '',
          'calories': '',
          'unit': 'g',
          'description': '',
          'controllers': {
            'name': TextEditingController(),
            'quantity': TextEditingController(),
            'calories': TextEditingController(),
            'description': TextEditingController(),
          },
        },
      ],
    });
    meals.refresh();
    update();
  }

  void addFood(int mealIndex) {
    meals[mealIndex]['foods'].add({
      'name': '',
      'quantity': '',
      'calories': '',
      'unit': 'g',
      'description': '',
      'controllers': {
        'name': TextEditingController(),
        'quantity': TextEditingController(),
        'calories': TextEditingController(),
        'description': TextEditingController(),
      },
    });
    meals.refresh();
    update();
  }

  Future<bool> removeMeal(int index) async {
    final confirmed = await showConfirmationDialog('meal');
    if (!confirmed) return false;
    final controllers = meals[index]['controllers'] as Map<String, TextEditingController>;
    for (var c in controllers.values) {
      c.dispose();
    }
    for (final food in meals[index]['foods']) {
      final fc = food['controllers'] as Map<String, TextEditingController>;
      for (var c in fc.values) {
        c.dispose();
      }
    }
    meals.removeAt(index);
    meals.refresh();
    update();
    return true;
  }

  Future<bool> removeFood(int mealIndex, int foodIndex) async {
    final confirmed = await showConfirmationDialog('food');
    if (!confirmed) return false;
    final fc = meals[mealIndex]['foods'][foodIndex]['controllers'] as Map<String, TextEditingController>;
    for (var c in fc.values) {
      c.dispose();
    }
    meals[mealIndex]['foods'].removeAt(foodIndex);
    meals.refresh();
    update();
    return true;
  }

  void updateUnit(int mealIndex, int foodIndex, String unit) {
    meals[mealIndex]['foods'][foodIndex]['unit'] = unit;
    meals.refresh();
    update();
  }

  @override
  Future<bool> savePlan() async {
    if (userId.value.isEmpty) {
      error.value = 'No client selected. Please try again.';
      Get.snackbar('Error', error.value,
          backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      return false;
    }

    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return false;
    }

    final plan = PlanModel(
      id: isEditMode.value ? planId.value : null,
      title: titleController.text.trim().isEmpty ? 'Unnamed Plan' : titleController.text.trim(),
      type: planType,
      userId: userId.value,
      assignedBy: FirebaseAuth.instance.currentUser?.uid ?? '',
      details: {
        'description': descriptionController.text.trim(),
        'meals': meals.map((meal) {
          return {
            'name': meal['controllers']['name'].text.trim(),
            'foods': (meal['foods'] as List).map((food) {
              return {
                'name': food['controllers']['name'].text.trim(),
                'quantity': food['controllers']['quantity'].text.trim(),
                'unit': food['unit'] ?? 'g',
                'calories': int.tryParse(food['controllers']['calories'].text.trim()) ?? 0,
                'description': food['controllers']['description'].text.trim(),
              };
            }).toList(),
          };
        }).toList(),
      },
      isFavorite: isEditMode.value ? plans.firstWhereOrNull((p) => p.id == planId.value)?.isFavorite ?? false : false,
      createdAt: Timestamp.now(),
    );

    isLoading.value = true;
    error.value = '';
    try {
      final success = await assignPlan(userId.value, plan);
      if (success) {
        await fetchPlans();
        Get.back(result: true);
        Get.snackbar('Success', '$planType plan ${isEditMode.value ? 'updated' : 'assigned'} successfully',
            backgroundColor: AdminTheme.colors['primary'], colorText: AdminTheme.colors['surface']);
      } else {
        error.value = 'Failed to save plan';
        Get.snackbar('Error', error.value,
            backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      }
      return success;
    } catch (e) {
      error.value = 'Error saving plan: $e';
      Get.snackbar('Error', error.value,
          backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (final meal in meals) {
      for (var c in (meal['controllers'] as Map<String, TextEditingController>).values) {
        c.dispose();
      }
      for (final food in meal['foods']) {
        for (var c in (food['controllers'] as Map<String, TextEditingController>).values) {
          c.dispose();
        }
      }
    }
    super.onClose();
  }
}