import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_reply.dart';

import '../../../controllers/order_controller.dart';
import '../../../helpers/custom_toast.dart';
import '../../../helpers/navigation.dart';
import '../../../helpers/utillls.dart';
import '../../vendor/EnquiryDetailResponse.dart';
import '../../vendor/provider/update_controller.dart';
import '../../vendor/provider/vendro_detail_controller.dart';
import '../order_success.dart';

// ============================================================
// KEEP / CHANGE THESE IMPORTS ACCORDING TO YOUR PROJECT
// ============================================================



// ============================================================
// CONTRACTOR ENQUIRY DETAILS SCREEN
// ============================================================

class VendorQuoteDetail extends ConsumerStatefulWidget {
  final String inquiryId;
  final bool isVendor;

  const VendorQuoteDetail({
    super.key,
    required this.inquiryId,
    required this.isVendor,
  });

  @override
  ConsumerState<VendorQuoteDetail> createState() =>
      _ContractorEnquiryDetailsState();
}


// ============================================================
// ASSUMPTIONS / INTEGRATION NOTES
// ------------------------------------------------------------
// 1. `data.data` is expected to be an `EnquiryResult` (the model
//    that carries `details`, `tracking`, and `messages`), not just
//    `EnquiryDetails`. If your provider currently only returns
//    `EnquiryDetails`, update it to return the full `result` object
//    from the API response so `tracking` + `messages` are available.
// 2. Import the model file that defines `EnquiryResult`,
//    `EnquiryTracking`, `TrackingStep`, and `StatusMessage`.
// 3. All static timeline steps and static status descriptions have
//    been removed. Timeline now renders directly from
//    `tracking.steps`, and the status subtitle text now comes from
//    the `messages` map (role-aware: vendor vs customer).
// ============================================================

