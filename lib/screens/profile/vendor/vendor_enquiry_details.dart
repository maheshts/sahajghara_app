import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_reply.dart';
import 'package:sahajghara/screens/vendor/EnquiryDetailResponse.dart';
import '../../../controllers/order_controller.dart';
import '../../../helpers/custom_toast.dart';
import '../../../helpers/navigation.dart';
import '../../../helpers/utillls.dart';
import '../../vendor/provider/update_controller.dart';
import '../../vendor/provider/vendro_detail_controller.dart';
import '../order_success.dart';

class VendorEnquiryDetails extends ConsumerStatefulWidget {
  final String inquiryId;
  final bool isVendor;


  const VendorEnquiryDetails({super.key, required this.inquiryId,required this.isVendor});

  @override
  ConsumerState<VendorEnquiryDetails> createState() =>
      _VendorEnquiryDetailsState();
}
// ============================================================
// STATUS MODEL
// ============================================================

class _StatusColors {
  final Color background;
  final Color backgroundLight;
  final Color border;
  final Color foreground;
  final IconData icon;

  _StatusColors({
    required this.background,
    required this.backgroundLight,
    required this.border,
    required this.foreground,
    required this.icon,
  });
}

class _VendorEnquiryDetailsState extends ConsumerState<VendorEnquiryDetails> {

  late EnquiryDetails details;
  var paidAmount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(vendorDetailProvider.notifier)
          .getEnquiryDetail(widget.inquiryId);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorDetailProvider);

    return SafeArea(
      top: false,
      child: state.when(
        loading: () =>
        const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) =>
        const Scaffold(
          body: Center(child: Text("Something went wrong")),
        ),
        data: (data) {
          if (data == null) {
            return const Scaffold(
              body: Center(child: Text("No Data Found")),
            );
          }

            details = data.data as EnquiryDetails;

          return Scaffold(
            appBar: _buildAppBar(details),
            bottomNavigationBar: _buildBottomBar(details),
            body: _buildBody(details),
          );
        },
      ),
    );
  }

////////////////////////////////////////////////////////////
  /// 🔹 UI DECISION HELPERS (Clean & Scalable)
////////////////////////////////////////////////////////////

  bool soorderConfirm(EnquiryDetails d) =>
      !widget.isVendor && (d.status ?? 0) > 4;

  bool _canAddQuote(EnquiryDetails d) =>
      widget.isVendor && d.status == 2;

  bool _canShowVendorDetails(EnquiryDetails d) =>
      !widget.isVendor;

  bool _canShowVendorPriceBreakdown(EnquiryDetails d) =>
      widget.isVendor && (d.status ?? 0) > 4;

  bool _canShowCustomerPriceBreakdown(EnquiryDetails d) =>
      !widget.isVendor && (d.status ?? 0) == 5;

  bool _canShowCustomerPrice(EnquiryDetails d) =>
      !widget.isVendor && (d.status ?? 0) == 4;

  bool _canShowPayNow(EnquiryDetails d) =>
      !widget.isVendor && (d.status ?? 0) == 5;


////////////////////////////////////////////////////////////
  /// 🔹 APP BAR
////////////////////////////////////////////////////////////

  PreferredSizeWidget _buildAppBar(
      EnquiryDetails details,
      ) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppTheme.surface(context, Colors.white),
      surfaceTintColor: Colors.white,

      iconTheme: const IconThemeData(
        color: Color(0xFF252A30),
      ),

      titleSpacing: 0,

      title: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const Text(
            "Order Details",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF252A30),
            ),
          ),

          Text(
            "#${details.code ?? "-"}",
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF8A929B),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),

      actions: [
        if (_canAddQuote(details))
          Padding(
            padding:
            const EdgeInsets.only(right: 12),
            child: ElevatedButton.icon(
              onPressed: () async {
                final result =
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        VendorReplyScreen(
                          inquiryId:
                          widget.inquiryId,
                          details: details,
                        ),
                  ),
                );

                if (result == true) {
                  await ref
                      .read(
                      vendorDetailProvider
                          .notifier)
                      .getEnquiryDetail(
                      widget.inquiryId);
                }
              },
              icon: const Icon(
                Icons.add_rounded,
                size: 17,
              ),
              label: const Text(
                "Quote",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                AppColors.primary
                    .withOpacity(0.10),
                foregroundColor:
                AppColors.primary,
                elevation: 0,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(10),
                ),
              ),
            ),
          ),
      ],
    );
  }

