import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/config/theme/app_theme.dart';
import 'package:storeops_mobile/core/dio_client.dart';
import 'package:storeops_mobile/data/repositories/auth_repository_impl.dart';
import 'package:storeops_mobile/data/repositories/customers_repository_impl.dart';
import 'package:storeops_mobile/data/repositories/stores_repository_impl.dart';
import 'package:storeops_mobile/data/sources/auth_datasource.dart';
import 'package:storeops_mobile/data/sources/customers_datasource.dart';
import 'package:storeops_mobile/data/sources/stores_datasouce.dart';
import 'package:storeops_mobile/domain/repositories/auth_repository.dart';
import 'package:storeops_mobile/domain/repositories/customers_repository.dart';
import 'package:storeops_mobile/domain/repositories/stores_repository.dart';
import 'package:storeops_mobile/firebase_options.dart';
import 'package:storeops_mobile/l10n/app_localizations.dart';
import 'package:storeops_mobile/services/notifications_service.dart';



final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final dioClient = DioClient();

  final loginDS = AuthRemoteDataSource(dioClient);
  final customersDS = CustomersDatasource(dioClient: dioClient);
  final storeDS = StoresDatasource(dioClient: dioClient);
  
  final loginRepo = AuthRepositoryImpl(loginDS);
  final customerRepo = CustomerRepositoryImpl(customersDS);
  final storesRepo = StoresRepositoryImpl(storeDS);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAuth.instance.signInAnonymously();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  await NotificationService().init();
  

  runApp(
    MultiProvider(
      providers: [
        Provider<CustomerRepository>(create: (_) => customerRepo),
        Provider<AuthRepository>(create: (_) => loginRepo),
        Provider<StoresRepository>(create: (_) => storesRepo),
      ],
      child: const MainApp()
    )
  );
}

class MainApp extends StatelessWidget {
  
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme().getTheme(),

      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('es'),
        Locale('it'),
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (locale.languageCode == deviceLocale?.languageCode) {
            return locale;
          }
        }
        return Locale('en');
      },
    );
  }
}
