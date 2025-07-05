// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../../../core/widgets/custom_button.dart';
// import '../controllers/plan_controller.dart';
// import '../../../../core/theme/theme.dart';
// import '../../../../core/widgets/custom_text_field.dart';
// import '../../../../core/utils/form_validators.dart';

// class PlanFormFields extends StatelessWidget {
//   final PlanController controller;
//   final String uid;
//   final String mode;
//   final String type;

//   const PlanFormFields({
//     super.key,
//     required this.controller,
//     required this.uid,
//     required this.mode,
//     required this.type,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: controller.formKey,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CustomTextField(
//             controller: controller.titleController,
//             labelText: '${type.capitalizeFirstLetter} Plan Title',
//             validator: FormValidators.validatePlanDetails,
//           ),
//           SizedBox(height: 16.h),
//           Text(
//             type == 'diet' ? 'Meals' : 'Exercises',
//             style: AdminTheme.textStyles['title']!.copyWith(
//               color: AdminTheme.colors['textPrimary'],
//             ),
//           ),
//           SizedBox(height: 8.h),
//           if (type == 'diet')
//             ...controller.meals.asMap().entries.map((entry) {
//               final index = entry.key;
//               final meal = entry.value;
//               final mealNameController = TextEditingController(
//                 text: meal['name'],
//               );
//               mealNameController.addListener(() {
//                 meal['name'] = mealNameController.text;
//                 controller.meals.refresh();
//               });
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CustomTextField(
//                     controller: mealNameController,
//                     labelText: 'Meal Name (e.g., Breakfast)',
//                     validator: FormValidators.validatePlanDetails,
//                   ),
//                   SizedBox(height: 8.h),
//                   Text(
//                     'Foods',
//                     style: AdminTheme.textStyles['body']!.copyWith(
//                       color: AdminTheme.colors['textPrimary'],
//                     ),
//                   ),
//                   ...(meal['foods'] as List).asMap().entries.map((foodEntry) {
//                     final foodIndex = foodEntry.key;
//                     final food = foodEntry.value;
//                     final foodNameController = TextEditingController(
//                       text: food['name'],
//                     );
//                     final quantityController = TextEditingController(
//                       text: food['quantity'],
//                     );
//                     final caloriesController = TextEditingController(
//                       text: food['calories'],
//                     );
//                     foodNameController.addListener(() {
//                       food['name'] = foodNameController.text;
//                       controller.meals.refresh();
//                     });
//                     quantityController.addListener(() {
//                       food['quantity'] = quantityController.text;
//                       controller.meals.refresh();
//                     });
//                     caloriesController.addListener(() {
//                       food['calories'] = caloriesController.text;
//                       controller.meals.refresh();
//                     });
//                     return Column(
//                       children: [
//                         SizedBox(height: 8.h),
//                         CustomTextField(
//                           controller: foodNameController,
//                           labelText: 'Food Name (e.g., Dosa)',
//                           validator: FormValidators.validatePlanDetails,
//                         ),
//                         SizedBox(height: 8.h),
//                         CustomTextField(
//                           controller: quantityController,
//                           labelText: 'Quantity (e.g., 100g)',
//                           validator: FormValidators.validatePlanDetails,
//                         ),
//                         SizedBox(height: 8.h),
//                         CustomTextField(
//                           controller: caloriesController,
//                           labelText: 'Calories',
//                           keyboardType: TextInputType.number,
//                           validator: (value) =>
//                               FormValidators.validateNumber(value, 'Calories'),
//                         ),
//                         SizedBox(height: 8.h),
//                         IconButton(
//                           icon: Icon(
//                             Icons.delete,
//                             color: AdminTheme.colors['error'],
//                           ),
//                           onPressed: () =>
//                               controller.removeFood(index, foodIndex),
//                         ),
//                       ],
//                     );
//                   }),
//                   SizedBox(height: 8.h),
//                   TextButton(
//                     onPressed: () => controller.addFood(index),
//                     child: Text(
//                       'Add Food',
//                       style: AdminTheme.textStyles['body']!.copyWith(
//                         color: AdminTheme.colors['primary'],
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
//                     onPressed: () => controller.removeMeal(index),
//                   ),
//                 ],
//               );
//             })
//           else
//             ...controller.exercises.asMap().entries.map((entry) {
//               final index = entry.key;
//               final exercise = entry.value;
//               final nameController = TextEditingController(
//                 text: exercise['name'],
//               );
//               final repsController = TextEditingController(
//                 text: exercise['reps'],
//               );
//               final setsController = TextEditingController(
//                 text: exercise['sets'],
//               );
//               final descriptionController = TextEditingController(
//                 text: exercise['description'],
//               );
//               final instructionsController = TextEditingController(
//                 text: exercise['instructions'],
//               );
//               final videoUrlController = TextEditingController(
//                 text: exercise['videoUrl'],
//               );
//               nameController.addListener(() {
//                 exercise['name'] = nameController.text;
//                 controller.exercises.refresh();
//               });
//               repsController.addListener(() {
//                 exercise['reps'] = repsController.text;
//                 controller.exercises.refresh();
//               });
//               setsController.addListener(() {
//                 exercise['sets'] = setsController.text;
//                 controller.exercises.refresh();
//               });
//               descriptionController.addListener(() {
//                 exercise['description'] = descriptionController.text;
//                 controller.exercises.refresh();
//               });
//               instructionsController.addListener(() {
//                 exercise['instructions'] = instructionsController.text;
//                 controller.exercises.refresh();
//               });
//               videoUrlController.addListener(() {
//                 exercise['videoUrl'] = videoUrlController.text;
//                 controller.exercises.refresh();
//               });
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 8.h),
//                   CustomTextField(
//                     controller: nameController,
//                     labelText: 'Exercise Name',
//                     validator: FormValidators.validatePlanDetails,
//                   ),
//                   SizedBox(height: 8.h),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: CustomTextField(
//                           controller: repsController,
//                           labelText: 'Reps',
//                           keyboardType: TextInputType.number,
//                           validator: (value) =>
//                               FormValidators.validateNumber(value, 'Reps'),
//                         ),
//                       ),
//                       SizedBox(width: 8.w),
//                       Expanded(
//                         child: CustomTextField(
//                           controller: setsController,
//                           labelText: 'Sets',
//                           keyboardType: TextInputType.number,
//                           validator: (value) =>
//                               FormValidators.validateNumber(value, 'Sets'),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8.h),
//                   CustomTextField(
//                     controller: descriptionController,
//                     labelText: 'Description',
//                     maxLines: 3,
//                   ),
//                   SizedBox(height: 8.h),
//                   CustomTextField(
//                     controller: instructionsController,
//                     labelText: 'Instructions',
//                     maxLines: 3,
//                   ),
//                   SizedBox(height: 8.h),
//                   CustomTextField(
//                     controller: videoUrlController,
//                     labelText: 'YouTube Video URL (Optional)',
//                     validator: (value) {
//                       if (value == null || value.isEmpty) return null;
//                       if (!RegExp(
//                         r'^https?://(www\.)?(youtube\.com|youtu\.be)/.+$',
//                       ).hasMatch(value)) {
//                         return 'Enter a valid YouTube URL';
//                       }
//                       return null;
//                     },
//                   ),
//                   SizedBox(height: 8.h),
//                   IconButton(
//                     icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
//                     onPressed: () => controller.removeExercise(index),
//                   ),
//                 ],
//               );
//             }),
//           SizedBox(height: 8.h),
//           TextButton(
//             onPressed: type == 'diet'
//                 ? controller.addMeal
//                 : controller.addExercise,
//             child: Text(
//               type == 'diet' ? 'Add More Meal' : 'Add More Exercise',
//               style: AdminTheme.textStyles['body']!.copyWith(
//                 color: AdminTheme.colors['primary'],
//               ),
//             ),
//           ),
//           SizedBox(height: 16.h),
//           CustomButton(
//             text: mode == 'add'
//                 ? 'Save ${type.capitalizeFirstLetter} Plan'
//                 : 'Update ${type.capitalizeFirstLetter} Plan',
//             isLoading: controller.isLoading.value,
//             onPressed: controller.savePlan,
//           ),
//         ],
//       ),
//     );
//   }
// }

// extension StringExtension on String {
//   String get capitalizeFirstLetter {
//     if (isEmpty) return this;
//     return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
//   }
// }
