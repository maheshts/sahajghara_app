import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:sahajghara/main.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';

import '../../controllers/notification_controller.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}



class _NotificationScreenState extends ConsumerState<NotificationScreen> {


  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(notificationControllerProvider).fetchNotifications();

    });
  }

  @override
  Widget build(BuildContext context) {
    var refWatch = ref.watch(notificationControllerProvider);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.primary,
           iconTheme: const IconThemeData(color: Colors.white),
          title:  Text("Notifications",style: nunitoItalic16.copyWith(color: Colors.white),)),
      body: refWatch.isLoading? Center(child: CircularProgressIndicator()):
          refWatch.notifications.isNotEmpty?
       ListView.builder(
    itemCount: refWatch.notifications.length,
      itemBuilder: (context, index) {

        final item =
        refWatch.notifications[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          child: ListTile(
            leading: Icon(
              item.isRead == true
                  ? Icons.notifications_none
                  : Icons.notifications_active,
            ),
            title: Text(item.title ?? '',style: nunitoItalic14,maxLines: 1,),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.message ?? '',style: nunitoItalic12White.copyWith(color: Colors.black45),),
                Text(item.createdAt ?? '',style: nunitoRegular12,),
              ],
            ),
            // trailing: Text(
            //   item.createdAt ?? '',
            //   style: const TextStyle(
            //     fontSize: 11,
            //   ),
            // ),
          ),
        );
      },
    ):
      const Center(
        child: Text("No Notifications Available"),
      ),
    );
  }
}
