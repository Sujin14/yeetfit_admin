import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/plan_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/assign_plan.dart';
import '../../domain/usecases/get_client_plans.dart';
import '../../../../core/theme/theme.dart';

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
    fetchPlans();
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
      planType.value = 'diet';
    } else if (planType.value != 'diet' && planType.value != 'workout') {
      print(
        'PlanController: Error - Invalid planType: ${planType.value}, defaulting to diet',
      );
      planType.value = 'diet';
    }
    print(
      'PlanController: Initialized with planType: ${planType.value}, userId: ${userId.value}, mode: ${isEditMode.value ? 'edit' : 'add'}',
    );

    titleController.clear();
    meals.clear();
    exercises.clear();

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
          'repsType': 'reps', // Default to reps
          'reps': '',
          'sets': '',
          'description': '',
          'instructions': '',
          'videoUrl': '',
        });
        print('PlanController: Initialized empty workout exercise');
      }
    } else {
      if (args?['plan'] != null) {
        final PlanModel plan = args['plan'];
        titleController.text = plan.title;
        if (planType.value == 'diet') {
          meals.assignAll(
            plan.details['meals']
                    ?.map(
                      (meal) => {
                        'name': meal['name'] ?? '',
                        'foods': (meal['foods'] as List)
                            .map(
                              (food) => {
                                'name': food['name'] ?? '',
                                'quantity': food['quantity'] ?? '',
                                'calories': food['calories']?.toString() ?? '',
                              },
                            )
                            .toList(),
                      },
                    )
                    .toList() ??
                [],
          );
        } else if (planType.value == 'workout') {
          exercises.assignAll(
            plan.details['exercises']
                    ?.map(
                      (exercise) => {
                        'name': exercise['name'] ?? '',
                        'repsType': exercise['repsType'] ?? 'reps',
                        'reps': exercise['reps']?.toString() ?? '',
                        'sets': exercise['sets']?.toString() ?? '',
                        'description': exercise['description'] ?? '',
                        'instructions': exercise['instructions'] ?? '',
                        'videoUrl': exercise['videoUrl'] ?? '',
                      },
                    )
                    .toList() ??
                [],
          );
        }
        print(
          'PlanController: Populated form for edit mode with plan: ${plan.title}',
        );
      }
    }
  }

  Future<void> fetchPlans() async {
    if (userId.value.isEmpty || planType.value.isEmpty) {
      print('PlanController: Cannot fetch plans, userId or planType is empty');
      return;
    }
    isLoading.value = true;
    error.value = '';
    try {
      print(
        'PlanController: Fetching plans for userId: ${userId.value}, type: ${planType.value}',
      );
      final fetchedPlans = await getClientPlans(userId.value);
      print(
        'PlanController: Raw fetched plans: ${fetchedPlans.map((p) => p.toMap()).toList()}',
      );
      plans.assignAll(
        fetchedPlans.where((plan) => plan.type == planType.value).toList(),
      );
      print(
        'PlanController: Filtered plans: ${plans.map((p) => p.toMap()).toList()}',
      );
      print('PlanController: Fetched ${plans.length} plans');
      if (plans.isEmpty) {
        print(
          'PlanController: No plans found for userId: ${userId.value}, type: ${planType.value}',
        );
      }
    } catch (e) {
      error.value = 'Failed to load plans: $e';
      Get.snackbar(
        'Error',
        'Unable to fetch plans. Please try again.',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['textPrimary'],
      );
      print('PlanController: Error fetching plans: $e');
    } finally {
      isLoading.value = false;
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
    update();
    print('PlanController: Added new meal');
  }

  void addFood(int mealIndex) {
    meals[mealIndex]['foods'].add({'name': '', 'quantity': '', 'calories': ''});
    meals.refresh();
    update();
    print('PlanController: Added new food to meal at index $mealIndex');
  }

  void addExercise() {
    exercises.add({
      'name': '',
      'repsType': 'reps',
      'reps': '',
      'sets': '',
      'description': '',
      'instructions': '',
      'videoUrl': '',
    });
    exercises.refresh();
    update();
    print('PlanController: Added new exercise');
  }

  void removeMeal(int index) {
    meals.removeAt(index);
    meals.refresh();
    update();
    print('PlanController: Removed meal at index $index');
  }

  void removeFood(int mealIndex, int foodIndex) {
    meals[mealIndex]['foods'].removeAt(foodIndex);
    meals.refresh();
    update();
    print(
      'PlanController: Removed food at mealIndex $mealIndex, foodIndex $foodIndex',
    );
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
    exercises.refresh();
    update();
    print('PlanController: Removed exercise at index $index');
  }

  void updateRepsType(int index, String repsType) {
    exercises[index]['repsType'] = repsType;
    exercises[index]['reps'] = ''; // Reset reps when type changes
    exercises.refresh();
    update();
    print('PlanController: Updated repsType to $repsType at index $index');
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
        assignedBy: FirebaseAuth.instance.currentUser?.uid ?? '',
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
                    'repsType': exercise['repsType'] ?? 'reps',
                    'reps': exercise['reps']?.trim() ?? '',
                    'sets': exercise['sets']?.trim() ?? '',
                    'description': exercise['description']?.trim() ?? '',
                    'instructions': exercise['instructions']?.trim() ?? '',
                    'videoUrl': exercise['videoUrl']?.trim() ?? '',
                  };
                }).toList(),
              },
        createdAt: Timestamp.now(),
      );
      print(
        'PlanController: Saving plan with ID: ${plan.id ?? "new"}, userId: ${plan.userId}, type: ${plan.type}',
      );
      final success = await assignPlan(userId.value, plan);
      if (success) {
        print(
          'PlanController: Plan saved successfully, fetching updated plans',
        );
        await fetchPlans();
        Get.back();
        Get.snackbar(
          'Success',
          '${planType.value.capitalizeFirstLetter} plan ${isEditMode.value ? 'updated' : 'assigned'} successfully',
          backgroundColor: AdminTheme.colors['primary'],
          colorText: AdminTheme.colors['textPrimary'],
        );
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
    print('PlanController: Attempting to delete plan with ID: $planId');
    final confirmed =
        await Get.dialog<bool>(
          AlertDialog(
            title: Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete this ${planType.value} plan? This action cannot be undone.',
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(result: false),
                child: Text(
                  'Cancel',
                  style: TextStyle(color: AdminTheme.colors['textSecondary']),
                ),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: Text(
                  'Delete',
                  style: TextStyle(color: AdminTheme.colors['error']),
                ),
              ),
            ],
          ),
        ) ??
        false;

    if (!confirmed) {
      print('PlanController: Deletion cancelled for plan ID: $planId');
      return false;
    }

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