////////////////////////////////////////////////////////////
  /// 🔹 BOTTOM BAR
////////////////////////////////////////////////////////////

  Widget? _buildBottomBar1(EnquiryDetails details) {

    if (!_canShowPayNow(details)) return null;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // Pay Now Logic
          //var total = details.approvedQuantity! * details.pricePerQuantity! + details.transportPrice ;
          var total = (details.approvedQuantity ?? 0) *
              (details.pricePerQuantity ?? 0) +
              (details.transportPrice ?? 0);
          // var total = details.approvedQuantity! * details.pricePerQuantity! + details.transportPrice ;
         setState(() {
           paidAmount = total;

         });
          ref.read(orderControllerProvider)
              .createOrder(context,total, details.sId ?? "").then((response) {
             if(response.isSuccess){
                final orderid = ref.read(orderControllerProvider).orderNumber;
              //  final amount = details.pricePerQuantity ?? 0;
                final rzkey = ref.read(orderControllerProvider).rzKey;
                razorpayPayment(orderid, total,rzkey,details);
             }
          });
          // razorpayPayment(orderid, amount,_rzkey);
        },
        child:  Text("Pay Now",style: nunitoItalic14White,),
      ),
    );
  }

  // ============================================================
// MODERN BODY
// ============================================================

  Widget _buildBody(EnquiryDetails details) {
    final int quantity = details.approvedQuantity ?? 0;
    final double pricePerQty = details.pricePerQuantity ?? 0;
    final double transport = details.transportPrice ?? 0;

    final double subTotal = quantity * pricePerQty;
    final double total = subTotal + transport;

    return Container(
      color: AppTheme.surface(context, Color(0xFFF5F7FA)),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ==================================================
            // STATUS HEADER
            // ==================================================

            _buildModernStatusHeader(details),

            const SizedBox(height: 14),

            // ==================================================
            // PROGRESS TIMELINE
            // ==================================================

            _buildOrderProgress(details),

            const SizedBox(height: 14),

            // ==================================================
            // PRODUCT DETAILS
            // ==================================================

            _buildModernProductCard(details),

            const SizedBox(height: 14),

            // ==================================================
            // VENDOR DETAILS
            // ==================================================

            if (_canShowVendorDetails(details))
              _buildModernVendorCard(details),

            if (_canShowVendorDetails(details))
              const SizedBox(height: 14),

            // ==================================================
            // PRICE
            // ==================================================

            if (_canShowVendorPriceBreakdown(details) ||
                _canShowCustomerPriceBreakdown(details))
              _buildModernPriceCard(
                details,
                quantity,
                pricePerQty,
                transport,
                subTotal,
                total,
              ),

            if (_canShowVendorPriceBreakdown(details) ||
                _canShowCustomerPriceBreakdown(details))
              const SizedBox(height: 14),

            // ==================================================
            // COMMENTS
            // ==================================================

            if ((details.vendorComments ?? "").trim().isNotEmpty)
              _buildModernCommentCard(details),

            if ((details.vendorComments ?? "").trim().isNotEmpty)
              const SizedBox(height: 14),

            // ==================================================
            // CONFIRM QUOTATION
            // ==================================================

            if (_canShowCustomerPrice(details))
              _buildConfirmButton(details),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }


// ============================================================
// STATUS HEADER
// ============================================================

  Widget _buildModernStatusHeader(EnquiryDetails details) {
    final status = details.statusMessage ?? "Pending";

    final colors = _getStatusColors(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.background,
            colors.backgroundLight,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Row(
          //   children: [
          //
          //     Container(
          //       width: 48,
          //       height: 48,
          //       decoration: BoxDecoration(
          //         color: Colors.white.withOpacity(0.75),
          //         borderRadius: BorderRadius.circular(14),
          //       ),
          //       child: Icon(
          //         colors.icon,
          //         color: colors.foreground,
          //         size: 25,
          //       ),
          //     ),
          //
          //     const SizedBox(width: 12),
          //
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment:
          //         CrossAxisAlignment.start,
          //         children: [
          //
          //           const Text(
          //             "Inquiry Status",
          //             style: TextStyle(
          //               fontSize: 11,
          //               color: Color(0xFF777777),
          //               fontWeight: FontWeight.w600,
          //             ),
          //           ),
          //
          //           const SizedBox(height: 3),
          //
          //           Text(
          //             status,
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.w800,
          //               color: colors.foreground,
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          //
          // const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surface(context, Colors.white).withOpacity(0.65),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [

                Icon(
                  Icons.receipt_long_outlined,
                  size: 17,
                  color: colors.foreground,
                ),

                const SizedBox(width: 7),

                const Text(
                  "Inquiry ID",
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF777777),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                Text(
                  "#${details.code ?? "-"}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: colors.foreground,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget? _buildBottomBar(
      EnquiryDetails details,
      ) {
    if (!_canShowPayNow(details)) {
      return null;
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        14,
        10,
        14,
        14,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        border: Border(
          top: BorderSide(
            color: Color(0xFFE5E8EC),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              final total =
                  (details.approvedQuantity ?? 0) *
                      (details.pricePerQuantity ?? 0) +
                      (details.transportPrice ?? 0);

              setState(() {
                paidAmount = total;
              });

              ref
                  .read(orderControllerProvider)
                  .createOrder(
                context,
                total,
                details.sId ?? "",
              )
                  .then((response) {
                if (response.isSuccess) {
                  final orderid = ref
                      .read(orderControllerProvider)
                      .orderNumber;

                  final rzkey = ref
                      .read(orderControllerProvider)
                      .rzKey;

                  razorpayPayment(
                    orderid,
                    total,
                    rzkey,
                    details,
                  );
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.lock_outline_rounded,
                  size: 19,
                ),

                const SizedBox(width: 8),

                const Text(
                  "Pay Now",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
// ============================================================
// STATUS COLORS
// ============================================================

  _StatusColors _getStatusColors(String status) {
    final value = status.toLowerCase().trim();

    if (value.contains("waiting for vendor")) {
      return _StatusColors(
        background: const Color(0xFFFFF4D8),
        backgroundLight: const Color(0xFFFFFBF0),
        border: const Color(0xFFF1D48A),
        foreground: const Color(0xFF946200),
        icon: Icons.hourglass_top_rounded,
      );
    }

    if (value.contains("waiting for admin")) {
      return _StatusColors(
        background: const Color(0xFFFFEBD7),
        backgroundLight: const Color(0xFFFFF8F1),
        border: const Color(0xFFEEC59B),
        foreground: const Color(0xFF995500),
        icon: Icons.admin_panel_settings_outlined,
      );
    }

    if (value.contains("confirm quotation")) {
      return _StatusColors(
        background: const Color(0xFFE5F1FF),
        backgroundLight: const Color(0xFFF6FAFF),
        border: const Color(0xFFBCD7F2),
        foreground: const Color(0xFF1769AA),
        icon: Icons.receipt_long_outlined,
      );
    }

    if (value.contains("quotation confirmed")) {
      return _StatusColors(
        background: const Color(0xFFE5F7EB),
        backgroundLight: const Color(0xFFF5FCF7),
        border: const Color(0xFFB8DEC4),
        foreground: const Color(0xFF247A45),
        icon: Icons.verified_rounded,
      );
    }

    if (value.contains("complete")) {
      return _StatusColors(
        background: const Color(0xFFE5F7EB),
        backgroundLight: const Color(0xFFF5FCF7),
        border: const Color(0xFFB8DEC4),
        foreground: const Color(0xFF247A45),
        icon: Icons.check_circle_rounded,
      );
    }

    if (value.contains("reject") ||
        value.contains("cancel")) {
      return _StatusColors(
        background: const Color(0xFFFFE7E7),
        backgroundLight: const Color(0xFFFFF7F7),
        border: const Color(0xFFF0BABA),
        foreground: const Color(0xFFB42318),
        icon: Icons.cancel_rounded,
      );
    }

    return _StatusColors(
      background: const Color(0xFFEAF2FA),
      backgroundLight: const Color(0xFFF7FAFD),
      border: const Color(0xFFC8D9E8),
      foreground: AppColors.primary,
      icon: Icons.info_outline_rounded,
    );
  }



// ============================================================
// ORDER PROGRESS
// ============================================================

  Widget _buildOrderProgress(EnquiryDetails details) {
    final int currentStatus = details.status ?? 1;

    return _buildModernSection(
      title: "Order Progress",
      icon: Icons.timeline_rounded,
      child: Column(
        children: [

          _progressItem(
            number: "1",
            title: "Inquiry Received",
            subtitle: "New Inquiry received",
            active: currentStatus >= 1,
            completed: currentStatus > 1,
            isLast: false,
          ),

          _progressItem(
            number: "2",
            title: "Quotation Submitted",
            subtitle: "Quotation submitted to sahajghar",
            active: currentStatus >= 2,
            completed: currentStatus > 2,
            isLast: false,
          ),

          // _progressItem(
          //   number: "3",
          //   title: "Quotation Review",
          //   subtitle: "Quotation is being reviewed",
          //   active: currentStatus >= 3,
          //   completed: currentStatus > 3,
          //   isLast: false,
          // ),

          _progressItem(
            number: "3",
            title: "Quotation Posted",
            subtitle: "Quotation is approved by Sahajghar and posted to customer",
            active: currentStatus >= 3,
            completed: currentStatus > 3,
            isLast: false,
          ),
_progressItem(
            number: "4",
            title: "Payment Received",
            subtitle: "Payment confirmed and ready to dispatch",
            active: currentStatus >= 4,
            completed: currentStatus > 4,
            isLast: false,
          ),

          _progressItem(
            number: "5",
            title: "Order Confirmed",
            subtitle: "Your order has been dispatched and is on its way",
            active: currentStatus >= 5,
            completed: currentStatus >= 5,
            isLast: true,
          ),
        ],
      ),
    );
  }


// ============================================================
// PROGRESS ITEM
// ============================================================

  Widget _progressItem({
    required String number,
    required String title,
    required String subtitle,
    required bool active,
    required bool completed,
    required bool isLast,
  }) {
    final Color activeColor =
    completed || active
        ? AppColors.primary
        : const Color(0xFFD8DEE5);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          width: 34,
          child: Column(
            children: [

              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.primary
                      : active
                      ? AppColors.primary
                      : const Color(0xFFE9EDF1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: completed
                      ? const Icon(
                    Icons.check_rounded,
                    size: 17,
                    color: Colors.white,
                  )
                      : Text(
                    number,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: active
                          ? Colors.white
                          : const Color(0xFF89939E),
                    ),
                  ),
                ),
              ),

              if (!isLast)
                Container(
                  width: 2,
                  height: 38,
                  color: activeColor,
                ),
            ],
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 1,
              bottom: 15,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: active
                        ? const Color(0xFF252A30)
                        : const Color(0xFF9299A1),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: active
                        ? const Color(0xFF737B84)
                        : const Color(0xFFA6ADB4),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


// ============================================================
// PRODUCT CARD
// ============================================================

  Widget _buildModernProductCard(
      EnquiryDetails d,
      ) {
    return _buildModernSection(
      title: "Product Details",
      icon: Icons.inventory_2_outlined,
      child: Column(
        children: [

          Row(
            children: [
              Expanded(
                child: _modernInfoTile(
                  icon: Icons.category_outlined,
                  label: "Category",
                  value: d.categoryName,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _modernInfoTile(
                  icon: Icons.sell_outlined,
                  label: "Brand",
                  value: d.brandName,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _modernInfoTile(
                  icon: Icons.inventory_outlined,
                  label: "Requested Qty",
                  value:
                  d.orderQuantity?.toString(),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _modernInfoTile(
                  icon: Icons.priority_high_rounded,
                  label: "Urgency",
                  value: d.requirmentUrgency,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _modernWideInfo(
            icon: Icons.location_on_outlined,
            label: "Delivery Location",
            value: d.location,
          ),

          const SizedBox(height: 10),

          _modernWideInfo(
            icon: Icons.calendar_today_outlined,
            label: "Created",
            value: d.createdAt,
          ),

          if (!widget.isVendor) ...[
            const SizedBox(height: 10),

            _modernWideInfo(
              icon: Icons.check_circle_outline,
              label: "Approved Quantity",
              value:
              "${d.approvedQuantity ?? "N/A"}",
            ),
          ],
        ],
      ),
    );
  }


// ============================================================
// VENDOR CARD
// ============================================================

  Widget _buildModernVendorCard(
      EnquiryDetails d,
      ) {
    return _buildModernSection(
      title: "Vendor",
      icon: Icons.storefront_outlined,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: AppTheme.gradient(context, [
              Color(0xFFF8FAFC),
              Color(0xFFF1F5F9),
            ]),
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: const Color(0xFFE1E7ED),
          ),
        ),
        child: Row(
          children: [

            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withOpacity(0.10),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.storefront_rounded,
                color: AppTheme.accent(context, AppColors.primary),
                size: 26,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [

                  Text(
                    d.vendorName ?? "Unknown Vendor",
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF252A30),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    d.vendorCode != null
                        ? "Vendor Code: ${d.vendorCode}"
                        : "Verified Vendor",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF737B84),
                    ),
                  ),
                ],
              ),
            ),

            if (d.pricePerQuantity != null)
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [

                  const Text(
                    "Price / Qty",
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF8A929B),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    "₹${d.pricePerQuantity}",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.accent(context, AppColors.primary),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }


// ============================================================
// PRICE CARD
// ============================================================

  Widget _buildModernPriceCard(
      EnquiryDetails d,
      int quantity,
      double pricePerQty,
      double transport,
      double subTotal,
      double total,
      ) {
    return _buildModernSection(
      title: "Quotation Summary",
      icon: Icons.payments_outlined,
      child: Column(
        children: [

          _priceRow(
            "Approved Quantity",
            "$quantity",
          ),

          _priceRow(
            "Price / Quantity",
            "₹${pricePerQty.toStringAsFixed(2)}",
          ),

          _priceRow(
            "Subtotal",
            "₹${subTotal.toStringAsFixed(2)}",
          ),

          _priceRow(
            "Transport",
            d.transportApplicable == "1"
                ? "₹${transport.toStringAsFixed(2)}"
                : "Not Applicable",
          ),

          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Divider(
              height: 1,
            ),
          ),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary
                  .withOpacity(0.07),
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Row(
              children: [

                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius:
                    BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.currency_rupee_rounded,
                    color: Colors.white,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF343A40),
                    ),
                  ),
                ),

                Text(
                  "₹${total.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.accent(context, AppColors.primary),
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
// PRICE ROW
// ============================================================

  Widget _priceRow(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        children: [

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF747C85),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF252A30),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }


// ============================================================
// COMMENT CARD
// ============================================================

  Widget _buildModernCommentCard(
      EnquiryDetails d,
      ) {
    return _buildModernSection(
      title: "Vendor Message",
      icon: Icons.chat_bubble_outline_rounded,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface(context, Color(0xFFFFFBF1)),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: const Color(0xFFF0DFB7),
          ),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            const Icon(
              Icons.format_quote_rounded,
              size: 22,
              color: Color(0xFFC58A25),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Text(
                d.vendorComments ?? "-",
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: Color(0xFF514A3E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


// ============================================================
// CONFIRM BUTTON
// ============================================================

  Widget _buildConfirmButton(
      EnquiryDetails details,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary
                .withOpacity(0.20),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () async {
          final body = {
            "_id": widget.inquiryId,
            "status": 5,
          };

          await ref
              .read(
              vendorQuotationProvider.notifier)
              .addVendorQuotation(body)
              .then((response) {

            if (response.isSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                    "Quotation Confirmed successfully",
                  ),
                ),
              );

              Navigator.pop(context, true);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    response.message,
                  ),
                ),
              );
            }
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding:
          const EdgeInsets.symmetric(
            vertical: 15,
          ),
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(15),
          ),
        ),
        child: const Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [

            Icon(
              Icons.check_circle_outline_rounded,
              size: 20,
            ),

            SizedBox(width: 8),

            Text(
              "Confirm Quotation",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }


// ============================================================
// MODERN SECTION
// ============================================================

  Widget _buildModernSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE4E8ED),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary
                      .withOpacity(0.08),
                  borderRadius:
                  BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: AppTheme.accent(context, AppColors.primary),
                ),
              ),

              const SizedBox(width: 9),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF252A30),
                ),
              ),
            ],
          ),

          const SizedBox(height: 13),

          child,
        ],
      ),
    );
  }


// ============================================================
// SMALL INFO TILE
// ============================================================

  Widget _modernInfoTile({
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Color(0xFFF7F9FB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [

          Icon(
            icon,
            size: 18,
            color: AppTheme.accent(context, AppColors.primary),
          ),

          const SizedBox(width: 8),

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
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF8B939B),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value?.isNotEmpty == true
                      ? value!
                      : "-",
                  maxLines: 1,
                  overflow:
                  TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF292E33),
                    fontWeight: FontWeight.w700,
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
// WIDE INFO
// ============================================================

  Widget _modernWideInfo({
    required IconData icon,
    required String label,
    String? value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Color(0xFFF7F9FB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            size: 18,
            color: AppTheme.accent(context, AppColors.primary),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF8B939B),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value?.isNotEmpty == true
                      ? value!
                      : "-",
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF292E33),
                    fontWeight: FontWeight.w700,
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

  Widget _buildStatusBadge(String? status) {
    final String currentStatus =
    status?.trim().isNotEmpty == true
        ? status!.trim()
        : "Pending";

    final colors =
    _getStatusColors(currentStatus);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: colors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            colors.icon,
            size: 15,
            color: colors.foreground,
          ),

          const SizedBox(width: 5),

          Flexible(
            child: Text(
              currentStatus,
              maxLines: 1,
              overflow:
              TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: colors.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }


// ============================================================
// STATUS MODEL
// ============================================================


////////////////////////////////////////////////////////////
  /// 🔹 BODY
////////////////////////////////////////////////////////////

  Widget _buildBody1(EnquiryDetails details) {
    final int quantity = details.approvedQuantity ?? 0;
    final double pricePerQty = details.pricePerQuantity ?? 0;
    final double transport = details.transportPrice ?? 0;

    final double subTotal = quantity * pricePerQty;
    final double total = subTotal + transport;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildStatusBadge(details.statusMessage),
              const SizedBox(height: 16),
              // Text("${details.statusMessage} - ${details.status ?? 0}",
              //     style: nunitoItalic15.copyWith(color: AppColors.primary)),

              _buildProductSection(details),
              const SizedBox(height: 10),

              if (_canShowVendorDetails(details))
                _buildVendorSection(details),

              if (_canShowVendorPriceBreakdown(details) ||
                  _canShowCustomerPriceBreakdown(details))
                _buildPriceSection(details.pricePerQuantity,
                    details.transportApplicable.toString(),
                    details.transportPrice ?? 0, total!),

              const SizedBox(height: 10),

              _buildCommentSection(details),

              const SizedBox(height: 14),

              if(_canShowCustomerPrice(details))
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDeep,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                        ),
                        onPressed: () async {
                          final body = {
                            "_id": widget.inquiryId,
                            "status": 5,
                          };
                          await ref
                              .read(vendorQuotationProvider.notifier)
                              .addVendorQuotation(body).then((response) {
                            if (response.isSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text(
                                    "Quotation Confirmed successfully")),
                              );
                              Navigator.pop(context, true);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(response.message)),
                              );
                            }
                          });
                        },
                        child: Text(
                            "Confirm Order", style: nunitoItalic14White))
                  //,
                )
            ],
          ),
        ),
      ),
    );
  }

