import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../../helpers/utillls.dart';
import '../api/api_contants.dart';

class PushNotificationService {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  storeFcmTokenToDB() async {
    String? token =
        // "sample-fcm-123";
        await firebaseMessaging.getToken();
    Utills.customPrint('getfcmtoken $token');
    await storeFcmToken(token: token!);
    return token;
  }

  storeFcmToken({required String token}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(APIConstants.fcmToken, token);
  }

  Future<String> getFcmToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString(APIConstants.fcmToken) ?? "";
    return token;
  }

  requestPermission() async {
    bool status = false;

    NotificationSettings settings = await firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // print('User granted permission: ${settings.authorizationStatus}');
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // print('User granted permission');

      status = true;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      status = true;
      // print('User granted provisional permission');
    } else {
      // print('User declined or has not accepted permission');
      status = false;
    }
    return status;
  }

  registerNotification() async {
    _checkForInitialMessage();

    // when app is background and  terminated
    _backgroundHandler();

    // when app is streaming then it called foreground
    _foregroundHandler();

    // when app is in foreground and user press fcm then it will be called
    _fcmPressHandler();
  }

// when app is streaming then it called foreground
  _foregroundHandler() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
       print("_foregroundHandler recieved 2|${message.toString()}");
      if (message.data.isNotEmpty) {
        await callToAction(message);
      }
    });
  }

// when app is in foreground and user press fcm then it will be called
  _fcmPressHandler() async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.isNotEmpty) {
        await callToAction(message);
      }
    });
  }

// when app is background and  terminated
  Future<void> _backgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    if (message.data.isNotEmpty) {
      await PushNotificationService().callToAction(message);
    }

    // print("Handling a background message: ${message.messageId}");
  }

  _checkForInitialMessage() async {
    await FirebaseMessaging.instance.getInitialMessage().then((message) async {
      if (message != null) {
        print('_checkForInitialMessage ${message.data}');
        await callToAction(message);
        // PushNotificationModel notification = PushNotificationModel(
        //   title: message.notification?.title,
        //   body: message.notification?.body,
        // );
        // setState(() {
        //   _notificationInfo = notification;
        //   _totalNotifications++;
        // });
      }
    });
  }

  Future callToAction(RemoteMessage message) async {
    Utills.customPrint("message $message");
    // try {
    //   UserService userService = UserService();
    //   Utills.customPrint('callToAction1');
    //   bool isAuthenticated = await userService.isAuthenticated();

    //   if (isAuthenticated == false) {
    //     //  int wpRefPostID = int.parse(message.data['wpRefPostID'].toString());
    //     //  await userService.storeWpRefPOstId(id: wpRefPostID);
    //     await global.navigatorKey.currentState!.pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) {
    //       return const LoginPage();
    //     }), (route) => false);
    //   }
    //   Utills.customPrint('callToAction2|${message.data}');
    //   int wpRefPostID = int.parse(message.data['wpRefPostID'].toString());

    //   final dbRef = firebaseDB.collection('posts');
    //   final dbQuery = dbRef.where('wpRefPostID', isEqualTo: wpRefPostID).get();

    //   List<PostModel> postDatas = await dbQuery.then((snapshot) => snapshot
    //       .docs
    //       .map<PostModel>((doc) => PostModel.fromJson(doc.data()))
    //       .toList());

    //   Utills.customPrint('callToAction3|${postDatas}');

    //   if (postDatas.isNotEmpty) {
    //     return await global.navigatorKey.currentState!.pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) {
    //       return FBPostDetails(postData: postDatas[0]);
    //     }), (route) => false);
    //   }
    // } catch (e) {}
  }
}
