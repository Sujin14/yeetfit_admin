import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/plan_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/assign_plan.dart';
import '../../domain/usecases/get_client_plans.dart';

class PlanController extends GetxController {
  final AssignPlan assignPlan;
  final GetClientPlans getClientPlans;
  final plans = <PlanModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  // Form fields
  final titleController = TextEditingController();
  final meals = <Map<String, dynamic>>[].obs; // For diet plans
  final exercises = <Map<String, dynamic>>[].obs; // For workout plans
  final formKey = GlobalKey<FormState>();
  final isEditMode = false.obs;
  final planId = ''.obs;
  final userId = ''.obs;
  final planType = ''.obs;

  PlanController()
    : assignPlan = AssignPlan(
        ClientRepositoryImpl(service: FirestoreClientService()),
      ),
      getClientPlans = GetClientPlans(
        ClientRepositoryImpl(service: FirestoreClientService()),
      ) {
    print('PlanController: New instance created');
  }

  @override
  void onInit() {
    super.onInit();
    print('PlanController: onInit called');
    initializeForm();
  }

  @override
  void onClose() {
    print('PlanController: onClose called');
    titleController.dispose();
    super.onClose();
  }

  void initializeForm() {
    final args = Get.arguments;
    print('PlanController: Arguments received: $args');
    userId.value = args?['uid'] as String? ?? '';
    planType.value = args?['type'] as String? ?? '';
    isEditMode.value = (args?['mode'] as String?) == 'edit';
    planId.value = args?['planId'] as String? ?? '';

    if (planType.value.isEmpty) {
      print('PlanController: Error - planType is empty, defaulting to diet');
      planType.value = 'diet'; // Fallback
    } else if (planType.value != 'diet' && planType.value != 'workout') {
      print(
        'PlanController: Error - Invalid planType: ${planType.value}, defaulting to diet',
      );
      planType.value = 'diet'; // Fallback for invalid type
    }
    print(
      'PlanController: Initialized with planType: ${planType.value}, userId: ${userId.value}, mode: ${isEditMode.value ? 'edit' : 'add'}',
    );

    // Reset form fields
    titleController.clear();
    meals.clear();
    exercises.clear();

    // Initialize with one empty entry
    if (!isEditMode.value) {
      if (planType.value == 'diet') {
        meals.add({
          'name': '',
          'foods': [
            {'name': '', 'quantity': '', 'calories': ''},
          ],
        });
        print('PlanController: Initialized empty diet meal');
      } else if (planType.value == 'workout') {
        exercises.add({
          'name': '',
          'reps': '',
          'sets': '',
          'description': '',
          'instructions': '',
          'videoUrl': '',
        });
        print('PlanController: Initialized empty workout exercise');
      }
    }
  }

  void addMeal() {
    meals.add({
      'name': '',
      'foods': [
        {'name': '', 'quantity': '', 'calories': ''},
      ],
    });
    meals.refresh();
    update(); // Trigger GetBuilder rebuild
    print('PlanController: Added new meal');
  }

  void addFood(int mealIndex) {
    meals[mealIndex]['foods'].add({'name': '', 'quantity': '', 'calories': ''});
    meals.refresh();
    update(); // Trigger GetBuilder rebuild
    print('PlanController: Added new food to meal at index $mealIndex');
  }

  void addExercise() {
    exercises.add({
      'name': '',
      'reps': '',
      'sets': '',
      'description': '',
      'instructions': '',
      'videoUrl': '',
    });
    exercises.refresh();
    update(); // Trigger GetBuilder rebuild
    print('PlanController: Added new exercise');
  }

  void removeMeal(int index) {
    meals.removeAt(index);
    meals.refresh();
    update(); // Trigger GetBuilder rebuild
    print('PlanController: Removed meal at index $index');
  }

  void removeFood(int mealIndex, int foodIndex) {
    meals[mealIndex]['foods'].removeAt(foodIndex);
    meals.refresh();
    update(); // Trigger GetBuilder rebuild
    print(
      'PlanController: Removed food at mealIndex $mealIndex, foodIndex $foodIndex',
    );
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
    exercises.refresh();
    update(); // Trigger GetBuilder rebuild
    print('PlanController: Removed exercise at index $index');
  }

  Future<bool> savePlan() async {
    print('PlanController: Saving plan with planType: ${planType.value}');
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      error.value = 'Please fill all required fields correctly';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['textPrimary'],
      );
      print('PlanController: Form validation failed');
      return false;
    }
    isLoading.value = true;
    error.value = '';
    try {
      final plan = PlanModel(
        id: isEditMode.value ? planId.value : null,
        title: titleController.text.trim().isEmpty
            ? 'Unnamed Plan'
            : titleController.text.trim(),
        type: planType.value,
        userId: userId.value,
        assignedBy: FirebaseAuth.instance.currentUser?.uid,
        details: planType.value == 'diet'
            ? {
                'meals': meals.map((meal) {
                  return {
                    'name': meal['name']?.trim() ?? '',
                    'foods': (meal['foods'] as List).map((food) {
                      return {
                        'name': food['name']?.trim() ?? '',
                        'quantity': food['quantity']?.trim() ?? '',
                        'calories': int.tryParse(food['calories'] ?? '0') ?? 0,
                      };
                    }).toList(),
                  };
                }).toList(),
              }
            : {
                'exercises': exercises.map((exercise) {
                  return {
                    'name': exercise['name']?.trim() ?? '',
                    'reps': int.tryParse(exercise['reps'] ?? '0') ?? 0,
                    'sets': int.tryParse(exercise['sets'] ?? '0') ?? 0,
                    'description': exercise['description']?.trim() ?? '',
                    'instructions': exercise['instructions']?.trim() ?? '',
                    'videoUrl': exercise['videoUrl']?.trim() ?? '',
                  };
                }).toList(),
              },
        createdAt: Timestamp.now(),
      );
      print('PlanController: Saving plan to Firestore');
      final success = await assignPlan(userId.value, plan);
      if (success) {
        Get.back();
        Get.snackbar(
          'Success',
          '${planType.value.capitalizeFirstLetter} plan ${isEditMode.value ? 'updated' : 'assigned'} successfully',
          backgroundColor: AdminTheme.colors['primary'],
          colorText: AdminTheme.colors['textPrimary'],
        );
        print('PlanController: Plan saved successfully');
      } else {
        error.value = 'Failed to save plan';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['textPrimary'],
        );
        print('PlanController: Failed to save plan');
      }
      return success;
    } catch (e) {
      error.value = 'Error saving plan: $e';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['textPrimary'],
      );
      print('PlanController: Error saving plan: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deletePlan(String planId) async {
    print('PlanController: Deleting plan with ID: $planId');
    isLoading.value = true;
    try {
      final collection = planType.value == 'diet' ? 'diets' : 'workouts';
      await FirestoreClientService().firestore
          .collection(collection)
          .doc(planId)
          .delete();
      plans.removeWhere((plan) => plan.id == planId);
      Get.snackbar(
        'Success',
        '${planType.value.capitalizeFirstLetter} plan deleted successfully',
        backgroundColor: AdminTheme.colors['primary'],
        colorText: AdminTheme.colors['textPrimary'],
      );
      print('PlanController: Plan deleted successfully');
      return true;
    } catch (e) {
      error.value = 'Error deleting plan: $e';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['textPrimary'],
      );
      print('PlanController: Error deleting plan: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}

extension StringExtension on String {
  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
