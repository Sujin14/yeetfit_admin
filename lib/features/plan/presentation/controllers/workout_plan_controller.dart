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
import '../../domain/usecases/delete_plan.dart';
import '../../domain/usecases/get_client_plans.dart';
import 'base_plan_controller.dart.dart';
import 'preview_controller.dart';

class WorkoutPlanController extends BasePlanController {
  final exercises = <Map<String, dynamic>>[].obs;
  final totalCaloriesController = TextEditingController();

  WorkoutPlanController()
      : super(
          assignPlan: AssignPlan(PlanRepositoryImpl(service: FirestorePlanService())),
          getClientPlans: GetClientPlans(PlanRepositoryImpl(service: FirestorePlanService())),
          deletePlan: DeletePlan(PlanRepositoryImpl(service: FirestorePlanService())),
          planType: 'workout',
        );

  @override
  void initializeForm() {
    isLoading.value = true;
    final args = Get.arguments;
    userId.value = args?['uid'] ?? '';
    isEditMode.value = args?['mode'] == 'edit';
    planId.value = args?['planId'] ?? '';

    print('Initializing form: userId=${userId.value}, isEditMode=${isEditMode.value}, planId=${planId.value}'); // Debug log

    // Clear form fields only if not in edit mode
    if (!isEditMode.value) {
      titleController.clear();
      descriptionController.clear();
      exercises.clear();
      totalCaloriesController.clear();
    }

    final previewController = Get.put(PreviewController('$userId-$planType'), tag: 'preview-plan-$userId-$planType');

    if (isEditMode.value && args?['plan'] != null && planId.value.isNotEmpty) {
      final PlanModel plan = args['plan'];
      if (plan.id != planId.value) {
        print('Warning: planId (${planId.value}) does not match plan.id (${plan.id})');
        planId.value = plan.id ?? planId.value; // Prefer plan.id
      }
      print('Loading plan data: ${plan.title}, ID: ${plan.id}'); // Debug log
      titleController.text = plan.title;
      descriptionController.text = plan.details['description']?.toString() ?? '';
      totalCaloriesController.text = plan.totalCalories.toString();
      exercises.assignAll(
        (plan.details['exercises'] as List? ?? []).map((exercise) {
          final instructions = (exercise['instructions'] as List? ?? []).map((instr) {
            return {
              'text': instr['text'] ?? '',
              'controller': TextEditingController(text: instr['text'] ?? ''),
            };
          }).toList();
          return {
            'name': exercise['name'] ?? '',
            'repsType': exercise['repsType'] ?? 'reps',
            'reps': exercise['reps']?.toString() ?? '',
            'sets': exercise['sets']?.toString() ?? '',
            'description': exercise['description'] ?? '',
            'instructions': instructions,
            'videoUrl': exercise['videoUrl'] ?? '',
            'controllers': {
              'name': TextEditingController(text: exercise['name'] ?? ''),
              'reps': TextEditingController(text: exercise['reps']?.toString() ?? ''),
              'sets': TextEditingController(text: exercise['sets']?.toString() ?? ''),
              'description': TextEditingController(text: exercise['description'] ?? ''),
              'videoUrl': TextEditingController(text: exercise['videoUrl'] ?? ''),
            },
          };
        }).toList(),
      );
      previewController.initialize(exercises.length);
    } else if (isEditMode.value) {
      print('Error: Edit mode enabled but no plan or planId provided');
      isEditMode.value = false; // Reset to avoid inconsistent state
      Get.snackbar(
        'Error',
        'Cannot load plan data for editing',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    } else {
      addExercise();
      previewController.initialize(exercises.length);
    }
    isLoading.value = false;
  }

  void addExercise() {
    exercises.add({
      'name': '',
      'repsType': 'reps',
      'reps': '',
      'sets': '',
      'description': '',
      'instructions': [
        {'text': '', 'controller': TextEditingController()},
      ],
      'videoUrl': '',
      'controllers': {
        'name': TextEditingController(),
        'reps': TextEditingController(),
        'sets': TextEditingController(),
        'description': TextEditingController(),
        'videoUrl': TextEditingController(),
      },
    });
    final previewController = Get.find<PreviewController>(tag: 'preview-plan-$userId-$planType');
    previewController.initialize(exercises.length);
    exercises.refresh();
    update();
  }

  Future<bool> removeExercise(int index) async {
    final confirmed = await showConfirmationDialog('exercise');
    if (!confirmed) return false;
    final controllers = exercises[index]['controllers'] as Map<String, TextEditingController>;
    for (var c in controllers.values) {
      c.dispose();
    }
    for (final instr in exercises[index]['instructions']) {
      (instr['controller'] as TextEditingController).dispose();
    }
    exercises.removeAt(index);
    final previewController = Get.find<PreviewController>(tag: 'preview-plan-$userId-$planType');
    previewController.initialize(exercises.length);
    exercises.refresh();
    update();
    return true;
  }

  void addInstruction(int exerciseIndex) {
    exercises[exerciseIndex]['instructions'].add({
      'text': '',
      'controller': TextEditingController(),
    });
    exercises.refresh();
    update();
  }

  Future<bool> removeInstruction(int exerciseIndex, int instructionIndex) async {
    final confirmed = await showConfirmationDialog('instruction');
    if (!confirmed) return false;
    (exercises[exerciseIndex]['instructions'][instructionIndex]['controller'] as TextEditingController).dispose();
    exercises[exerciseIndex]['instructions'].removeAt(instructionIndex);
    exercises.refresh();
    update();
    return true;
  }

  void updateRepsType(int index, String repsType) {
    exercises[index]['repsType'] = repsType;
    exercises[index]['controllers']['reps'].clear();
    exercises.refresh();
    update();
  }

  void updateSets(int index, String sets) {
    exercises[index]['controllers']['sets'].text = sets;
    exercises[index]['sets'] = sets;
    exercises.refresh();
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
      error.value = 'Please fill all required fields';
      Get.snackbar('Error', error.value,
          backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      return false;
    }

    final plan = PlanModel(
      id: isEditMode.value && planId.value.isNotEmpty ? planId.value : null, // Retain planId for updates
      title: titleController.text.trim().isEmpty ? 'Unnamed Workout Plan' : titleController.text.trim(),
      type: planType,
      userId: userId.value,
      assignedBy: FirebaseAuth.instance.currentUser?.uid ?? '',
      details: {
        'description': descriptionController.text.trim(),
        'exercises': exercises.map((exercise) {
          return {
            'name': exercise['controllers']['name'].text.trim(),
            'repsType': exercise['repsType'],
            'reps': int.tryParse(exercise['controllers']['reps'].text.trim()) ?? 0,
            'sets': int.tryParse(exercise['controllers']['sets'].text.trim()) ?? 0,
            'description': exercise['controllers']['description'].text.trim(),
            'instructions': (exercise['instructions'] as List).map((instr) {
              return {'text': (instr['controller'] as TextEditingController).text.trim()};
            }).toList(),
            'videoUrl': exercise['controllers']['videoUrl'].text.trim(),
          };
        }).toList(),
      },
      totalCalories: int.tryParse(totalCaloriesController.text.trim()) ?? 0,
      totalMacronutrients: {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
      isFavorite: isEditMode.value ? plans.firstWhere((p) => p.id == planId.value, orElse: () => PlanModel(id: null, title: '', type: planType, userId: userId.value, details: {}, isFavorite: false, createdAt: Timestamp.now(), totalCalories: 0)).isFavorite : false,
      createdAt: Timestamp.now(),
    );

    isLoading.value = true;
    error.value = '';
    try {
      print('Saving plan: isEditMode=${isEditMode.value}, planId=${plan.id}'); // Debug log
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
    for (final exercise in exercises) {
      for (var c in (exercise['controllers'] as Map<String, TextEditingController>).values) {
        c.dispose();
      }
      for (final instr in exercise['instructions']) {
        (instr['controller'] as TextEditingController).dispose();
      }
    }
    totalCaloriesController.dispose();
    super.onClose();
  }
}