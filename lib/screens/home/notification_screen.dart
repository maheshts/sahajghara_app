import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:sahajghara/main.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_quote_detail.dart';

import '../../controllers/notification_controller.dart';
import '../profile/vendor/vendor_enquiry_details.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}


class _NotificationScreenState
    extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(notificationControllerProvider)
          .fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notificationState =
    ref.watch(notificationControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        titleSpacing: 16,
        title: Text(
          "Notifications",
          style: nunitoItalic16.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: notificationState.isLoading
          ? _buildLoadingState()
          : notificationState.notifications.isNotEmpty
          ? RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {
          await ref
              .read(notificationControllerProvider)
              .fetchNotifications();
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            14,
            16,
            14,
            24,
          ),
          itemCount:
          notificationState.notifications.length,
          itemBuilder: (context, index) {
            final item =
            notificationState.notifications[index];

            return _buildNotificationCard(
              context,
              item,
            );
          },
        ),
      )
          : _buildEmptyState(),
    );
  }

  // ===========================================================
  // NOTIFICATION CARD
  // ===========================================================

  Widget _buildNotificationCard(
      BuildContext context,
      dynamic item,
      ) {
    final bool isUnread = item.isRead != true;
    final bool isVendor = item.isVendor == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUnread
            ? const Color(0xFFF0F6FF)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUnread
              ? const Color(0xFFD5E5FA)
              : const Color(0xFFE8ECF1),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: () {
            if (isVendor) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VendorQuoteDetail(
                        inquiryId:
                        item.referenceId.toString(),
                        isVendor: true,
                      ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VendorQuoteDetail(
                        inquiryId:
                        item.referenceId.toString(),
                        isVendor: false,
                      ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // =================================================
                // ICON
                // =================================================

                _buildNotificationIcon(
                  isUnread: isUnread,
                  isVendor: isVendor,
                ),

                const SizedBox(width: 13),

                // =================================================
                // CONTENT
                // =================================================

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      // Title + NEW
                      Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title ?? "",
                              maxLines: 2,
                              overflow:
                              TextOverflow.ellipsis,
                              style: nunitoItalic14.copyWith(
                                fontSize: 14.5,
                                fontWeight: isUnread
                                    ? FontWeight.w800
                                    : FontWeight.w700,
                                color:
                                const Color(0xFF17202A),
                              ),
                            ),
                          ),

                          // if (isUnread) ...[
                          //   const SizedBox(width: 8),
                          //
                          //   Container(
                          //     padding:
                          //     const EdgeInsets.symmetric(
                          //       horizontal: 7,
                          //       vertical: 3,
                          //     ),
                          //     decoration: BoxDecoration(
                          //       color: AppColors.primary,
                          //       borderRadius:
                          //       BorderRadius.circular(20),
                          //     ),
                          //     child: const Text(
                          //       "NEW",
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 8,
                          //         fontWeight:
                          //         FontWeight.w800,
                          //         letterSpacing: .4,
                          //       ),
                          //     ),
                          //   ),
                          // ],
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Message
                      Text(
                        item.message ?? "",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: nunitoItalic12White.copyWith(
                          color: const Color(0xFF6E7781),
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Bottom information
                      Row(
                        children: [

                          Icon(
                            Icons.access_time_rounded,
                            size: 13,
                            color: isUnread
                                ? AppColors.primary
                                : const Color(0xFF9AA3AC),
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              item.createdAt ?? "",
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style: nunitoRegular12.copyWith(
                                color: const Color(0xFF89929C),
                                fontSize: 10.5,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          // Vendor / Customer badge
                          Container(
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isVendor
                                  ? const Color(0xFFFFF3E6)
                                  : const Color(0xFFEAF4FF),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Icon(
                                  isVendor
                                      ? Icons.storefront_outlined
                                      : Icons.person_outline,
                                  size: 11,
                                  color: isVendor
                                      ? const Color(0xFFB96B00)
                                      : const Color(0xFF1466A8),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  isVendor
                                      ? "Vendor"
                                      : "Customer",
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight:
                                    FontWeight.w700,
                                    color: isVendor
                                        ? const Color(
                                      0xFFB96B00,
                                    )
                                        : const Color(
                                      0xFF1466A8,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 5),

                // =================================================
                // ARROW
                // =================================================

                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 22,
                    color: isUnread
                        ? AppColors.primary
                        .withOpacity(.65)
                        : const Color(0xFFB2BAC2),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // NOTIFICATION ICON
  // ===========================================================

  Widget _buildNotificationIcon({
    required bool isUnread,
    required bool isVendor,
  }) {
    final Color iconColor;

    if (isVendor) {
      iconColor = const Color(0xFFE58A00);
    } else {
      iconColor = AppColors.primary;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [

        Container(
          height: 48,
          width: 48,
          decoration: BoxDecoration(
            color: isUnread
                ? iconColor.withOpacity(.12)
                : const Color(0xFFF2F4F6),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isUnread
                ? Icons.notifications_active_rounded
                : Icons.notifications_none_rounded,
            color: isUnread
                ? iconColor
                : const Color(0xFF89939D),
            size: 23,
          ),
        ),

        if (isUnread)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              height: 11,
              width: 11,
              decoration: BoxDecoration(
                color: const Color(0xFFFF4D4D),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFFF0F6FF),
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // ===========================================================
  // LOADING
  // ===========================================================

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(14),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Container(
          height: 115,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Padding(
            padding: EdgeInsets.all(14),
            child: Row(
              children: [
                SizedBox(
                  height: 48,
                  width: 48,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFE9EDF2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(width: 13),
                Expanded(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 13,
                        width: 180,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFE9EDF2),
                            borderRadius:
                            BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        height: 10,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFE9EDF2),
                            borderRadius:
                            BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 7),
                      SizedBox(
                        height: 10,
                        width: 120,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xFFE9EDF2),
                            borderRadius:
                            BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===========================================================
  // EMPTY STATE
  // ===========================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 35,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Container(
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                size: 46,
                color: AppColors.primary.withOpacity(.65),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "No Notifications",
              style: nunitoItalic16.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF27313B),
              ),
            ),

            const SizedBox(height: 7),

            Text(
              "You're all caught up! New notifications will appear here.",
              textAlign: TextAlign.center,
              style: nunitoRegular12.copyWith(
                color: const Color(0xFF8A949E),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
