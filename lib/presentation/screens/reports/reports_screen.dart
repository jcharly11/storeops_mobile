import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  static const name='reports_screen';
  
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  bottomNavigationBar: BottomNavigationBar(
    backgroundColor: Theme.of(context).colorScheme.surface,
    selectedItemColor: Theme.of(context).colorScheme.primary,
    unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ],
  ),
);
  }
}