import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_enquiry_details.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_quote_detail.dart';
import 'package:shimmer/shimmer.dart';

import '../../controllers/list_controller.dart';
import '../../helpers/utillls.dart';

class MyActivity extends ConsumerStatefulWidget {
  const MyActivity({super.key});

  @override
  ConsumerState<MyActivity> createState() => _InquiryListScreenState();
}


class _InquiryListScreenState extends ConsumerState<MyActivity> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listControllerProvider).getEnquiryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final enquiryWatch = ref.watch(listControllerProvider);
    final inquiryList = enquiryWatch.enquiryList;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),

      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
      ),

      body: SafeArea(
        child: enquiryWatch.getEnquiryStatus ==
            EnquiryListStatus.loading
            ? _buildShimmerList()
            : enquiryWatch.getEnquiryStatus ==
            EnquiryListStatus.loaded
            ? inquiryList != null &&
            inquiryList.isNotEmpty
            ? ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: inquiryList.length,
          itemBuilder: (context, index) {
            final inquiry = inquiryList[index];

            return _inquiryCard(
              context,
              inquiry,
            );
          },
        )
            : Center(
          child: Text(
            "No Enquiry Found",
            style: nunitoItalic16,
          ),
        )
            : _buildErrorView(),
      ),
    );
  }

  // ============================================================
  // INQUIRY CARD
  // ============================================================

  Widget _inquiryCard(
      BuildContext context,
      dynamic inquiry,
      ) {
    // Customer-facing status
    final String currentStatus =
    inquiry.statusMessage?.toString().trim().isNotEmpty == true
        ? inquiry.statusMessage.toString().trim()
        : inquiry.status?.toString().trim().isNotEmpty == true
        ? inquiry.status.toString().trim()
        : "Unknown";

    final List<Color> statusColors =
    _getStatusGradient(currentStatus);

    final Color statusBorder =
    _getStatusBorderColor(currentStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        // Status based background
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: statusColors,
        ),

        // Status based border
        border: Border.all(
          color: statusBorder,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(16),

          onTap: () {
            Utills.customPrint("Inquiry clicked");

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VendorQuoteDetail(
                  inquiryId: inquiry.sId.toString(),
                  isVendor: false,
                ),
              ),
            );
          },

          child: Padding(
            padding: const EdgeInsets.all(15),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                // ==================================================
                // TOP ROW
                // ==================================================

                Row(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    // Inquiry Icon
                    Container(
                      height: 46,
                      width: 46,

                      decoration: BoxDecoration(
                        color: AppColors.primary
                            .withOpacity(0.10),

                        borderRadius:
                        BorderRadius.circular(12),
                      ),

                      child: Icon(
                        Icons.receipt_long_rounded,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Vendor + Inquiry Code
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,

                        children: [
                          Text(
                            inquiry.vendorName ??
                                "Unknown Vendor",

                            maxLines: 1,

                            overflow:
                            TextOverflow.ellipsis,

                            style: nunitoItalic15.copyWith(
                              fontSize: 16,
                              fontWeight:
                              FontWeight.w800,
                              color:
                              Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 3),

                          Text(
                            "#${inquiry.code ?? "-"}",

                            style:
                            nunitoItalic12White.copyWith(
                              color:
                              AppColors.primary,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Status Badge
                    _statusBadge(
                      currentStatus,
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // ==================================================
                // CATEGORY / BRAND
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child: _highlightItem(
                        icon:
                        Icons.category_outlined,
                        label: "Category",
                        value:
                        inquiry.categoryName,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _highlightItem(
                        icon:
                        Icons.sell_outlined,
                        label: "Brand",
                        value:
                        inquiry.brandName,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ==================================================
                // QUANTITY / URGENCY
                // ==================================================

                Row(
                  children: [
                    Expanded(
                      child: _highlightItem(
                        icon: Icons
                            .inventory_2_outlined,
                        label: "Quantity",
                        value: inquiry.orderQuantity
                            ?.toString(),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: _highlightItem(
                        icon: Icons
                            .priority_high_rounded,
                        label: "Urgency",
                        value:
                        inquiry.requirmentUrgency,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ==================================================
                // LOCATION
                // ==================================================

                Container(
                  width: double.infinity,

                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 10,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(0.65),

                    borderRadius:
                    BorderRadius.circular(10),
                  ),

                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [
                      Icon(
                        Icons
                            .location_on_outlined,
                        size: 18,
                        color:
                        Colors.grey.shade600,
                      ),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,

                          children: [
                            Text(
                              "Location",

                              style: TextStyle(
                                fontSize: 10,
                                color: Colors
                                    .grey.shade500,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              inquiry.location ??
                                  "-",

                              maxLines: 2,

                              overflow:
                              TextOverflow.ellipsis,

                              style:
                              const TextStyle(
                                fontSize: 12,
                                color:
                                Colors.black87,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                // ==================================================
                // VIEW DETAILS
                // ==================================================

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.end,

                  children: [
                    Text(
                      "View Details",

                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w700,
                        color:
                        AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 4),

                    Icon(
                      Icons
                          .arrow_forward_rounded,
                      size: 16,
                      color:
                      AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STATUS GRADIENT
  // ============================================================

  List<Color> _getStatusGradient(
      String status,
      ) {
    final String value =
    status.toLowerCase().trim();

    // ------------------------------------------
    // WAITING FOR VENDOR
    // ------------------------------------------

    if (value.contains("waiting for vendor")) {
      return const [
        Color(0xFFFFF8E8),
        Color(0xFFFFEDC7),
      ];
    }

    // ------------------------------------------
    // WAITING FOR ADMIN
    // ------------------------------------------

    if (value.contains("waiting for admin")) {
      return const [
        Color(0xFFFFF3E6),
        Color(0xFFFFE0C2),
      ];
    }

    // ------------------------------------------
    // CONFIRM QUOTATION
    // ------------------------------------------

    if (value.contains("confirm quotation")) {
      return const [
        Color(0xFFEAF4FF),
        Color(0xFFD6E9FF),
      ];
    }

    // ------------------------------------------
    // QUOTATION CONFIRMED
    // ------------------------------------------

    if (value.contains("quotation confirmed")) {
      return const [
        Color(0xFFEAF8EF),
        Color(0xFFD9F2E3),
      ];
    }

    // ------------------------------------------
    // COMPLETED
    // ------------------------------------------

    if (value.contains("completed")) {
      return const [
        Color(0xFFE8F7EE),
        Color(0xFFD2EFDC),
      ];
    }

    // ------------------------------------------
    // REJECTED
    // ------------------------------------------

    if (value.contains("reject")) {
      return const [
        Color(0xFFFFEEEE),
        Color(0xFFFFDCDC),
      ];
    }

    // ------------------------------------------
    // CANCELLED
    // ------------------------------------------

    if (value.contains("cancel")) {
      return const [
        Color(0xFFFFEEEE),
        Color(0xFFFFDCDC),
      ];
    }

    // ------------------------------------------
    // DEFAULT
    // ------------------------------------------

    return const [
      Color(0xFFF1F4F8),
      Color(0xFFE4EAF0),
    ];
  }

  // ============================================================
  // STATUS BORDER
  // ============================================================

  Color _getStatusBorderColor(
      String status,
      ) {
    final String value =
    status.toLowerCase().trim();

    if (value.contains("waiting for vendor")) {
      return const Color(0xFFE8D39D);
    }

    if (value.contains("waiting for admin")) {
      return const Color(0xFFE8C49A);
    }

    if (value.contains("confirm quotation")) {
      return const Color(0xFFBBD5EF);
    }

    if (value.contains("quotation confirmed")) {
      return const Color(0xFFB8DEC6);
    }

    if (value.contains("completed") || value.contains("Payment successful")) {
      return const Color(0xFF39AB5A);
    }

    if (value.contains("reject") ||
        value.contains("cancel")) {
      return const Color(0xFFE8B2B2);
    }

    return const Color(0xFFD0D7DE);
  }

  // ============================================================
  // HIGHLIGHT ITEM
  // ============================================================

  Widget _highlightItem({
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 9,
      ),

      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius:
        BorderRadius.circular(10),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            size: 17,
            color: AppColors.primary,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                Text(
                  label,

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: 10,
                    color:
                    Colors.grey.shade500,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  value?.isNotEmpty == true
                      ? value!
                      : "-",

                  maxLines: 1,

                  overflow:
                  TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATUS BADGE
  // ============================================================

  Widget _statusBadge(
      String status,
      ) {
    final String value =
    status.toLowerCase().trim();

    Color background;
    Color foreground;
    IconData icon;

    // ------------------------------------------
    // WAITING FOR VENDOR
    // ------------------------------------------

    if (value.contains(
        "waiting for vendor")) {
      background =
      const Color(0xFFFFE9B5);

      foreground =
      const Color(0xFF9A6500);

      icon =
          Icons.hourglass_top_rounded;
    }

    // ------------------------------------------
    // WAITING FOR ADMIN
    // ------------------------------------------

    else if (value.contains(
        "waiting for admin")) {
      background =
      const Color(0xFFFFDFC2);

      foreground =
      const Color(0xFF9A5A00);

      icon =
          Icons.admin_panel_settings_outlined;
    }

    // ------------------------------------------
    // CONFIRM QUOTATION
    // ------------------------------------------

    else if (value.contains(
        "confirm quotation")) {
      background =
      const Color(0xFFDDEEFF);

      foreground =
      const Color(0xFF1769AA);

      icon =
          Icons.receipt_long_outlined;
    }

    // ------------------------------------------
    // QUOTATION CONFIRMED
    // ------------------------------------------

    else if (value.contains(
        "quotation confirmed")) {
      background =
      const Color(0xFFDDF3E5);

      foreground =
      const Color(0xFF247A45);

      icon =
          Icons.verified_outlined;
    }

    // ------------------------------------------
    // COMPLETED
    // ------------------------------------------

    else if (value.contains(
        "completed")) {
      background =
      const Color(0xFFDDF3E5);

      foreground =
      const Color(0xFF247A45);

      icon =
          Icons.check_circle_outline_rounded;
    }

    // ------------------------------------------
    // REJECTED
    // ------------------------------------------

    else if (value.contains(
        "reject")) {
      background =
      const Color(0xFFFFE0E0);

      foreground =
      const Color(0xFFB42318);

      icon =
          Icons.cancel_outlined;
    }

    // ------------------------------------------
    // CANCELLED
    // ------------------------------------------

    else if (value.contains(
        "cancel")) {
      background =
      const Color(0xFFFFE0E0);

      foreground =
      const Color(0xFFB42318);

      icon =
          Icons.cancel_outlined;
    }

    // ------------------------------------------
    // DEFAULT
    // ------------------------------------------

    else {
      background =
      const Color(0xFFE9EEF3);

      foreground =
      const Color(0xFF5F6B76);

      icon =
          Icons.info_outline_rounded;
    }

    return Container(
      padding:
      const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: background,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize:
        MainAxisSize.min,

        children: [
          Icon(
            icon,
            size: 14,
            color: foreground,
          ),

          const SizedBox(width: 4),

          ConstrainedBox(
            constraints:
            const BoxConstraints(
              maxWidth: 110,
            ),

            child: Text(
              status,

              maxLines: 1,

              overflow:
              TextOverflow.ellipsis,

              style: TextStyle(
                fontSize: 10,
                fontWeight:
                FontWeight.w800,
                color: foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR VIEW
  // ============================================================

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(20),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Image.asset(
              'assets/images/no_internet.png',
              height: 150,
            ),

            const SizedBox(height: 20),

            const Text(
              "Connection Error",

              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Please check your internet connection and try again.",
              textAlign:
              TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(
                    listControllerProvider)
                    .getEnquiryList();
              },

              icon: const Icon(
                Icons.refresh,
              ),

              label: const Text(
                "Retry",
              ),

              style:
              ElevatedButton.styleFrom(
                backgroundColor:
                Colors.blueAccent,

                foregroundColor:
                Colors.white,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(8),
                ),

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SHIMMER LIST
  // ============================================================

  Widget _buildShimmerList() {
    return ListView.builder(
      padding:
      const EdgeInsets.all(12),

      itemCount: 5,

      itemBuilder:
          (context, index) {
        return Shimmer.fromColors(
          baseColor:
          Colors.grey.shade300,

          highlightColor:
          Colors.grey.shade100,

          child: Container(
            height: 280,

            margin:
            const EdgeInsets.only(
              bottom: 12,
            ),

            decoration:
            BoxDecoration(
              color: Colors.white,

              borderRadius:
              BorderRadius.circular(16),
            ),
          ),
        );
      },
    );
  }
}
