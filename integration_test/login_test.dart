import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storeops_mobile/main.dart' as app;
import 'package:storeops_mobile/presentation/screens/home/home_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login flow y apertura de drawer', (tester) async {
    print('🧹 Limpiando sesión...');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    print('🚀 Lanzando app...');
    try {
      // Lanza la app normalmente
      app.main();
    } catch (e, stack) {
      print('❌ Error al lanzar la app: $e');
      print(stack);
      fail('La app no se pudo iniciar.');
    }

    // Espera inicial a que se construya la UI
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 5));

    print('🔍 Buscando campos de login...');
    final userField = find.byKey(const Key('user_id_field'));
    final passField = find.byKey(const Key('password_field'));
    final signInBtn = find.byKey(const Key('sign_in_button'));

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

    // Espera a que se ejecute el login y se navegue
    await tester.pumpAndSettle(const Duration(seconds: 5));

    print('✅ Login ejecutado. Esperando la pantalla principal...');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    print('🔍 Verificando que la pantalla de Home esté visible...');
    final homeKeyFinder = find.byKey(const Key('home_screen'));
    bool found = false;

    await tester.pump(const Duration(milliseconds: 500));
    if (homeKeyFinder.evaluate().isNotEmpty) {
      found = true;
    }

    if (found) {
      print('🎉 Navegación a Home confirmada por Key.');
      expect(homeKeyFinder, findsOneWidget);

      HomeScreen.scaffoldKey.currentState?.openDrawer();
      await tester.pumpAndSettle(const Duration(seconds: 1));
      print('📂 Drawer abierto automáticamente.');
    } else {
      print(
          '❌ No se encontró el widget con Key home_screen después de esperar.');
      fail('La aplicación no navegó correctamente a la pantalla de Home.');
    }
  });
}
