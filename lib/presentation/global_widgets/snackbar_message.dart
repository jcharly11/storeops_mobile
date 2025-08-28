import 'package:flutter/material.dart';

void snackbarMessage(BuildContext context, String message, Color color, double paddingVertical) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 15),
        ),
      ),
      
      backgroundColor: color,
      elevation: 10,
      padding: EdgeInsets.symmetric(vertical: paddingVertical, horizontal: 10),
      showCloseIcon: false,
      duration: const Duration(seconds: 2),
    ),
  );


   // ScaffoldMessenger.of(context).showSnackBar(
                                    // SnackBar(content: Center(child: 
                                    //   Text('User or password are wrong', 
                                    //     style: TextStyle(
                                    //       fontSize: 15
                                    //     ),
                                    //   )),
                                    //   backgroundColor: AppTheme.primaryColor,
                                    //   elevation: 10,
                                    //   padding: EdgeInsetsDirectional.symmetric(vertical: 30, horizontal: 10),
                                    //   showCloseIcon: true,
                                    // ));
}