
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sahajghara/helpers/utillls.dart';
import 'package:sahajghara/main.dart';
import 'package:sahajghara/screens/profile/contractor/contractor_enquiry_details.dart';
import 'package:sahajghara/screens/vendor/EnquiryDetailResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../nwdata/api/api_contants.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/vendor/vendor_enquiry_details.dart';



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
static final GlobalKey<NavigatorState> navigatorKey =
GlobalKey<NavigatorState>();
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
      _handleMessage(initialMessage); WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleMessage(initialMessage);
      });
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
    Utills.customPrint("value ${message.data}");
    //{_id: 123466, page: InqueryDetails, type: general, click_action: FLUTTER_NOTIFICATION_CLICK}"
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
    try {
      final payload = response.payload;

      if (payload == null || payload.isEmpty) {
        debugPrint("Notification payload is empty");
        return;
      }

      final data = jsonDecode(payload);
      Utills.customPrint("data $data");

      final context = navigatorKey.currentContext;

      if (context == null) {
        debugPrint("Navigator context not ready");
        return;
      }

      final page = data['page']?.toString() ?? '';
      final oid = data['_id']?.toString() ?? '';

      final bool isVendor =
          data['isVendor']?.toString().toLowerCase() == 'true' ||
              data['isvendor']?.toString().toLowerCase() == 'true';

      switch (page) {
        case 'InqueryDetails':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VendorEnquiryDetails(
                isVendor: isVendor,
                inquiryId: oid,
              ),
            ),
          );
          break;

        case 'ContractorInqueryDetails':
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ContractorEnquiryDetails(
                isVendor: isVendor,
                inquiryId: oid,
              ),
            ),
          );
          break;

        default:
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => HomeScreen(
                address: "",
                latitude: 0,
                longitude: 0,
              ),
            ),
                (_) => false,
          );
      }
    } catch (e, stack) {
      debugPrint("Notification error: $e");
      debugPrint(stack.toString());
    }
  }

  // ================= FCM TAP HANDLER (background/terminated) =================
  static void _handleMessage(RemoteMessage message) {
    debugPrint("Opened from notification: ${message.data}");
    final Map<String, dynamic> data = message.data;
    final page = data['page']?.toString() ?? '';
    //final oid = data['_id']?.toString() ?? '';
    if (page == 'InqueryDetails') {
      //selectedTabIndex.value = 1;
      final oid = data['_id'] ?? "";
      final bool isVendor =
          data['isVendor']?.toString().toLowerCase() == 'true' ||
              data['isvendor']?.toString().toLowerCase() == 'true';

      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => VendorEnquiryDetails(
            inquiryId: oid,
            isVendor: isVendor,
          ),
        ),
      );

      // Navigation.sideNavigation(context, child)
      // Navigator.push(navigatorKey.currentContext!,
      //     MaterialPageRoute(builder: (_) => VendorEnquiryDetails(isVendor: isVendor,inquiryId: oid)));
    }else if (page  == 'ContractorInqueryDetails') {
      //selectedTabIndex.value = 1;
      var oid = data['_id'] ?? "";
      final bool isVendor =
          data['isVendor']?.toString().toLowerCase() == 'true' ||
              data['isvendor']?.toString().toLowerCase() == 'true';
      // Navigation.sideNavigation(context, child)
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => ContractorEnquiryDetails(
            inquiryId: oid,
            isVendor: isVendor,
          ),
        ),
      );
      // Navigator.push(navigatorKey.currentContext!,
      //     MaterialPageRoute(builder: (_) => ContractorEnquiryDetails(isVendor: isVendor,inquiryId: oid)));
    }else{
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (context) =>
            HomeScreen(
                address: "dfsdf", latitude: 2.444, longitude: 3.3333)),

      );
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

  static Future<String> inittoken() async {
    Utills.customPrint("fcm init");
    final String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('FCM Token: $token');
    storeFcmToken(token: token.toString());
    return token.toString();
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