////////////////////////////////////////////////////////////
  /// 🔹 SECTIONS
////////////////////////////////////////////////////////////

  Widget _buildProductSection(EnquiryDetails d) {
    return _buildCard(
      title: "Product Details",
      children: [
        _infoRow("Category", d.categoryName),
        _infoRow("Brand", d.brandName),
        _infoRow("Requested Qty", d.orderQuantity.toString()),
        if (!widget.isVendor)
          _infoRow("Approved Qty", "${d.approvedQuantity ?? "N/A"}"),
        _infoRow("Urgency", d.requirmentUrgency),
        _infoRow("Location", d.location),
        _infoRow("Created At", d.createdAt),
      ],
    );
  }

  Widget _buildVendorSection(EnquiryDetails d) {
    return _buildCard(
      title: "Vendor Details",
      children: [
        _infoRow("Vendor Name", d.vendorName),
        _infoRow("Vendor Code", d.vendorCode),
        _infoRow("Price / Qty","₹ ${d.pricePerQuantity ?? 'NA'}"),
        // _infoRow("Transport Applicable",
        //     d.transportApplicable == "1" ? "Yes" : "No"),
        // _infoRow("Transport Service", d.transportService),
      ],
    );
  }

  Widget _buildPriceSection(double? qtyprice, String transportapplic,
      double transportprice, double total) {
    return _buildCard(
      title: "Price Breakdown",
      children: [
        _infoRow("Price / Qty", "₹ ${qtyprice}"),
        _infoRow("Transport Applicable",
            transportapplic == "1" ? "Yes" : "No"),
        //_infoRow("Transport Service", d.transportService),
        // _infoRow("Sub Total", "₹ ${subTotal.toStringAsFixed(2)}"),
        _infoRow("Transport", "₹ ${transportprice.toStringAsFixed(2)}"),

        const Divider(),
        _infoRow("Total Amount",
            "₹ ${total.toStringAsFixed(2)}",
            isBold: true),
      ],
    );
  }

  Widget _buildCommentSection(EnquiryDetails d) {
    return _buildCard(
      title: "Comments",
      children: [
        _infoRow("Vendor Comment", d.vendorComments ?? "-"),
      ],
    );
  }


  Future<Future> showQuoteDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Add Quote",
            style: nunitoItalic15.copyWith(color: AppTheme.accent(context, AppColors.primary)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Quote Amount"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Quote Details"),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle quote submission logic here
                Navigator.pop(context);
              },
              child: Text("Submit Quote"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatusBadge1(String? status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.orange.shade100),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status!.toUpperCase(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            const SizedBox(height: 10),
            ...children
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String? value,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Flexible(
            child: Text(
              value ?? "-",
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight:
                isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  razorpayPayment(String orderid, num amount, String rzkey, EnquiryDetails details) async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Razorpay razorpay = Razorpay();
    var options = {
      'key': rzkey,
      'amount': amount * 100,
      'name': "widget.propertyData!.propertyName,",
      'description': 'payment for order $orderid',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,

      'prefill': {'contact': details.phone, 'email': details.email},
      'external': {
        'wallets': ['paytm']
      }
    };
    Utills.customPrint('rzvalue ${options}');

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

// Reset UI after closing Razorpay
  void _resetUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    Utills.customPrint('PaymentFailureResponse ${response.message}');
    _resetUI();
    CustomToast.displayErrorToast(content: "Payment failed");

    //showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
    // ref
    //     .read(orderControllerProvider)
    //     .paymentStatusUpdate(context, "11111", 0, "Payment Failed")
    //     .then((response) {
    //   if (response.isSuccess) {
    //     CustomToast.displaySuccessToast(content: response.message);
    //     //  Navigation.sideNavigation(context, OrderSuccess(orderAmount:widget.amount));
    //   } else {
    //     CustomToast.displayErrorToast(content: response.message);
    //   }
      Navigation.pop(context);
    //});
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    _resetUI();

    Utills.customPrint('PaymentSuccessResponse ${response.data}');
    //showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");

    CustomToast.displaySuccessToast(content: "We have received your payment.");
    ref
        .read(orderControllerProvider)
        .paymentStatusUpdate(
        context, response.paymentId.toString(), 1, "Success")
        .then((response) {
      if (response.isSuccess) {
        Utills.customPrint('PaymentSuccessResponse ${response}');

        CustomToast.displaySuccessToast(content: response.message);
        var orderno = ref
            .read(orderControllerProvider)
            .orderNumber;
       // Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  OrderSuccess(
                    orderNo: orderno,
                    orderAmount: paidAmount,
                    totalAmount: paidAmount,
                    propertyName: details.vendorName,
                    propertyId: widget.inquiryId,
                  )),
        );
        //Navigation.replace(context, Success());
      } else {
        CustomToast.displayErrorToast(content: "Payment failed try again");
      }
    });
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    _resetUI();
  }


