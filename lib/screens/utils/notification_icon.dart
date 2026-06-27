import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/screens/home/notification_screen.dart';


import '../../helpers/navigation.dart';
import '../../main.dart';



class NotificationBadgeIcon extends ConsumerWidget {
  final String phone;

  const NotificationBadgeIcon({super.key, required this.phone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(notificationCountProvider);

    return Stack(
      children: [
        IconButton(
          icon: const Icon(
            Icons.notifications,
            color: Colors.white,
            size: 18,
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(2, 2),
                blurRadius: 2,
              ),
            ],
          ),
          onPressed: () {
            // Reset counter when clicked
            ref.read(notificationCountProvider.notifier).clear();
            // Navigate to notifications screen...
             Navigation.sideNavigation(context, NotificationScreen());
            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (_) => AppWebView(
            //         url:
            //             "https://zingara.club/OrdersClaimMobApp/NotificationMember?mobileno=$phone&usertype=1",
            //         // "https://eticket.zingara.club/Events/Index?propertyId=${item.propertyId}&categoryId=${item.categoryID}&userId=$memberid",
            //         title: "Notifications",
            //       ),
            //     ));
          },
        ),
        if (unreadCount > 0)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                '$unreadCount',
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}
