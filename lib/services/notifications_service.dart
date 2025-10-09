import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:storeops_mobile/config/router/router.dart';
import 'package:storeops_mobile/services/shared_preferences_service.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  final payload = response.payload;
  if (payload != null) {

    // debugPrint('Notificación tocada en background: $payload');
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  String? deviceToken;

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  Future<void> init() async {
    await Firebase.initializeApp();

    // ios permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // token device
    deviceToken = await _messaging.getToken();
    final token = await SharedPreferencesService.getSharedPreference(
        SharedPreferencesService.tokenMobile);
    if (token == null && deviceToken != null) {
      await SharedPreferencesService.saveSharedPreference(
          SharedPreferencesService.tokenMobile, deviceToken!);
    }

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        final payload = response.payload;
        if (payload != null) {
          appRouter.push(payload);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // listener foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(
        title: message.notification?.title ?? "New notification",
        body: message.notification?.body ?? "",
        screen: message.data["screen"],
      );
    });

    // listener app open from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // if app close
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  // local notification
  Future<void> _showLocalNotification({
    required String title,
    required String body,
    String? screen,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel',
      'General Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      0,
      title,
      body,
      details,
      payload: screen,
    );
  }

  // navigation
  void _handleMessage(RemoteMessage message) {
    final screen = message.data["screen"];
    if (screen != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        appRouter.go(screen); 
      });
    }
  }

  Future<void> showCustomLocalNotification(
      String title, String body, String screen)
       async {
    await _showLocalNotification(title: title, body: body, screen: screen);
  }
}
