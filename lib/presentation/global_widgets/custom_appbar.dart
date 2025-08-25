import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({super.key});

  

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
          'assets/images/storeops_logo2.png',
          height: 35,
          fit: BoxFit.contain,
        )
      );
    }
}