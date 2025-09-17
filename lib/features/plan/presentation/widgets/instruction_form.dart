import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/workout_plan_controller.dart';

class InstructionForm extends StatelessWidget {
  final int exerciseIndex;
  final Map<String, dynamic> instruction;
  final int instructionIndex;
  final String controllerTag;

  const InstructionForm({
    super.key,
    required this.exerciseIndex,
    required this.instruction,
    required this.instructionIndex,
    required this.controllerTag,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WorkoutPlanController>(tag: controllerTag);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Expanded(
            child: CustomTextField(
              controller: instruction['controller'],
              labelText: 'Instruction ${instructionIndex + 1}',
              validator: FormValidators.validateInstruction,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.list,
                    color: AdminTheme.colors['textSecondary']),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
            onPressed: () =>
                controller.removeInstruction(exerciseIndex, instructionIndex),
          ),
        ],
      ),
    );
  }
}
