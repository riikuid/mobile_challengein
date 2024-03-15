import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';
import 'package:mobile_challengein/widget/custom_text_field.dart';

class FlexibleFillingPlanPage extends StatelessWidget {
  final TextEditingController fillingNominalController;
  const FlexibleFillingPlanPage(
      {super.key, required this.fillingNominalController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
