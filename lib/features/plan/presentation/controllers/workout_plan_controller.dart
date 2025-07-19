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


class WorkoutPlanController extends BasePlanController {
  final exercises = <Map<String, dynamic>>[].obs;

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

    titleController.clear();
    descriptionController.clear();
    exercises.clear();

    if (isEditMode.value && args?['plan'] != null) {
      final PlanModel plan = args['plan'];
      titleController.text = plan.title;
      descriptionController.text = plan.details['description']?.toString() ?? '';
      exercises.assignAll(
        (plan.details['exercises'] as List).map((exercise) {
          final instructions = (exercise['instructions'] as List? ?? []).map((instr) {
            return {
              'text': instr['text'] ?? '',
              'controller': TextEditingController(text: instr['text'] ?? ''),
            };
          }).toList();
          return {
            'name': exercise['name'] ?? '',
            'repsType': exercise['repsType'] ?? 'reps',
            'reps': exercise['reps'].toString(),
            'sets': exercise['sets'].toString(),
            'description': exercise['description'] ?? '',
            'instructions': instructions,
            'videoUrl': exercise['videoUrl'] ?? '',
            'controllers': {
              'name': TextEditingController(text: exercise['name'] ?? ''),
              'reps': TextEditingController(text: exercise['reps'].toString()),
              'sets': TextEditingController(text: exercise['sets'].toString()),
              'description': TextEditingController(text: exercise['description'] ?? ''),
              'videoUrl': TextEditingController(text: exercise['videoUrl'] ?? ''),
            },
          };
        }).toList(),
      );
    } else {
      addExercise();
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
    exercises.refresh();
    update();
  }

  void addInstruction(int exerciseIndex) {
    exercises[exerciseIndex]['instructions'].add({
      'text': '',
      'controller': TextEditingController(),
    });
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
    for (var instr in exercises[index]['instructions']) {
      instr['controller'].dispose();
    }
    exercises.removeAt(index);
    exercises.refresh();
    update();
    return true;
  }

  Future<bool> removeInstruction(int exerciseIndex, int instructionIndex) async {
    final confirmed = await showConfirmationDialog('instruction');
    if (!confirmed) return false;
    exercises[exerciseIndex]['instructions'][instructionIndex]['controller'].dispose();
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
        'exercises': exercises.map((exercise) {
          return {
            'name': exercise['controllers']['name'].text.trim(),
            'repsType': exercise['repsType'],
            'reps': exercise['controllers']['reps'].text.trim(),
            'sets': exercise['controllers']['sets'].text.trim(),
            'description': exercise['controllers']['description'].text.trim(),
            'instructions': (exercise['instructions'] as List).map((instr) {
              return {'text': instr['controller'].text.trim()};
            }).toList(),
            'videoUrl': exercise['controllers']['videoUrl'].text.trim(),
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
    for (final ex in exercises) {
      for (var c in (ex['controllers'] as Map<String, TextEditingController>).values) {
        c.dispose();
      }
      for (var c in (ex['instructions'] as List<Map<String, dynamic>>).map((i) => i['controller']).cast<TextEditingController>()) {
        c.dispose();
      }
    }
    super.onClose();
  }
}