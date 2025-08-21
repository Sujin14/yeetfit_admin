import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../../clients/data/datasources/firestore_client_service.dart';
import '../../../clients/data/models/client_model.dart';
import '../../data/datasource/firestore_plan_service.dart';
import '../../data/model/plan_model.dart';
import '../../data/repositories/plan_repository_impl.dart';
import '../../domain/usecases/assign_plan.dart';
import '../../domain/usecases/delete_plan.dart';
import '../../domain/usecases/get_client_plans.dart';
import 'base_plan_controller.dart.dart';

class DietPlanController extends BasePlanController {
  final meals = <String, Map<String, dynamic>>{}.obs;
  final totalCaloriesController = TextEditingController();
  final proteinController = TextEditingController();
  final carbsController = TextEditingController();
  final fatsController = TextEditingController();
  final mealCalorieControllers = <String, TextEditingController>{}.obs;
  final userData = Rxn<ClientModel>();
  final FirestoreClientService _clientService = FirestoreClientService();

  DietPlanController()
      : super(
          assignPlan: AssignPlan(PlanRepositoryImpl(service: FirestorePlanService())),
          getClientPlans: GetClientPlans(PlanRepositoryImpl(service: FirestorePlanService())),
          deletePlan: DeletePlan(PlanRepositoryImpl(service: FirestorePlanService())),
          planType: 'diet',
        );

  @override
  void initializeForm() async {
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
      meals.clear();
      totalCaloriesController.clear();
      proteinController.clear();
      carbsController.clear();
      fatsController.clear();
      mealCalorieControllers.clear();
    }

    // Initialize fixed meals
    const fixedMeals = [
      'Breakfast',
      'Morning Snack',
      'Lunch',
      'Evening Snack',
      'Dinner',
    ];
    for (var meal in fixedMeals) {
      meals[meal] = {
        'calories': 0,
        'macronutrients': {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
        'foods': [],
        'controllers': {
          'calories': TextEditingController(),
          'protein': TextEditingController(text: '0.0'),
          'carbs': TextEditingController(text: '0.0'),
          'fats': TextEditingController(text: '0.0'),
        },
      };
      mealCalorieControllers[meal] = TextEditingController();
    }

    if (userId.value.isNotEmpty && !isEditMode.value) {
      final client = await _clientService.getClientDetails(userId.value);
      userData.value = client;
      if (client != null) {
        final suggestedCalories = _calculateSuggestedCalories(client);
        totalCaloriesController.text = suggestedCalories['total'].toString();
        mealCalorieControllers['Breakfast']!.text = suggestedCalories['Breakfast'].toString();
        mealCalorieControllers['Morning Snack']!.text = suggestedCalories['Morning Snack'].toString();
        mealCalorieControllers['Lunch']!.text = suggestedCalories['Lunch'].toString();
        mealCalorieControllers['Evening Snack']!.text = suggestedCalories['Evening Snack'].toString();
        mealCalorieControllers['Dinner']!.text = suggestedCalories['Dinner'].toString();
      }
    }

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
      proteinController.text = plan.totalMacronutrients['protein']?.toString() ?? '0.0';
      carbsController.text = plan.totalMacronutrients['carbs']?.toString() ?? '0.0';
      fatsController.text = plan.totalMacronutrients['fats']?.toString() ?? '0.0';
      final planMeals = plan.details['meals'] as Map<String, dynamic>? ?? {};
      meals.clear();
      planMeals.forEach((mealName, mealData) {
        meals[mealName] = {
          'calories': mealData['calories'] ?? 0,
          'macronutrients': {
            'protein': (mealData['macronutrients']?['protein'] is int ? mealData['macronutrients']['protein'].toDouble() : mealData['macronutrients']?['protein']) ?? 0.0,
            'carbs': (mealData['macronutrients']?['carbs'] is int ? mealData['macronutrients']['carbs'].toDouble() : mealData['macronutrients']?['carbs']) ?? 0.0,
            'fats': (mealData['macronutrients']?['fats'] is int ? mealData['macronutrients']['fats'].toDouble() : mealData['macronutrients']?['fats']) ?? 0.0,
          },
          'foods': (mealData['foods'] as List? ?? []).map((food) {
            return {
              'name': food['name'] ?? '',
              'quantity': food['quantity']?.toString() ?? '',
              'calories': food['calories']?.toString() ?? '',
              'unit': food['unit'] ?? 'g',
              'description': food['description'] ?? '',
              'macronutrients': {
                'protein': (food['macronutrients']?['protein'] is int ? food['macronutrients']['protein'].toDouble() : food['macronutrients']?['protein']) ?? 0.0,
                'carbs': (food['macronutrients']?['carbs'] is int ? food['macronutrients']['carbs'].toDouble() : food['macronutrients']?['carbs']) ?? 0.0,
                'fats': (food['macronutrients']?['fats'] is int ? food['macronutrients']['fats'].toDouble() : food['macronutrients']?['fats']) ?? 0.0,
              },
              'controllers': {
                'name': TextEditingController(text: food['name'] ?? ''),
                'quantity': TextEditingController(text: food['quantity']?.toString() ?? ''),
                'calories': TextEditingController(text: food['calories']?.toString() ?? ''),
                'description': TextEditingController(text: food['description'] ?? ''),
                'protein': TextEditingController(text: food['macronutrients']?['protein']?.toString() ?? '0.0'),
                'carbs': TextEditingController(text: food['macronutrients']?['carbs']?.toString() ?? '0.0'),
                'fats': TextEditingController(text: food['macronutrients']?['fats']?.toString() ?? '0.0'),
              },
            };
          }).toList(),
          'controllers': {
            'calories': TextEditingController(text: mealData['calories']?.toString() ?? '0'),
            'protein': TextEditingController(text: mealData['macronutrients']?['protein']?.toString() ?? '0.0'),
            'carbs': TextEditingController(text: mealData['macronutrients']?['carbs']?.toString() ?? '0.0'),
            'fats': TextEditingController(text: mealData['macronutrients']?['fats']?.toString() ?? '0.0'),
          },
        };
        mealCalorieControllers[mealName] = TextEditingController(text: mealData['calories']?.toString() ?? '0');
      });
    } else if (isEditMode.value) {
      print('Error: Edit mode enabled but no plan or planId provided');
      isEditMode.value = false; // Reset to avoid inconsistent state
      Get.snackbar(
        'Error',
        'Cannot load plan data for editing',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    }

    isLoading.value = false;
    meals.refresh();
    update();
  }

