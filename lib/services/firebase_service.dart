import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin
localNotifications =
FlutterLocalNotificationsPlugin();

/// ================= BACKGROUND HANDLER =================
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
    ) async {

  await Firebase.initializeApp();

  print("BACKGROUND MESSAGE:");
  print(message.notification?.title);
}

/// ======================================================
/// FIREBASE SERVICE
/// ======================================================

class FirebaseService {

  // ================= CHANNEL =================

  static const AndroidNotificationChannel
  channel =
  AndroidNotificationChannel(

    'edeslay_channel',

    'Edeslay Notification',

    description:
    'Channel untuk notifikasi aplikasi desa',

    importance:
    Importance.max,
  );

  // ================= GET TOKEN =================

  static Future<String?> getToken() async {

    return await FirebaseMessaging.instance
        .getToken();
  }

  // ================= INIT =================

  static Future<void> init() async {

    FirebaseMessaging messaging =
        FirebaseMessaging.instance;

    // ================= IZIN =================

    await messaging.requestPermission(

      alert: true,

      badge: true,

      sound: true,

      provisional: false,
    );

    // ================= TOKEN =================

    String? token =
    await messaging.getToken();

    print("FCM TOKEN:");
    print(token);

    // ================= LOCAL NOTIFICATION =================

    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
    settings =
    InitializationSettings(
      android: androidSettings,
    );

    await localNotifications.initialize(
      settings,
    );

    // ================= CREATE CHANNEL =================

    await localNotifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
      channel,
    );

    // ================= FOREGROUND OPTION =================

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(

      alert: true,

      badge: true,

      sound: true,
    );

    // ================= BACKGROUND =================

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    // ================= FOREGROUND =================

    FirebaseMessaging.onMessage.listen(

          (RemoteMessage message) {

        print("NOTIF MASUK");
        print(message.notification?.title);
        print(message.notification?.body);

        showNotification(

          message.notification?.title ??
              "Notifikasi",

          message.notification?.body ??
              "",
        );
      },
    );

    // ================= KLIK NOTIF =================

    FirebaseMessaging.onMessageOpenedApp.listen(

          (RemoteMessage message) {

        print("NOTIF DIKLIK");
      },
    );
  }

  // ================= SHOW NOTIFICATION =================

  static Future<void> showNotification(

      String title,

      String body,

      ) async {

    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(

      'edeslay_channel',

      'Edeslay Notification',

      channelDescription:
      'Channel untuk notifikasi aplikasi desa',

      importance:
      Importance.max,

      priority:
      Priority.high,

      playSound: true,
    );

    const NotificationDetails
    details =
    NotificationDetails(

      android: androidDetails,
    );

    await localNotifications.show(

      0,

      title,

      body,

      details,
    );
  }
}