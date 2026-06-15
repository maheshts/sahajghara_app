// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
//
// import '../../helpers/utillls.dart';
// import '../api/api_contants.dart';
//
// // @pragma('vm:entry-point')
// // Future<void> firebaseMessagingBackgroundHandler(
// //     RemoteMessage message) async {
// //
// //   await Firebase.initializeApp();
// //
// //   /// DO NOTHING HERE
// //   /// Firebase automatically shows notification
// // }
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   // Guard against re-initialization
//   if (Firebase.apps.isEmpty) {
//     await Firebase.initializeApp();
//   }
//   // DO NOT call showNotification() here — FCM handles it automatically
//   // for messages that have a "notification" payload.
//   // Only handle data-only messages if needed:
//   if (message.notification == null && message.data.isNotEmpty) {
//     // Optionally handle silent/data-only background messages here
//   }
// }
//
// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _localNotifications =
//   FlutterLocalNotificationsPlugin();
//   static ValueNotifier<int> notificationCount = ValueNotifier(0);
//
//   static ValueNotifier<int> selectedTabIndex = ValueNotifier(0);
//   static const AndroidNotificationChannel _channel =
//   AndroidNotificationChannel(
//     'high_importance_channel',
//     'High Importance Notifications',
//     description: 'Important notifications',
//     importance: Importance.high,
//   );
//
//   // ================= INIT =================
//
//   static Future<void> init1() async {
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings =
//     InitializationSettings(android: androidSettings);
//
//     await _localNotifications.initialize(
//       settings: settings,
//       onDidReceiveNotificationResponse: _onNotificationClick,
//       onDidReceiveBackgroundNotificationResponse: _onNotificationClick,
//     );
//
//     // await _localNotifications
//     //     .resolvePlatformSpecificImplementation
//     // AndroidFlutterLocalNotificationsPlugin>()
//     //     ?.createNotificationChannel(_channel);
//
//     await FirebaseMessaging.instance.requestPermission();
//
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     final token = await FirebaseMessaging.instance.getToken();
//     Utills.customPrint('FCM Token: $token');
//     if (token != null) {
//       await _sendTokenToServer(token);
//     }
//
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       _sendTokenToServer(newToken);
//     });
//
//     // ✅ FIX: Only show local notification in FOREGROUND
//     // When app is background/terminated, FCM shows it automatically
//     FirebaseMessaging.onMessage.listen((message) {
//       notificationCount.value++;
//       showNotification(message); // ✅ Safe — only fires in foreground
//     });
//
//     final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }
//
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }
//   static Future<void> init() async {
//     // Android initialization
//     const AndroidInitializationSettings androidSettings =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     const InitializationSettings settings =
//     InitializationSettings(android: androidSettings);
//
//     await _localNotifications.initialize(settings:
//       settings,
//       onDidReceiveNotificationResponse: _onNotificationClick,
//       onDidReceiveBackgroundNotificationResponse: _onNotificationClick,
//     );
//
//
//     // Create notification channel
//     await _localNotifications
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(_channel);
//
//     // Request permission (Android 13+ + iOS)
//     await FirebaseMessaging.instance.requestPermission();
//
//     // iOS foreground notification fix
//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     // Get FCM token
//     final token = await FirebaseMessaging.instance.getToken();
//     Utills.customPrint('FCM Token: $token');
//
//     if (token != null) {
//       await _sendTokenToServer(token);
//     }
//
//     // Token refresh
//     FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//       _sendTokenToServer(newToken);
//     });
//
//     // Foreground message
//     FirebaseMessaging.onMessage.listen((message) {
//       NotificationService.notificationCount.value++;
//
//       showNotification(message);
//     });
//
//     // App opened from terminated state
//     final initialMessage =
//     await FirebaseMessaging.instance.getInitialMessage();
//     if (initialMessage != null) {
//       _handleMessage(initialMessage);
//     }
//
//     // App opened from background
//     FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
//   }
//
//   // ================= SHOW NOTIFICATION =================
//   static Future<void> showNotification(RemoteMessage message) async {
//     final notification = message.notification;
//     if (notification == null) return;
//
//     final androidDetails = AndroidNotificationDetails(
//       _channel.id,
//       _channel.name,
//       channelDescription: _channel.description,
//       importance: Importance.high,
//       priority: Priority.high,
//     );
//
//     final details = NotificationDetails(android: androidDetails);
//
//     await _localNotifications.show(
//       id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title: notification.title,
//       body: notification.body,
//       notificationDetails: details,
//       payload: jsonEncode(message.data),
//     );
//
//   }
//
//   // ================= CLICK HANDLER =================
//   static void _onNotificationClick(NotificationResponse response) {
//     if (response.payload != null) {
//       final data = jsonDecode(response.payload!);
//       Utills.customPrint("Notification clicked: $data");
// //Notification clicked: {orderId: ZO00002202604042, screen: order_history, type: order}"
//       if (data['screen'] == 'order_history') {
//         selectedTabIndex.value = 1; // 👈 Orders tab
//       }
//     }
//   }
//
//   // ================= HANDLE FCM CLICK =================
//   static void _handleMessage(RemoteMessage message) {
//     Utills.customPrint("Opened from notification: ${message.data}");
//     final data = message.data;
//
//     if (data['screen'] == 'order_history') {
//       selectedTabIndex.value = 1;
//     }
//     // TODO: Handle navigation
//   }
//
//   // ================= SEND TOKEN =================
//   static Future<void> _sendTokenToServer(String token) async {
//     Utills.customPrint('Saving FCM Token: $token');
//     await storeFcmToken(token: token);
//   }
//
//   // ================= STORE TOKEN =================
//   static Future<void> storeFcmToken({required String token}) async {
//     String uuid = const Uuid().v4();
//
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setString(APIConstants.fcmToken, token);
//     await pref.setString(APIConstants.uuid, uuid);
//   }
//
//   // ================= GET TOKEN =================
//   static Future<String> getFcmToken() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     return pref.getString(APIConstants.fcmToken) ?? "";
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sahajghara/helpers/utillls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../nwdata/api/api_contants.dart';