  Map<String, int> _calculateSuggestedCalories(ClientModel client) {
    final weight = client.currentWeight ?? 70.0;
    final height = client.height ?? 170.0;
    final age = client.age ?? 30;
    final activityLevel = client.activityLevel ?? 'Sedentary';
    final gender = client.gender ?? 'male';

    double bmr;
    if (gender.toLowerCase() == 'male') {
      bmr = 10 * weight + 6.25 * height - 5 * age + 5;
    } else {
      bmr = 10 * weight + 6.25 * height - 5 * age - 161;
    }

    final activityFactors = {
      'Sedentary': 1.2,
      'Lightly Active': 1.375,
      'Moderately Active': 1.55,
      'Very Active': 1.725,
    };
    final tdee = bmr * (activityFactors[activityLevel] ?? 1.2);

    double adjustment = 0;
    if (client.timeDurationWeeks != null && client.timeDurationWeeks! > 0 && client.goalWeight != null) {
      final weightChange = client.goalWeight! - weight;
      final totalCalories = weightChange * 7700;
      final weeklyAdjustment = totalCalories / client.timeDurationWeeks!;
      final dailyAdjustment = weeklyAdjustment / 7;
      adjustment = client.goal == 'Weight Loss' ? -dailyAdjustment : dailyAdjustment;
      if (client.goal == 'Muscle Building') {
        adjustment *= 0.5;
      }
    }

    final totalCalories = (tdee + adjustment).round();
    final mealCalories = {
      'Breakfast': (totalCalories * 0.25).round(),
      'Morning Snack': (totalCalories * 0.125).round(),
      'Lunch': (totalCalories * 0.25).round(),
      'Evening Snack': (totalCalories * 0.125).round(),
      'Dinner': (totalCalories * 0.25).round(),
    };

    return {'total': totalCalories, ...mealCalories};
  }