void _showPaymentResultDialog({
  required String status,
  required String message,
  required String transactionId,
}) {
  final isSuccess = status.toLowerCase() == 'success';
  if (isSuccess) {
    ref
        .read(orderControllerProvider)
        .paymentStatusUpdate(context, isSuccess ? transactionId : "11111",
        isSuccess ? 1 : 0, status)
        .then((response) {
      if (response.isSuccess) {
        Utills.customPrint('PaymentSuccessResponse ${response}');
        CustomToast.displaySuccessToast(
            content: "Payment received.We are updating to partner");
        var orderno = ref.read(orderControllerProvider).orderNumber;

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => OrderSuccess(
        //         orderNo: orderno,
        //         orderAmount: payableAmount.toString(),
        //         totalAmount: totalAmount,
        //
        //         propertyName: propertyName,
        //         propertyId: propertyId,
        //       )),
        // );

        CustomToast.displayWarningToast(content: response.message);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.message)),
        );
      }
    });
  } else {
    CustomToast.displayErrorToast(content: "Unable to payment try again");
  }
}


void _showSnackBar(String message, [Color? color]) {
  if (!mounted) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showAlertDialog(BuildContext context, String title, String message) {
  // set up the buttons
  Widget continueButton = ElevatedButton(
    child: Text(
      "Ok",
      style: nunitoItalic15,
    ),
    onPressed: () {
      Navigation.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(message, style: nunitoItalic15),
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
}