@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  // FCM handles notification display automatically in background/terminated
  // Increment count for background messages
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final int current = pref.getInt('notification_count') ?? 0;
  await pref.setInt('notification_count', current + 1);
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  static ValueNotifier<int> notificationCount = ValueNotifier(0);
  static ValueNotifier<int> selectedTabIndex = ValueNotifier(0);

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Important notifications',
    importance: Importance.high,
  );

  // ================= INIT =================
  static Future<void> init() async {
    Utills.customPrint("init notification");
    // ---- Android Settings ----
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // ---- iOS Settings ----
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,

    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(settings:
      settings,
      onDidReceiveNotificationResponse: _onNotificationClick,
      onDidReceiveBackgroundNotificationResponse: _onNotificationClick,
    );

    if (Platform.isAndroid) {
      await _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);
    }
    // ---- Permissions ----
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else {
      await FirebaseMessaging.instance.requestPermission();
    }

    // ---- Get & Send FCM Token ----
    final String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');
    if (token != null) {
      await _sendTokenToServer(token);
    }

    // ---- Token Refresh ----
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      _sendTokenToServer(newToken);
    });

    // ---- Foreground Message Handler ----
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await _incrementCount(); // ✅ count foreground
      showNotification(message);
    });

    // ---- App opened from TERMINATED state ----
    final RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      await _incrementCount(); // ✅ count terminated tap
      _handleMessage(initialMessage);
    }

    // ---- App opened from BACKGROUND state ----
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      await _incrementCount(); // ✅ count background tap
      _handleMessage(message);
    });
  }

  // ================= SHOW NOTIFICATION =================
  static Future<void> showNotification(RemoteMessage message) async {
    // Handle both notification-type AND data-only messages
    final String title = message.notification?.title ??
        message.data['title'] ??
        'New Notification';
    final String body =
        message.notification?.body ?? message.data['body'] ?? '';

    // ---- Android Details ----
    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    // ---- iOS Details ----
    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Unique ID
    //final int notifId = DateTime.now().millisecondsSinceEpoch & 0x7FFFFFFF;

    // await _localNotifications.show(
    //   notifId,
    //   title,
    //   body,
    //   details,
    //   payload: jsonEncode(message.data),
    // );
    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: details,
      payload: jsonEncode(message.data),
    );
  }



  // ================= NOTIFICATION CLICK HANDLER =================
  @pragma('vm:entry-point')
  static void _onNotificationClick(NotificationResponse response) {
    if (response.payload != null && response.payload!.isNotEmpty) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.payload!);
        debugPrint("Notification clicked: $data");

        if (data['screen'] == 'order_history') {
          selectedTabIndex.value = 1;
        }
        // Add more screen cases here
      } catch (e) {
        debugPrint("Notification payload parse error: $e");
      }
    }
  }

  // ================= FCM TAP HANDLER (background/terminated) =================
  static void _handleMessage(RemoteMessage message) {
    debugPrint("Opened from notification: ${message.data}");
    final Map<String, dynamic> data = message.data;

    if (data['screen'] == 'order_history') {
      selectedTabIndex.value = 1;
    }
    // Add more screen cases here
  }

  // ================= COUNT HELPERS =================
  static Future<void> _incrementCount() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final int current = pref.getInt('notification_count') ?? 0;
      final int updated = current + 1;
      await pref.setInt('notification_count', updated);
      notificationCount.value = updated; // ✅ update UI notifier
    } catch (e) {
      debugPrint("Error incrementing notification count: $e");
    }
  }

  // Call this on app start to restore count
  static Future<void> loadCount() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      notificationCount.value = pref.getInt('notification_count') ?? 0;
    } catch (e) {
      debugPrint("Error loading notification count: $e");
    }
  }

  // Call this when user views notifications screen
  static Future<void> clearCount() async {
    try {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setInt('notification_count', 0);
      notificationCount.value = 0; // ✅ reset UI notifier
    } catch (e) {
      debugPrint("Error clearing notification count: $e");
    }
  }

  // ================= SEND TOKEN TO SERVER =================
  static Future<void> _sendTokenToServer(String token) async {
    debugPrint('Saving FCM Token: $token');
    await storeFcmToken(token: token);
  }

  // ================= STORE TOKEN LOCALLY =================
  static Future<void> storeFcmToken({required String token}) async {
    final String uuid = const Uuid().v4();
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(APIConstants.fcmToken, token);
    await pref.setString(APIConstants.uuid, uuid);
  }

  // ================= GET TOKEN =================
  static Future<String> getFcmToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(APIConstants.fcmToken) ?? '';
  }

  // ================= CLEAR BADGE (iOS) =================
  static Future<void> clearBadge() async {
    if (Platform.isIOS) {
      await _localNotifications.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(alert: true, badge: true, sound: true);
    }
    notificationCount.value = 0;
  }
}