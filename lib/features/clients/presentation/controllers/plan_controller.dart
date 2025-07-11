import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/datasources/firestore_client_service.dart';
import '../../data/models/plan_model.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/usecases/assign_plan.dart';
import '../../domain/usecases/get_client_plans.dart';
import '../../domain/usecases/delete_plan.dart';
import '../../../../core/theme/theme.dart';

class PlanController extends GetxController {
  bool isInitialized = false;
  final AssignPlan assignPlan;
  final GetClientPlans getClientPlans;
  final DeletePlan deletePlan;
  final plans = <PlanModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  // Form fields
  final titleController = TextEditingController();
  final meals = <Map<String, dynamic>>[].obs;
  final exercises = <Map<String, dynamic>>[].obs;
  final descriptionController = TextEditingController();
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
      ),
      deletePlan = DeletePlan(
        ClientRepositoryImpl(service: FirestoreClientService()),
      );

  void setupWithArguments(Map<String, dynamic>? args) {
    userId.value = args?['uid'] ?? '';
    planType.value = args?['type'] ?? '';
    isEditMode.value = args?['mode'] == 'edit';
    planId.value = args?['planId'] ?? '';
    if (Get.currentRoute.contains('plan')) {
      initializeForm();
      fetchPlans();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    for (final meal in meals) {
      for (var c
          in (meal['controllers'] as Map<String, TextEditingController>)
              .values) {
        c.dispose();
      }
      for (final food in meal['foods']) {
        for (var c
            in (food['controllers'] as Map<String, TextEditingController>)
                .values) {
          c.dispose();
        }
      }
    }
    for (final ex in exercises) {
      for (var c
          in (ex['controllers'] as Map<String, TextEditingController>).values) {
        c.dispose();
      }
    }
    super.onClose();
  }

  void initializeForm() {
    isLoading.value = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments;
      userId.value = args?['uid'] ?? '';
      planType.value = args?['type'] ?? '';
      isEditMode.value = args?['mode'] == 'edit';
      planId.value = args?['planId'] ?? '';

      titleController.clear();
      descriptionController.clear();
      meals.clear();
      exercises.clear();

      if (isEditMode.value && args?['plan'] != null) {
        final PlanModel plan = args['plan'];
        titleController.text = plan.title;
        descriptionController.text =
            plan.details['description']?.toString() ?? '';

        if (planType.value == 'diet') {
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
                      'quantity': TextEditingController(
                        text: food['quantity'].toString(),
                      ),
                      'calories': TextEditingController(
                        text: food['calories'].toString(),
                      ),
                      'description': TextEditingController(
                        text: food['description'] ?? '',
                      ),
                    },
                  };
                }).toList(),
              };
            }).toList(),
          );
        } else {
          exercises.assignAll(
            (plan.details['exercises'] as List).map((exercise) {
              return {
                'name': exercise['name'] ?? '',
                'repsType': exercise['repsType'] ?? 'reps',
                'reps': exercise['reps'].toString(),
                'sets': exercise['sets'].toString(),
                'description': exercise['description'] ?? '',
                'instructions': exercise['instructions'] ?? '',
                'videoUrl': exercise['videoUrl'] ?? '',
                'controllers': {
                  'name': TextEditingController(text: exercise['name'] ?? ''),
                  'reps': TextEditingController(
                    text: exercise['reps'].toString(),
                  ),
                  'sets': TextEditingController(
                    text: exercise['sets'].toString(),
                  ),
                  'description': TextEditingController(
                    text: exercise['description'] ?? '',
                  ),
                  'instructions': TextEditingController(
                    text: exercise['instructions'] ?? '',
                  ),
                  'videoUrl': TextEditingController(
                    text: exercise['videoUrl'] ?? '',
                  ),
                },
              };
            }).toList(),
          );
        }
      } else {
        if (planType.value == 'diet') addMeal();
        if (planType.value == 'workout') addExercise();
      }

      isLoading.value = false;
    });
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

  void addExercise() {
    exercises.add({
      'name': '',
      'repsType': 'reps',
      'reps': '',
      'sets': '',
      'description': '',
      'instructions': '',
      'videoUrl': '',
      'controllers': {
        'name': TextEditingController(),
        'reps': TextEditingController(),
        'sets': TextEditingController(),
        'description': TextEditingController(),
        'instructions': TextEditingController(),
        'videoUrl': TextEditingController(),
      },
    });
    exercises.refresh();
    update();
  }

  void removeMeal(int index) {
    final controllers =
        meals[index]['controllers'] as Map<String, TextEditingController>;
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
  }

  void removeFood(int mealIndex, int foodIndex) {
    final fc =
        meals[mealIndex]['foods'][foodIndex]['controllers']
            as Map<String, TextEditingController>;
    for (var c in fc.values) {
      c.dispose();
    }
    meals[mealIndex]['foods'].removeAt(foodIndex);
    meals.refresh();
    update();
  }

  void removeExercise(int index) {
    final controllers =
        exercises[index]['controllers'] as Map<String, TextEditingController>;
    for (var c in controllers.values) {
      c.dispose();
    }
    exercises.removeAt(index);
    exercises.refresh();
    update();
  }

  void updateRepsType(int index, String repsType) {
    exercises[index]['repsType'] = repsType;
    exercises[index]['controllers']['reps'].clear();
    exercises.refresh();
    update();
  }

  void updateUnit(int mealIndex, int foodIndex, String unit) {
    meals[mealIndex]['foods'][foodIndex]['unit'] = unit;
    meals.refresh();
    update();
  }

  Future<void> fetchPlans() async {
    if (userId.value.isEmpty || planType.value.isEmpty) return;
    isLoading.value = true;
    error.value = '';
    try {
      final fetchedPlans = await getClientPlans(userId.value);
      plans.assignAll(
        fetchedPlans.where((plan) => plan.type == planType.value).toList(),
      );
    } catch (e) {
      error.value = 'Failed to load plans: $e';
      Get.snackbar(
        'Error',
        'Unable to fetch plans. Please try again.',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    } finally {
      isLoading.value = false;
    }
  }

  void editPlan(PlanModel plan) {
    Get.toNamed(
      plan.type == 'diet'
          ? '/home/diet-plan-management'
          : '/home/workout-plan-management',
      arguments: {
        'uid': userId.value,
        'type': plan.type,
        'mode': 'edit',
        'planId': plan.id,
        'plan': plan,
      },
    );
  }

  Future<bool> savePlan() async {
  if (userId.value.isEmpty) {
    error.value = 'No client selected. Please try again.';
    Get.snackbar(
      'Error',
      error.value,
      backgroundColor: AdminTheme.colors['error'],
      colorText: AdminTheme.colors['surface'],
    );
    return false;
  }

  if (formKey.currentState == null || !formKey.currentState!.validate()) {
    error.value = 'Please fill all required fields correctly';
    Get.snackbar(
      'Error',
      error.value,
      backgroundColor: AdminTheme.colors['error'],
      colorText: AdminTheme.colors['surface'],
    );
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
              'description': descriptionController.text.trim(),
              'meals': meals.map((meal) {
                return {
                  'name': meal['controllers']['name'].text.trim(),
                  'foods': (meal['foods'] as List).map((food) {
                    return {
                      'name': food['controllers']['name'].text.trim(),
                      'quantity': food['controllers']['quantity'].text.trim(),
                      'unit': food['unit'] ?? 'g',
                      'calories': int.tryParse(
                            food['controllers']['calories'].text.trim(),
                          ) ??
                          0,
                      'description':
                          food['controllers']['description'].text.trim(),
                    };
                  }).toList(),
                };
              }).toList(),
            }
          : {
              'description': descriptionController.text.trim(),
              'exercises': exercises.map((exercise) {
                return {
                  'name': exercise['controllers']['name'].text.trim(),
                  'repsType': exercise['repsType'],
                  'reps': exercise['controllers']['reps'].text.trim(),
                  'sets': exercise['controllers']['sets'].text.trim(),
                  'description':
                      exercise['controllers']['description'].text.trim(),
                  'instructions':
                      exercise['controllers']['instructions'].text.trim(),
                  'videoUrl': exercise['controllers']['videoUrl'].text.trim(),
                };
              }).toList(),
            },
      isFavorite: isEditMode.value
          ? plans.firstWhereOrNull((p) => p.id == planId.value)?.isFavorite ??
              false
          : false,
      createdAt: Timestamp.now(),
    );

    final success = await assignPlan(userId.value, plan);

    if (success) {
      await fetchPlans(); // 🔁 Update list
      Get.back(result: true); // ✅ Trigger refresh when returning
      Get.snackbar(
        'Success',
        '${planType.value.capitalizeFirstLetter} plan ${isEditMode.value ? 'updated' : 'assigned'} successfully',
        backgroundColor: AdminTheme.colors['primary'],
        colorText: AdminTheme.colors['surface'],
      );
    } else {
      error.value = 'Failed to save plan';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    }
    return success;
  } catch (e) {
    error.value = 'Error saving plan: $e';
    Get.snackbar(
      'Error',
      error.value,
      backgroundColor: AdminTheme.colors['error'],
      colorText: AdminTheme.colors['surface'],
    );
    return false;
  } finally {
    isLoading.value = false;
  }
}


  Future<bool> removePlan(String planId) async {
    final confirmed =
        await Get.dialog<bool>(
          AlertDialog(
            title: Text('Confirm Delete'),
            content: Text(
              'Are you sure you want to delete this ${planType.value} plan?',
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

    if (!confirmed) return false;

    isLoading.value = true;
    try {
      final success = await deletePlan(userId.value, planId, planType.value);
      if (success) {
        plans.removeWhere((plan) => plan.id == planId);
        Get.snackbar(
          'Success',
          '${planType.value.capitalizeFirstLetter} plan deleted successfully',
          backgroundColor: AdminTheme.colors['primary'],
          colorText: AdminTheme.colors['surface'],
        );
      } else {
        error.value = 'Failed to delete plan';
        Get.snackbar(
          'Error',
          error.value,
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['surface'],
        );
      }
      return success;
    } catch (e) {
      error.value = 'Error deleting plan: $e';
      Get.snackbar(
        'Error',
        error.value,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openPlanForm({required String mode, PlanModel? plan}) async {
  final result = await Get.toNamed(
    planType.value == 'diet'
        ? '/home/diet-plan-management'
        : '/home/workout-plan-management',
    arguments: {
      'uid': userId.value,
      'type': planType.value,
      'mode': mode,
      'planId': plan?.id,
      'plan': plan,
    },
  );
  if (result == true) {
    await fetchPlans();
  }
}

}

extension StringExtension on String {
  String get capitalizeFirstLetter {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
