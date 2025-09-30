import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storeops_mobile/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login flow', (tester) async {
    print('🧹 Limpiando sesión...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    print('🚀 Lanzando app...');
    try {
      app.main();
    } catch (e, stack) {
      print('❌ Error al lanzar la app: $e');
      print(stack);
      fail('La app no se pudo iniciar.');
    }

    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));

    print('🔍 Buscando campos de login...');
    final userField = find.byKey(Key('user_id_field'));
    final passField = find.byKey(Key('password_field'));
    final signInBtn = find.byKey(Key('sign_in_button'));

    if (userField.evaluate().isEmpty ||
        passField.evaluate().isEmpty ||
        signInBtn.evaluate().isEmpty) {
      print('❌ No se encontraron los campos de login. Test abortado.');
      fail('Los widgets de login no están disponibles.');
    }

    print('✍️ Ingresando credenciales...');
    await tester.enterText(userField, 'MULTI_USERID05749');
    await tester.enterText(passField, 'Ju4n950528Storeops.');
    await tester.tap(signInBtn);

    print('⏳ Esperando 20 segundos para carga post-login...');
    await tester.pump(const Duration(seconds: 20));

    print('🔍 Verificando pantalla principal...');
    
  }
  );
}
