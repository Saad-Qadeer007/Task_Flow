import 'package:flutter/material.dart';

import '../Utilties/App_Colors.dart';

class ErrorSnackbar {
  static showErrorSnackBar(context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          duration: Duration(seconds: 1),
          backgroundColor: AppColors.errorColor,
          content: Text(
            message,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
}
