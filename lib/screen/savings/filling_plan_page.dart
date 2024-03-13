import 'package:flutter/material.dart';

class FillingPlanPage extends StatefulWidget {
  final int targetAmount;
  final DateTime? estimatedTarget;
  final String? fillingFreequency;
  final int? fillingPlan;
  final int? fillingNominal;
  const FillingPlanPage({
    super.key,
    required this.targetAmount,
    this.estimatedTarget,
    this.fillingFreequency,
    this.fillingPlan,
    this.fillingNominal,
  });

  @override
  State<FillingPlanPage> createState() => _FillingPlanPageState();
}

class _FillingPlanPageState extends State<FillingPlanPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
