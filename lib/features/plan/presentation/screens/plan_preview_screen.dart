import 'package:flutter/material.dart';
import '../../data/model/plan_model.dart';
import '../widgets/plan_preview_body.dart';

class PlanPreviewScreen extends StatelessWidget {
  final PlanModel plan;
  const PlanPreviewScreen({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PlanPreviewBody(plan: plan),
    );
  }
}
