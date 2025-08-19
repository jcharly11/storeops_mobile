import 'package:flutter/material.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';

class CustomButtonSubmit extends StatefulWidget {
  final Future<void> Function() onSubmit; // 🔹 función externa que devuelve Future

  const CustomButtonSubmit({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CustomButtonSubmit> createState() => _CustomButtonSubmitState();
}

class _CustomButtonSubmitState extends State<CustomButtonSubmit> {
  bool _isLoading = false;

  Future<void> _handleSubmit() async {
    setState(() => _isLoading = true);

    try {
      await widget.onSubmit(); // 🔹 Espera a que termine la petición
    } catch (e) {
      debugPrint('Error en submit: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      // style: ButtonStyle(
      //   backgroundColor: WidgetStateProperty.all(AppTheme.secondaryColor),
      //   iconColor: WidgetStateProperty.all(Colors.white),
      // ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        backgroundColor: AppTheme.secondaryColor,
        iconColor: Colors.white
      ),
      onPressed: _isLoading ? null : _handleSubmit,
      
      icon: _isLoading
          ? Container(
              width: 24,
              height: 24,
              padding: EdgeInsets.all(2.0),
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
          : Icon(Icons.arrow_circle_right_outlined, size: 22,),
      label: Text('Sign In',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
