import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  // final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  String? deviceToken;

  Future<void> init() async {
    await Firebase.initializeApp();

    //permissions
    await _messaging.requestPermission();

    //  //local notifications (app opened)
    // const AndroidInitializationSettings androidSettings =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');

    // const InitializationSettings initSettings =
    //     InitializationSettings(android: androidSettings);

    // await _localNotifications.initialize(initSettings);
        
    deviceToken = await _messaging.getToken();
    final token= await SharedPreferencesService.getSharedPreference(SharedPreferencesService.tokenMobile);
    if(token==null){
      print("Token FCM: $deviceToken");
      await SharedPreferencesService.saveSharedPreference(SharedPreferencesService.tokenMobile, deviceToken!);
    }
    

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground: ${message.notification?.title}");

      // _showLocalNotification(
      //   message.notification?.title ?? "Sin título",
      //   message.notification?.body ?? "Sin contenido",
      // );
    });

    

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print("OpenedApp: ${message.notification?.title}");
    });

    
  }

  // Future<void> _showLocalNotification(String title, String body) async {
  //   const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
  //     'default_channel',
  //     'Notificaciones',
  //     channelDescription: 'Canal para notificaciones en foreground',
  //     importance: Importance.max,
  //     priority: Priority.high,
  //   );

  //   const NotificationDetails notificationDetails =
  //       NotificationDetails(android: androidDetails);

  //   await _localNotifications.show(
  //     0, // ID
  //     title,
  //     body,
  //     notificationDetails,
  //   );
  // }
}
