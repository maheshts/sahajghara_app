import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../nwdata/model/notification_model.dart';
import '../nwdata/service/home_service.dart';



final notificationControllerProvider = ChangeNotifierProvider((ref) => NotificationController());


class NotificationController extends ChangeNotifier {
  bool isLoading = false;
  List<NotificationModel> notifications = [];




  Future<void> fetchNotifications() async {
    isLoading = true;
    notifyListeners();

    notifications = await HomeService().getNotifications();

    isLoading = false;
    notifyListeners();
  }
}