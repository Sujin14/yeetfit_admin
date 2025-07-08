import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../presentation/controllers/plan_controller.dart';

class WorkoutFormFields extends StatelessWidget {
  final String controllerTag;
  const WorkoutFormFields({super.key, required this.controllerTag});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlanController>(
      tag: controllerTag,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.titleController,
              decoration: const InputDecoration(labelText: 'Plan Title'),
              validator: (val) =>
                  val == null || val.trim().isEmpty ? 'Enter a title' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: controller.descriptionController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Plan Description'),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.exercises.length,
              itemBuilder: (context, index) {
                final exercise = controller.exercises[index];
                final exCtrl =
                    exercise['controllers']
                        as Map<String, TextEditingController>;

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Exercise ${index + 1}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: exCtrl['name'],
                          decoration: const InputDecoration(
                            labelText: 'Exercise Name',
                          ),
                          onChanged: (v) => exercise['name'] = v,
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: exercise['repsType'],
                          items: const [
                            DropdownMenuItem(
                              value: 'reps',
                              child: Text('Reps'),
                            ),
                            DropdownMenuItem(
                              value: 'duration',
                              child: Text('Duration (min)'),
                            ),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateRepsType(index, value);
                            }
                          },
                          decoration: const InputDecoration(
                            labelText: 'Reps Type',
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (exercise['repsType'] == 'reps')
                          TextFormField(
                            controller: exCtrl['reps'],
                            decoration: const InputDecoration(
                              labelText: 'Reps',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => exercise['reps'] = v,
                          )
                        else
                          TextFormField(
                            controller: exCtrl['reps'],
                            decoration: const InputDecoration(
                              labelText: 'Duration (in minutes)',
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => exercise['reps'] = v,
                          ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: exCtrl['sets'],
                          decoration: const InputDecoration(labelText: 'Sets'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => exercise['sets'] = v,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: exCtrl['description'],
                          decoration: const InputDecoration(
                            labelText: 'Description',
                          ),
                          onChanged: (v) => exercise['description'] = v,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: exCtrl['instructions'],
                          decoration: const InputDecoration(
                            labelText: 'Instructions',
                          ),
                          onChanged: (v) => exercise['instructions'] = v,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: exCtrl['videoUrl'],
                          decoration: const InputDecoration(
                            labelText: 'Video URL',
                          ),
                          onChanged: (v) => exercise['videoUrl'] = v,
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton.icon(
                            onPressed: () => controller.removeExercise(index),
                            icon: const Icon(Icons.delete, color: Colors.red),
                            label: const Text(
                              'Remove',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton.icon(
                onPressed: controller.addExercise,
                icon: const Icon(Icons.add),
                label: const Text('Add Exercise'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminTheme.colors['primary'],
                  foregroundColor: AdminTheme.colors['onPrimary'],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
