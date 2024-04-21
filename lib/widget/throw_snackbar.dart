import 'package:flutter/material.dart';
import 'package:mobile_challengein/theme.dart';

class ThrowSnackbar {
  showError(BuildContext context, String message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: secondaryColor400,
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