  void addMeal() {
    final customMealIndex = meals.keys
            .where((name) => !['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner'].contains(name))
            .length +
        1;
    final mealName = 'Custom Meal $customMealIndex';
    meals[mealName] = {
      'calories': 0,
      'macronutrients': {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
      'foods': [
        {
          'name': '',
          'quantity': '',
          'calories': '',
          'unit': 'g',
          'description': '',
          'macronutrients': {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
          'controllers': {
            'name': TextEditingController(),
            'quantity': TextEditingController(),
            'calories': TextEditingController(),
            'description': TextEditingController(),
            'protein': TextEditingController(text: '0.0'),
            'carbs': TextEditingController(text: '0.0'),
            'fats': TextEditingController(text: '0.0'),
          },
        },
      ],
      'controllers': {
        'calories': TextEditingController(),
        'protein': TextEditingController(text: '0.0'),
        'carbs': TextEditingController(text: '0.0'),
        'fats': TextEditingController(text: '0.0'),
      },
    };
    mealCalorieControllers[mealName] = TextEditingController();
    if (userData.value != null) {
      final total = int.tryParse(totalCaloriesController.text) ?? 0;
      final customCount = meals.keys
          .where((name) => !['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner'].contains(name))
          .length;
      if (customCount > 0 && total > 0) {
        mealCalorieControllers[mealName]!.text = (total * 0.125 / customCount).round().toString();
      }
    }
    meals.refresh();
    update();
  }

  void addFood(String mealName) {
    meals[mealName]!['foods'].add({
      'name': '',
      'quantity': '',
      'calories': '',
      'unit': 'g',
      'description': '',
      'macronutrients': {'protein': 0.0, 'carbs': 0.0, 'fats': 0.0},
      'controllers': {
        'name': TextEditingController(),
        'quantity': TextEditingController(),
        'calories': TextEditingController(),
        'description': TextEditingController(),
        'protein': TextEditingController(text: '0.0'),
        'carbs': TextEditingController(text: '0.0'),
        'fats': TextEditingController(text: '0.0'),
      },
    });
    meals.refresh();
    update();
  }

  Future<bool> removeMeal(String mealName) async {
    if (['Breakfast', 'Morning Snack', 'Lunch', 'Evening Snack', 'Dinner'].contains(mealName)) {
      Get.snackbar(
        'Error',
        'Cannot remove fixed meal types',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    }
    final confirmed = await showConfirmationDialog('meal');
    if (!confirmed) return false;
    final controllers = meals[mealName]!['controllers'] as Map<String, TextEditingController>;
    for (var c in controllers.values) {
      c.dispose();
    }
    for (final food in meals[mealName]!['foods']) {
      final fc = food['controllers'] as Map<String, TextEditingController>;
      for (var c in fc.values) {
        c.dispose();
      }
    }
    mealCalorieControllers[mealName]?.dispose();
    meals.remove(mealName);
    mealCalorieControllers.remove(mealName);
    meals.refresh();
    update();
    return true;
  }

  Future<bool> removeFood(String mealName, int foodIndex) async {
    final confirmed = await showConfirmationDialog('food');
    if (!confirmed) return false;
    final fc = meals[mealName]!['foods'][foodIndex]['controllers'] as Map<String, TextEditingController>;
    for (var c in fc.values) {
      c.dispose();
    }
    meals[mealName]!['foods'].removeAt(foodIndex);
    meals.refresh();
    update();
    return true;
  }

  void updateUnit(String mealName, int foodIndex, String unit) {
    meals[mealName]!['foods'][foodIndex]['unit'] = unit;
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
      error.value = 'Please fill all required fields';
      Get.snackbar('Error', error.value,
          backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      return false;
    }

    final plan = PlanModel(
      id: isEditMode.value && planId.value.isNotEmpty ? planId.value : null, // Retain planId for updates
      title: titleController.text.trim().isEmpty ? 'Unnamed Plan' : titleController.text.trim(),
      type: planType,
      userId: userId.value,
      assignedBy: FirebaseAuth.instance.currentUser?.uid ?? '',
      details: {
        'description': descriptionController.text.trim(),
        'meals': meals.map((mealName, meal) => MapEntry(mealName, {
              'calories': int.tryParse(mealCalorieControllers[mealName]?.text ?? '0') ?? 0,
              'macronutrients': {
                'protein': double.tryParse(meal['controllers']['protein'].text.trim()) ?? 0.0,
                'carbs': double.tryParse(meal['controllers']['carbs'].text.trim()) ?? 0.0,
                'fats': double.tryParse(meal['controllers']['fats'].text.trim()) ?? 0.0,
              },
              'foods': (meal['foods'] as List).map((food) {
                return {
                  'name': food['controllers']['name'].text.trim(),
                  'quantity': food['controllers']['quantity'].text.trim(),
                  'unit': food['unit'] ?? 'g',
                  'calories': int.tryParse(food['controllers']['calories'].text.trim()) ?? 0,
                  'description': food['controllers']['description'].text.trim(),
                  'macronutrients': {
                    'protein': double.tryParse(food['controllers']['protein'].text.trim()) ?? 0.0,
                    'carbs': double.tryParse(food['controllers']['carbs'].text.trim()) ?? 0.0,
                    'fats': double.tryParse(food['controllers']['fats'].text.trim()) ?? 0.0,
                  },
                };
              }).toList(),
            })),
      },
      totalCalories: int.tryParse(totalCaloriesController.text.trim()) ?? 0,
      totalMacronutrients: {
        'protein': double.tryParse(proteinController.text.trim()) ?? 0.0,
        'carbs': double.tryParse(carbsController.text.trim()) ?? 0.0,
        'fats': double.tryParse(fatsController.text.trim()) ?? 0.0,
      },
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
    for (final meal in meals.values) {
      for (var c in (meal['controllers'] as Map<String, TextEditingController>).values) {
        c.dispose();
      }
      for (final food in meal['foods']) {
        for (var c in (food['controllers'] as Map<String, TextEditingController>).values) {
          c.dispose();
        }
      }
    }
    for (var c in mealCalorieControllers.values) {
      c.dispose();
    }
    totalCaloriesController.dispose();
    proteinController.dispose();
    carbsController.dispose();
    fatsController.dispose();
    super.onClose();
  }
}