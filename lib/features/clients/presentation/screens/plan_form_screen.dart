import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/plan_controller.dart';

class PlanFormScreen extends StatelessWidget {
  const PlanFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final tag = 'plan-${args['uid']}-${args['type']}';
    final controller = Get.find<PlanController>(tag: tag);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditMode.value
              ? 'Edit ${controller.planType.value.capitalizeFirst} Plan'
              : 'Add ${controller.planType.value.capitalizeFirst} Plan',
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller.titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller.descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              if (controller.planType.value == 'diet')
                _buildMealSection(controller)
              else
                _buildExerciseSection(controller),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => controller.savePlan(),
                child: Text(
                  controller.isEditMode.value ? 'Update Plan' : 'Save Plan',
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMealSection(PlanController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Meals', style: TextStyle(fontWeight: FontWeight.bold)),
        ...controller.meals.map((meal) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: meal['controllers']['name'],
                    decoration: const InputDecoration(labelText: 'Meal Name'),
                  ),
                  const SizedBox(height: 8),
                  ...List.generate(meal['foods'].length, (i) {
                    final food = meal['foods'][i];
                    return Column(
                      children: [
                        TextField(
                          controller: food['controllers']['name'],
                          decoration: const InputDecoration(
                            labelText: 'Food Name',
                          ),
                        ),
                        TextField(
                          controller: food['controllers']['quantity'],
                          decoration: const InputDecoration(
                            labelText: 'Quantity',
                          ),
                        ),
                        TextField(
                          controller: food['controllers']['calories'],
                          decoration: const InputDecoration(
                            labelText: 'Calories',
                          ),
                        ),
                        TextField(
                          controller: food['controllers']['description'],
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                        ),
                        const Divider(),
                      ],
                    );
                  }),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExerciseSection(PlanController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Exercises', style: TextStyle(fontWeight: FontWeight.bold)),
        ...controller.exercises.map((exercise) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  TextField(
                    controller: exercise['controllers']['name'],
                    decoration: const InputDecoration(
                      labelText: 'Exercise Name',
                    ),
                  ),
                  TextField(
                    controller: exercise['controllers']['reps'],
                    decoration: const InputDecoration(labelText: 'Reps'),
                  ),
                  TextField(
                    controller: exercise['controllers']['sets'],
                    decoration: const InputDecoration(labelText: 'Sets'),
                  ),
                  TextField(
                    controller: exercise['controllers']['description'],
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  TextField(
                    controller: exercise['controllers']['instructions'],
                    decoration: const InputDecoration(
                      labelText: 'Instructions',
                    ),
                  ),
                  TextField(
                    controller: exercise['controllers']['videoUrl'],
                    decoration: const InputDecoration(labelText: 'Video URL'),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
