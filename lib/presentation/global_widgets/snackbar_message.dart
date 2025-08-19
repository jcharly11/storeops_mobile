import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

void snackbarMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 15),
        ),
      ),
      
      backgroundColor: AppTheme.secondaryColor,
      elevation: 10,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      showCloseIcon: false,
      duration: const Duration(seconds: 2),
    ),
  );
}