class _ContractorEnquiryDetailsState
    extends ConsumerState<VendorQuoteDetail> {

  double paidAmount = 0;
  String vendorName = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(vendorDetailProvider.notifier)
          .getEnquiryDetail(widget.inquiryId);
    });
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorDetailProvider);

    return SafeArea(
      top: false,

      child: state.when(

        // ------------------------------------------------------
        // LOADING
        // ------------------------------------------------------

        loading: () {
          return Scaffold(
            backgroundColor: AppTheme.surface(context, Color(0xFFF5F7FA)),
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF003B73),
              ),
            ),
          );
        },

        // ------------------------------------------------------
        // ERROR
        // ------------------------------------------------------

        error: (error, stack) {
          return Scaffold(
            backgroundColor: AppTheme.surface(context, Color(0xFFF5F7FA)),
            appBar: _buildAppBar(null),
            body: _buildErrorState(),
          );
        },

        // ------------------------------------------------------
        // DATA
        // ------------------------------------------------------

        data: (data) {

          if (data == null || data.data == null) {
            return Scaffold(
              backgroundColor: AppTheme.surface(context, Color(0xFFF5F7FA)),
              appBar: _buildAppBar(null),
              body: _buildEmptyState(),
            );
          }

          final EnquiryResult result = data.data  as EnquiryResult;
          final EnquiryDetails? details = result.details;

          if (details == null) {
            return Scaffold(
              backgroundColor: AppTheme.surface(context, Color(0xFFF5F7FA)),
              appBar: _buildAppBar(null),
              body: _buildEmptyState(),
            );
          }

          final EnquiryTracking? tracking = result.tracking;
          final Map<String, StatusMessage>? messages = result.messages;

          return Scaffold(
            backgroundColor: AppTheme.surface(context, Color(0xFFF5F7FA)),

            appBar: _buildAppBar(details),

            bottomNavigationBar: _buildBottomBar(details),

            body: _buildBody(details, tracking, messages),
          );
        },
      ),
    );
  }


  // ==========================================================
  // APP BAR
  // ==========================================================

  PreferredSizeWidget _buildAppBar(
      EnquiryDetails? details,
      ) {
    return AppBar(
      backgroundColor: AppTheme.surface(context, Colors.white),
      elevation: 0,
      centerTitle: false,

      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Color(0xFF172033),
          size: 20,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),

      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Quotation Details",
            style: TextStyle(
              color: Color(0xFF172033),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),

          if (details != null)
            Text(
              "#${details.code ?? widget.inquiryId}",
              style: const TextStyle(
                color: Color(0xFF8A93A3),
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),

      actions: [
        if (details != null && _canAddQuote(details))
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),

              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VendorReplyScreen(
                      inquiryId: widget.inquiryId,
                      details: details,
                    ),
                  ),
                );

                if (result == true) {
                  await ref
                      .read(vendorDetailProvider.notifier)
                      .getEnquiryDetail(widget.inquiryId);
                }
              },

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Color(0xFFEAF3FF)),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD3E5F8)),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: Color(0xFF003B73),
                    ),
                    SizedBox(width: 3),
                    Text(
                      "Add Quote",
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF003B73),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }


  // ==========================================================
  // BODY
  // ==========================================================

  Widget _buildBody(
      EnquiryDetails details,
      EnquiryTracking? tracking,
      Map<String, StatusMessage>? messages,
      ) {

    final int quantity = _toInt(details.approvedQuantity);
    final double pricePerQty = _toDouble(details.pricePerQuantity);
    final double transport = _toDouble(details.transportPrice);
    final double subTotal = quantity * pricePerQty;
    final double total = subTotal + transport;

    return RefreshIndicator(
      color: const Color(0xFF003B73),

      onRefresh: () async {
        await ref
            .read(vendorDetailProvider.notifier)
            .getEnquiryDetail(widget.inquiryId);
      },

      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),

        padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =================================================
            // INQUIRY DETAILS
            // =================================================

            _buildModernProductCard(details),

            const SizedBox(height: 14),

            // =================================================
            // VENDOR DETAILS
            // =================================================

            if (_canShowVendorDetails(details))
              _buildModernVendorCard(details),

            if (_canShowVendorDetails(details))
              const SizedBox(height: 14),

            // =================================================
            // PRICE BREAKDOWN
            // =================================================

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

            // =================================================
            // COMMENTS
            // =================================================

            if (details.vendorComments != null &&
                details.vendorComments!.trim().isNotEmpty)
              _buildModernCommentCard(details),

            if (details.vendorComments != null &&
                details.vendorComments!.trim().isNotEmpty)
              const SizedBox(height: 14),

            // =================================================
            // STATUS / TIMELINE  (now fully API-driven)
            // =================================================

            _buildQuotationStatusCard(details, tracking, messages),

            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }


  // ==========================================================
  // QUOTATION STATUS CARD
  // ==========================================================

  Widget _buildQuotationStatusCard(
      EnquiryDetails details,
      EnquiryTracking? tracking,
      Map<String, StatusMessage>? messages,
      ) {

    final int status = details.status ?? tracking?.status ?? 0;

    final String title = details.statusMessage?.trim().isNotEmpty == true
        ? details.statusMessage!
        : _resolveStatusText(status, messages);

    final String description = _resolveStatusDescription(status, messages);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE3E8EF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // --------------------------------------------------
          // HEADER
          // --------------------------------------------------

          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _statusBackground(status),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  _statusIcon(status),
                  color: _statusColor(status),
                  size: 23,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Quotation Status",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "#${details.code ?? widget.inquiryId}",
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8A93A3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // --------------------------------------------------
          // TIMELINE — now sourced from tracking.steps
          // --------------------------------------------------

          _buildStatusTimeline(status, tracking),

          const SizedBox(height: 2),

          // --------------------------------------------------
          // STATUS MESSAGE — now sourced from messages map
          // --------------------------------------------------

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _statusBackground(status),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  _statusIcon(status),
                  size: 19,
                  color: _statusColor(status),
                ),

                const SizedBox(width: 9),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: _statusColor(status),
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF687386),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // STATUS TIMELINE — driven by tracking.steps from the API
  // ==========================================================

  Widget _buildStatusTimeline(
      int status,
      EnquiryTracking? tracking,
      ) {

    final List<TrackingStep> steps = tracking?.steps ?? [];

    if (steps.isEmpty) {
      // No tracking payload — render nothing rather than fake steps.
      return const SizedBox.shrink();
    }

    return Column(
      children: List.generate(steps.length, (index) {
        final TrackingStep step = steps[index];

        final bool completed = step.state == "done";
        final bool current = step.state == "current";
        final bool last = index == steps.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------------------------------------
            // NODE + CONNECTOR
            // ---------------------------------------------

            SizedBox(
              width: 30,
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: completed || current
                          ? _statusColor(status)
                          : const Color(0xFFE9EDF2),
                    ),

                    child: completed
                        ? const Icon(
                      Icons.check_rounded,
                      size: 15,
                      color: Colors.white,
                    )
                        : current
                        ? const Icon(
                      Icons.circle,
                      size: 8,
                      color: Colors.white,
                    )
                        : null,
                  ),

                  if (!last)
                    Container(
                      width: 2,
                      height: 30,
                      color: completed
                          ? _statusColor(status)
                          : const Color(0xFFE2E6EB),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ---------------------------------------------
            // LABEL — comes straight from tracking.steps[i].label
            // ---------------------------------------------

            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2, bottom: 16),
                child: Text(
                  step.label ?? "",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: current || completed
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: current
                        ? const Color(0xFF172033)
                        : completed
                        ? const Color(0xFF596273)
                        : const Color(0xFF9AA3B1),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }


  // ==========================================================
  // INQUIRY DETAILS CARD
  // ==========================================================

  Widget _buildModernProductCard(EnquiryDetails d) {
    return _modernSection(
      icon: Icons.home_work_outlined,
      title: "Quotation Details",
      child: Column(
        children: [
          _detailRow(Icons.category_outlined, "Category", d.categoryName),
          _detailRow(Icons.inventory_2_outlined, "Brand", d.brandName),
          _detailRow(
            Icons.shopping_cart_outlined,
            "Requested Qty",
            _stringValue(d.orderQuantity),
          ),

          if (!widget.isVendor)
            _detailRow(
              Icons.check_circle_outline,
              "Approved Qty",
              _stringValue(d.approvedQuantity),
            ),

          _detailRow(
            Icons.priority_high_rounded,
            "Urgency",
            d.requirmentUrgency,
          ),
          _detailRow(Icons.location_on_outlined, "Location", d.location),
          _detailRow(
            Icons.calendar_today_outlined,
            "Created At",
            d.createdAt,
            showDivider: false,
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // VENDOR CARD
  // ==========================================================

  Widget _buildModernVendorCard(EnquiryDetails d) {
    return _modernSection(
      icon: Icons.storefront_outlined,
      title: "Quotation To",
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Color(0xFFEAF3FF)),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.engineering_rounded,
                  color: Color(0xFF003B73),
                  size: 27,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      d.vendorName ?? "Contractor",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF172033),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Code: ${d.vendorCode ?? "-"}",
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF8992A1),
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Color(0xFFEAF7EC)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "QUOTED",
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2E7D32),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: AppTheme.surface(context, Color(0xFFF7F9FC)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Price / Quantity",
                    style: TextStyle(fontSize: 12, color: Color(0xFF687386)),
                  ),
                ),
                Text(
                  "₹ ${_formatAmount(d.pricePerQuantity)}",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF003B73),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // PRICE BREAKDOWN
  // ==========================================================

  Widget _buildModernPriceCard(
      EnquiryDetails details,
      int quantity,
      double pricePerQty,
      double transport,
      double subTotal,
      double total,
      ) {

    return _modernSection(
      icon: Icons.receipt_long_outlined,
      title: "Quotation Breakdown",
      child: Column(
        children: [
          _amountRow("Approved Quantity", quantity.toString()),
          _amountRow(
            "Price / Quantity",
            "₹ ${pricePerQty.toStringAsFixed(2)}",
          ),
          _amountRow("Subtotal", "₹ ${subTotal.toStringAsFixed(2)}"),
          _amountRow("Transport", "₹ ${transport.toStringAsFixed(2)}"),

          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surface(context, Color(0xFFEAF3FF)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "Total Amount",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF003B73),
                    ),
                  ),
                ),
                Text(
                  "₹ ${NumberFormat('#,##,##0.00', 'en_IN').format(total)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF003B73),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // COMMENT CARD
  // ==========================================================

  Widget _buildModernCommentCard(EnquiryDetails d) {
    return _modernSection(
      icon: Icons.chat_bubble_outline_rounded,
      title: "Contractor Message",
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppTheme.surface(context, Color(0xFFF7F9FC)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppTheme.surface(context, Color(0xFFEAF3FF)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.format_quote_rounded,
                size: 18,
                color: Color(0xFF003B73),
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                d.vendorComments ?? "-",
                style: const TextStyle(
                  fontSize: 12.5,
                  height: 1.45,
                  color: Color(0xFF596273),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ==========================================================
  // BOTTOM PAYMENT BAR
  // ==========================================================

  Widget? _buildBottomBar(EnquiryDetails details) {

    if (!_canShowPayNow(details)) {
      return null;
    }

    final int quantity = _toInt(details.approvedQuantity);
    final double price = _toDouble(details.pricePerQuantity);
    final double transport = _toDouble(details.transportPrice);
    final double total = (quantity * price) + transport;

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),

      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Payable Amount",
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF8992A1)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "₹ ${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF003B73),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _startPayment(details, total);
                },
                icon: const Icon(Icons.lock_outline_rounded, size: 17),
                label: const Text("Pay Now"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003B73),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(0, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(11),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ==========================================================
  // PAYMENT
  // ==========================================================

  void _startPayment(EnquiryDetails details, double total) {
    paidAmount = total;

    ref
        .read(orderControllerProvider)
        .createOrder(context, total, details.sId ?? "")
        .then((response) {

      if (!mounted) return;

      if (response.isSuccess) {
        final orderId = ref.read(orderControllerProvider).orderNumber;
        final rzKey = ref.read(orderControllerProvider).rzKey;

        razorpayPayment(orderId, total, rzKey, details);
      }
    });
  }


  razorpayPayment(
      String orderid, num amount, String rzkey, EnquiryDetails details) async {
    vendorName = details.vendorName ?? "";
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

  void _resetUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    Utills.customPrint('PaymentFailureResponse ${response.message}');
    _resetUI();
    CustomToast.displayErrorToast(content: "Payment failed");
    Navigation.pop(context);
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    _resetUI();

    Utills.customPrint('PaymentSuccessResponse ${response.data}');
    CustomToast.displaySuccessToast(content: "We have received your payment.");

    ref
        .read(orderControllerProvider)
        .paymentStatusUpdate(
        context, response.paymentId.toString(), 1, "Success")
        .then((response) {
      if (response.isSuccess) {
        Utills.customPrint('PaymentSuccessResponse ${response}');

        CustomToast.displaySuccessToast(content: response.message);
        var orderno = ref.read(orderControllerProvider).orderNumber;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => OrderSuccess(
                orderNo: orderno,
                orderAmount: paidAmount,
                totalAmount: paidAmount,
                propertyName: vendorName,
                propertyId: widget.inquiryId,
              )),
        );
      } else {
        CustomToast.displayErrorToast(content: "Payment failed try again");
      }
    });
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    _resetUI();
  }


  // ==========================================================
  // COMMON SECTION
  // ==========================================================

  Widget _modernSection({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E9EF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Color(0xFFEAF3FF)),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: const Color(0xFF003B73),
                ),
              ),
              const SizedBox(width: 9),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF172033),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }


  // ==========================================================
  // DETAIL ROW
  // ==========================================================

  Widget _detailRow(
      IconData icon,
      String label,
      dynamic value, {
        bool showDivider = true,
      }) {

    final String text = _stringValue(value);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: showDivider
          ? const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xFFECEFF3)),
        ),
      )
          : null,

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF003B73)),
          const SizedBox(width: 10),
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF8992A1)),
            ),
          ),
          Expanded(
            child: Text(
              text.isNotEmpty ? text : "-",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF293242),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // AMOUNT ROW
  // ==========================================================

  Widget _amountRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Color(0xFF687386)),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF293242),
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // STATUS TEXT RESOLUTION — replaces the old static switch-cases
  // Pulls from the API `messages` map, role-aware (vendor/customer).
  // ==========================================================

  /// Short status label (e.g. what used to come from `_statusTitle`).
  String _resolveStatusText(int status, Map<String, StatusMessage>? messages) {
    final StatusMessage? msg = messages?[status.toString()];

    if (msg == null) return "Quotation in progress";

    if (widget.isVendor) {
      return msg.vendor ?? msg.admin ?? "Quotation in progress";
    }
    return msg.customer ?? msg.admin ?? "Quotation in progress";
  }

  /// Longer status description (replaces the old static `_statusDescription`).
  /// Falls back to the admin message, then a generic sentence, if the
  /// role-specific text isn't present for that status.
  String _resolveStatusDescription(
      int status, Map<String, StatusMessage>? messages) {

    final StatusMessage? msg = messages?[status.toString()];

    if (msg == null) {
      return "Your inquiry is currently being processed.";
    }

    final String? roleText = widget.isVendor ? msg.vendor : msg.customer;

    return roleText ?? msg.admin ?? "Your inquiry is currently being processed.";
  }


  // ==========================================================
  // STATUS COLOR  (cosmetic mapping — kept, since the API doesn't
  // send colors/icons; only labels/descriptions came from the API)
  // ==========================================================

  Color _statusColor(int status) {
    switch (status) {
      case 1:
        return const Color(0xFF1976D2);
      case 2:
        return const Color(0xFFE88900);
      case 3:
        return const Color(0xFF7B61FF);
      case 4:
        return const Color(0xFF00897B);
      case 5:
        return const Color(0xFF2E7D32);
      case 6:
        return const Color(0xFF2E7D32);
      case 99:
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF607D8B);
    }
  }


  // ==========================================================
  // STATUS BACKGROUND
  // ==========================================================

  Color _statusBackground(int status) {
    switch (status) {
      case 1:
        return const Color(0xFFEAF3FF);
      case 2:
        return const Color(0xFFFFF5E5);
      case 3:
        return const Color(0xFFF1EDFF);
      case 4:
        return const Color(0xFFE8F7F4);
      case 5:
        return const Color(0xFFEAF7EC);
      case 6:
        return const Color(0xFFEAF7EC);
      case 99:
        return const Color(0xFFFFF1F1);
      default:
        return const Color(0xFFF1F3F5);
    }
  }


  // ==========================================================
  // STATUS ICON
  // ==========================================================

  IconData _statusIcon(int status) {
    switch (status) {
      case 1:
        return Icons.send_rounded;
      case 2:
        return Icons.request_quote_rounded;
      case 3:
        return Icons.check_circle_outline_rounded;
      case 4:
        return Icons.payments_outlined;
      case 5:
        return Icons.task_alt_rounded;
      case 6:
        return Icons.local_shipping_outlined;
      case 99:
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline_rounded;
    }
  }


  // ==========================================================
  // PERMISSION / STATUS CONDITIONS
  // ==========================================================

  bool _canAddQuote(EnquiryDetails d) {
    return widget.isVendor && d.status == 2;
  }

  bool _canShowVendorDetails(EnquiryDetails d) {
    return !widget.isVendor;
  }

  bool _canShowVendorPriceBreakdown(EnquiryDetails d) {
    return widget.isVendor && (d.status ?? 0) > 4;
  }

  bool _canShowCustomerPriceBreakdown(EnquiryDetails d) {
    return !widget.isVendor && (d.status ?? 0) == 4;
  }

  bool _canShowCustomerPrice(EnquiryDetails d) {
    return !widget.isVendor && (d.status ?? 0) == 4;
  }

  bool _canShowPayNow(EnquiryDetails d) {
    return !widget.isVendor && (d.status ?? 0) == 4;
  }


  // ==========================================================
  // ERROR STATE
  // ==========================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                color: AppTheme.surface(context, Color(0xFFFFF1F1)),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_off_rounded,
                color: Color(0xFFE53935),
                size: 34,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Unable to load inquiry",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),

            const SizedBox(height: 6),

            const Text(
              "Please check your connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF7B8492)),
            ),

            const SizedBox(height: 18),

            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(vendorDetailProvider.notifier)
                    .getContractorEnquiryDetailsData(widget.inquiryId);
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003B73),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ==========================================================
  // EMPTY STATE
  // ==========================================================

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 60,
            color: Color(0xFFB7BEC8),
          ),
          SizedBox(height: 12),
          Text(
            "No inquiry details found",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF596273),
            ),
          ),
        ],
      ),
    );
  }


  // ==========================================================
  // SAFE NUMBER PARSING
  // ==========================================================

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  String _stringValue(dynamic value) {
    if (value == null) return "";
    return value.toString();
  }

  String _formatAmount(dynamic value) {
    final double amount = _toDouble(value);
    return amount.toStringAsFixed(2);
  }
}