import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  // Form fields for diet
  final dietTitleController = TextEditingController();
  final meals = <Map<String, dynamic>>[]
      .obs; // [{name: String, foods: [{name: String, quantity: String, calories: String}]}]

  // Form fields for workout
  final workoutTitleController = TextEditingController();
  final exercises = <Map<String, dynamic>>[]
      .obs; // [{name: String, reps: String, sets: String, description: String, instructions: String, videoUrl: String}]

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
      );

  @override
  void onInit() {
    super.onInit();
    initializeForm();
  }

  @override
  void onClose() {
    dietTitleController.dispose();
    workoutTitleController.dispose();
    super.onClose();
  }

  void initializeForm() {
    final args = Get.arguments;
    print('PlanController: Arguments received: $args');
    userId.value = args?['uid'] as String? ?? '';
    planType.value = args?['type'] as String? ?? 'diet';
    isEditMode.value = (args?['mode'] as String?) == 'edit';
    planId.value = args?['planId'] as String? ?? '';

    if (isEditMode.value && planId.value.isNotEmpty) {
      fetchPlanForEdit(planId.value);
    } else {
      // Initialize with one empty meal/exercise
      if (planType.value == 'diet') {
        meals.add({
          'name': '',
          'foods': [
            {'name': '', 'quantity': '', 'calories': ''},
          ],
        });
      } else {
        exercises.add({
          'name': '',
          'reps': '',
          'sets': '',
          'description': '',
          'instructions': '',
          'videoUrl': '',
        });
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
  }

  void addFood(int mealIndex) {
    meals[mealIndex]['foods'].add({'name': '', 'quantity': '', 'calories': ''});
    meals.refresh();
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
  }

  void removeMeal(int index) {
    meals.removeAt(index);
  }

  void removeFood(int mealIndex, int foodIndex) {
    meals[mealIndex]['foods'].removeAt(foodIndex);
    meals.refresh();
  }

  void removeExercise(int index) {
    exercises.removeAt(index);
  }

  Future<void> fetchPlanForEdit(String planId) async {
    isLoading.value = true;
    try {
      final planList = await getClientPlans(userId.value);
      final plan = planList.firstWhereOrNull((p) => p.id == planId);
      if (plan != null) {
        if (planType.value == 'diet') {
          dietTitleController.text = plan.title;
          meals.assignAll(plan.details['meals'] ?? []);
        } else {
          workoutTitleController.text = plan.title;
          exercises.assignAll(plan.details['exercises'] ?? []);
        }
      } else {
        error.value = 'Plan not found';
      }
    } catch (e) {
      error.value = 'Failed to load plan: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> savePlan() async {
    if (!formKey.currentState!.validate()) return false;
    isLoading.value = true;
    try {
      final plan = PlanModel(
        id: isEditMode.value ? planId.value : null,
        title: planType.value == 'diet'
            ? dietTitleController.text
            : workoutTitleController.text,
        type: planType.value,
        userId: userId.value,
        assignedBy: FirebaseAuth.instance.currentUser?.uid,
        details: planType.value == 'diet'
            ? {
                'meals': meals.map((meal) {
                  return {
                    'name': meal['name'],
                    'foods': (meal['foods'] as List).map((food) {
                      return {
                        'name': food['name'],
                        'quantity': food['quantity'],
                        'calories': int.tryParse(food['calories'] ?? '0') ?? 0,
                      };
                    }).toList(),
                  };
                }).toList(),
              }
            : {
                'exercises': exercises.map((exercise) {
                  return {
                    'name': exercise['name'],
                    'reps': int.tryParse(exercise['reps'] ?? '0') ?? 0,
                    'sets': int.tryParse(exercise['sets'] ?? '0') ?? 0,
                    'description': exercise['description'],
                    'instructions': exercise['instructions'],
                    'videoUrl': exercise['videoUrl'],
                  };
                }).toList(),
              },
        createdAt: Timestamp.now(),
      );
      final success = await assignPlan(userId.value, plan);
      if (success) {
        Get.back();
      } else {
        error.value = 'Failed to save plan';
      }
      return success;
    } catch (e) {
      error.value = 'Error saving plan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deletePlan(String planId) async {
    isLoading.value = true;
    try {
      final collection = planType.value == 'diet' ? 'diets' : 'workouts';
      await FirestoreClientService().firestore
          .collection(collection)
          .doc(planId)
          .delete();
      plans.removeWhere((plan) => plan.id == planId);
      return true;
    } catch (e) {
      error.value = 'Error deleting plan: $e';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
