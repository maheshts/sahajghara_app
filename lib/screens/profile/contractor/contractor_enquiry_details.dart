import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/helpers/CommonResponse.dart';
import 'package:sahajghara/helpers/custom_toast.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_reply.dart';
import 'package:sahajghara/screens/vendor/EnquiryDetailResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../helpers/utillls.dart';
import '../../../nwdata/api/api_contants.dart';
import '../../vendor/provider/update_controller.dart';
import '../../vendor/provider/vendro_detail_controller.dart';

class ContractorEnquiryDetails extends ConsumerStatefulWidget {
  final String inquiryId;
  final bool isVendor;


  const ContractorEnquiryDetails({super.key, required this.inquiryId,required this.isVendor});

  @override
  ConsumerState<ContractorEnquiryDetails> createState() =>
      _VendorEnquiryDetailsState();
}

class _VendorEnquiryDetailsState extends ConsumerState<ContractorEnquiryDetails> {

  late EnquiryDetails details;
  String cid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref
          .read(vendorDetailProvider.notifier)
          .getContractorEnquiryDetailsData(widget.inquiryId);
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vendorDetailProvider);

    return SafeArea(
      top: false,
      child: state.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, _) => const Scaffold(
          body: Center(child: Text("Something went wrong")),
        ),
        data: (data) {
          if (data == null) {
            return const Scaffold(
              body: Center(child: Text("No Data Found")),
            );
          }

          final EnquiryDetails details = data.data as EnquiryDetails;

          return Scaffold(
            appBar: _buildAppBar1(context, details),
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
      !widget.isVendor && (d.status ?? 0) == 3;



////////////////////////////////////////////////////////////
  /// 🔹 APP BAR
////////////////////////////////////////////////////////////

  PreferredSizeWidget _buildAppBar(EnquiryDetails details) {
    return AppBar(
      title:  Text("#${details.code}",style: nunitoItalic14,),
      actions: [
        if (_canAddQuote(details))
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () async {
                var result = await Navigator.push(
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
              child: Chip(
                label: Text(
                  "Add Quote",
                  style: TextStyle(
                    color: AppTheme.accent(context, AppColors.primary),
                    fontSize: 14,
                  ),
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
  //  if (!_canShowPayNow(details)) return null;
    if (!_canAddQuote(details)) return null;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFBEC0C4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          // Pay Now Logic
        },
        child: const Text("Pay Now"),
      ),
    );
  }

  Widget? _buildBottomBar(EnquiryDetails details) {
    if (!_canAddQuote(details)) return null;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [

          /// Reject Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Reject Logic
              },
              child: const Text("Reject"),
            ),
          ),

          const SizedBox(width: 12),

          /// Accept Button
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                // Accept Logic
              },
              child: const Text("Accept"),
            ),
          ),
        ],
      ),
    );
  }
////////////////////////////////////////////////////////////
  /// 🔹 BODY
////////////////////////////////////////////////////////////
  Widget _buildBody(EnquiryDetails details) {
    final int quantity = details.approvedQuantity ?? 0;
    final double pricePerQty = details.pricePerQuantity ?? 0;
    final double transport = details.transportPrice ?? 0;

    final double subTotal = quantity * pricePerQty;
    final double total = subTotal + transport;
    cid = details.sId!;

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(vendorDetailProvider.notifier)
            .getContractorEnquiryDetailsData(widget.inquiryId);
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ============================================================
            // PROJECT HEADER
            // ============================================================

            _buildProjectHeader(details),

            const SizedBox(height: 14),

            // ============================================================
            // STATUS
            // ============================================================

            Row(
              children: [
                const Text(
                  "Inquiry Status",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF334155),
                  ),
                ),
                const Spacer(),
                _buildStatusBadge(context, details.statusMessage),
              ],
            ),

            const SizedBox(height: 14),

            // ============================================================
            // PROJECT DETAILS
            // ============================================================

            _buildProjectDetailsCard(details),

            const SizedBox(height: 12),

            // ============================================================
            // PERSON DETAILS
            // ============================================================

            _buildPersonCard(details),

            // ============================================================
            // COMMENTS
            // ============================================================

            if ((details.adminComments ?? "").isNotEmpty ||
                (details.vendorComments ?? "").isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildCommentsCard(details),
            ],

            // ============================================================
            // PRICE
            // ============================================================

            if (_canShowVendorPriceBreakdown(details) ||
                _canShowCustomerPriceBreakdown(details)) ...[
              const SizedBox(height: 12),
              _buildPriceSection(
                details.pricePerQuantity,
                details.transportApplicable.toString(),
                details.transportPrice ?? 0,
                total,
              ),
            ],

            const SizedBox(height: 18),

            // ============================================================
            // RATE US
            // ============================================================

            widget.isVendor? SizedBox():_buildRateUsButton(),

            const SizedBox(height: 15),

            // ============================================================
            // CONFIRM ORDER
            // ============================================================

            // if (_canShowCustomerPrice(details))
            //   _buildConfirmOrderButton(),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectHeader(EnquiryDetails details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
            Color(0xFF42A5F5),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withOpacity(0.20),
            blurRadius: 14,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Colors.white).withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.home_work_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Text(
                      "House Construction Inquiry",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "#${details.code ?? "-"}",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.80),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Text(
            details.projectType ?? "Construction Project",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 5),

          Row(
            children: [

              const Icon(
                Icons.location_on_rounded,
                color: Colors.white70,
                size: 16,
              ),

              const SizedBox(width: 4),

              Expanded(
                child: Text(
                  details.location ?? "-",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProjectDetailsCard(EnquiryDetails details) {
    return _buildModernCard(
      title: "Project Details",
      icon: Icons.architecture_rounded,
      children: [

        Row(
          children: [

            Expanded(
              child: _buildDetailTile(
                icon: Icons.category_outlined,
                title: "Project Type",
                value: details.projectType?.toString() ?? "-",
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _buildDetailTile(
                icon: Icons.straighten_rounded,
                title: "Project Size",
                value: "${details.projectSize ?? "-"} Feet",
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        _buildLocationTile(details.location),
      ],
    );
  }

  Widget _buildDetailTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Color(0xFFF4F8FC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: AppTheme.accent(context, AppColors.primary),
            size: 20,
          ),

          const SizedBox(height: 8),

          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.muted(context, Colors.grey.shade600),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: AppTheme.foreground(context, Color(0xFF172B4D)),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLocationTile(String? location) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Color(0xFFFFF8ED)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE7BE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: Color(0xFFE88A00),
              size: 20,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Project Location",
                  style: TextStyle(
                    fontSize: 10,
                    color: AppTheme.muted(context, Colors.grey.shade600),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  location ?? "-",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF263238),
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
  Widget _buildPersonCard(EnquiryDetails details) {
    final bool showCustomer = widget.isVendor;

    final String name = showCustomer
        ? details.customerName?.toString() ?? "-"
        : details.contractorName?.toString() ?? "-";

    final String role = showCustomer
        ? "Customer Details"
        : "Contractor Details";

    final String phone = showCustomer? details.phone.toString() : details.contractorCode.toString();

    return _buildModernCard(
      title: role,
      icon: showCustomer
          ? Icons.person_outline_rounded
          : Icons.engineering_rounded,
      children: [

        Row(
          children: [

            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withOpacity(0.10),
              child: Icon(
                showCustomer
                    ? Icons.person_rounded
                    : Icons.engineering_rounded,
                color: AppTheme.accent(context, AppColors.primary),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.foreground(context, Color(0xFF172B4D)),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    role,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppTheme.muted(context, Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),

            if (details.status == 3)
              IconButton(
                onPressed: () {
                  // Call phone
                },
                icon: const Icon(
                  Icons.phone_rounded,
                  color: Colors.green,
                ),
              ),
          ],
        ),

        if (phone != "-") ...[
          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surface(context, Color(0xFFF6F8FA)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [

                Icon(
                  Icons.phone_outlined,
                  size: 17,
                  color: AppTheme.muted(context, Colors.grey.shade600),
                ),

                const SizedBox(width: 8),

                Text(
                  details.status == 3
                      ? phone
                      : maskPhone(phone),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
  Widget _buildModernCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5EAF0),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.accent(context, AppColors.primary),
                  size: 19,
                ),
              ),

              const SizedBox(width: 9),

              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.foreground(context, Color(0xFF172B4D)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          ...children,
        ],
      ),
    );
  }
  Widget _buildCommentsCard(EnquiryDetails details) {
    return _buildModernCard(
      title: "Communication",
      icon: Icons.chat_bubble_outline_rounded,
      children: [

        if ((details.adminComments ?? "").isNotEmpty)
          _buildCommentItem(
            title: "SahajGhara Team",
            comment: details.adminComments!,
            icon: Icons.support_agent_rounded,
          ),

        if ((details.adminComments ?? "").isNotEmpty &&
            (details.vendorComments ?? "").isNotEmpty)
          const SizedBox(height: 10),

        if ((details.vendorComments ?? "").isNotEmpty)
          _buildCommentItem(
            title: "Contractor",
            comment: details.vendorComments!,
            icon: Icons.engineering_rounded,
          ),
      ],
    );
  }
  Widget _buildCommentItem({
    required String title,
    required String comment,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Color(0xFFF7F9FC)),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            size: 19,
            color: AppTheme.accent(context, AppColors.primary),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.foreground(context, Color(0xFF172B4D)),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  comment,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.muted(context, Colors.grey.shade700),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildStatusBadge(BuildContext context, String? status) {
    final String value = (status ?? "Pending").toLowerCase();

    Color bgColor;
    Color textColor;
    IconData icon;

    if (value.contains("complete") ||
        value.contains("approved") ||
        value.contains("confirmed")) {
      bgColor = Colors.green.withOpacity(0.12);
      textColor = Colors.green.shade700;
      icon = Icons.check_circle_outline_rounded;
    } else if (value.contains("reject") ||
        value.contains("cancel")) {
      bgColor = Colors.red.withOpacity(0.12);
      textColor = Colors.red.shade700;
      icon = Icons.cancel_outlined;
    } else if (value.contains("progress")) {
      bgColor = Colors.blue.withOpacity(0.12);
      textColor = Colors.blue.shade700;
      icon = Icons.autorenew_rounded;
    } else {
      bgColor = Colors.orange.withOpacity(0.12);
      textColor = Colors.orange.shade800;
      icon = Icons.schedule_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          Icon(
            icon,
            size: 14,
            color: textColor,
          ),

          const SizedBox(width: 5),

          Text(
            (status ?? "Pending").toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateUsButton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFB300),
            Color(0xFFF57C00),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {
            _showRateUsDialog(context);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 13,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Icon(
                  Icons.star_rounded,
                  color: Colors.white,
                  size: 21,
                ),

                SizedBox(width: 8),

                Text(
                  "Rate Your Experience",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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
  void _showRateUsDialog(BuildContext context) {
    int contractorRating = 0;
    int serviceRating = 0;
    int overallRating = 0;

    final TextEditingController commentController =
    TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: AppTheme.surface(context, Colors.white),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // =====================================================
                    // HEADER
                    // =====================================================

                    Row(
                      children: [

                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.star_rounded,
                            color: Colors.orange,
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
                                "Rate Your Experience",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: AppTheme.foreground(context, Color(0xFF172B4D)),
                                ),
                              ),

                              SizedBox(height: 3),

                              Text(
                                "Your feedback helps us improve",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.muted(context, Colors.grey),
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // =====================================================
                    // RATING 1
                    // =====================================================

                    _ratingBar(context: context,
                      title: "Contractor Service",
                      subtitle: "How was the contractor service?",
                      rating: contractorRating,
                      onChanged: (value) {
                        setModalState(() {
                          contractorRating = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // =====================================================
                    // RATING 2
                    // =====================================================

                    _ratingBar(context: context,
                      title: "Timely Completion",
                      subtitle: "Was your project complete in time?",
                      rating: serviceRating,
                      onChanged: (value) {
                        setModalState(() {
                          serviceRating = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // =====================================================
                    // RATING 3
                    // =====================================================

                    _ratingBar(context: context,
                      title: "Overall Experience(Communication,Behaviour,Quality)",
                      subtitle: "How would you rate overall?",
                      rating: overallRating,
                      onChanged: (value) {
                        setModalState(() {
                          overallRating = value;
                        });
                      },
                    ),

                    const SizedBox(height: 20),

                    // =====================================================
                    // COMMENT
                    // =====================================================

                    Text(
                      "Comment",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.foreground(context, Color(0xFF172B4D)),
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Tell us about your experience...",
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                        filled: true,
                        fillColor: AppTheme.surface(context, Color(0xFFF6F8FA)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =====================================================
                    // SUBMIT
                    // =====================================================

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () async {

                          if (contractorRating == 0 ||
                              serviceRating == 0 ||
                              overallRating == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Please provide all ratings",
                                ),
                              ),
                            );
                            return;
                          }

                          // final ratingData = {
                          //   "inquiryId": widget.inquiryId,
                          //   "contractorRating": contractorRating,
                          //   "serviceRating": serviceRating,
                          //   "overallRating": overallRating,
                          //   "comment": commentController.text.trim(),
                          // };
                          SharedPreferences preferences = await SharedPreferences.getInstance();
                          String customerId = preferences.getString(APIConstants.userId) ?? "";

                          final dd = {
                            "contractor_id": cid,
                            "user_id": customerId,
                            "inquiry_id": widget.inquiryId,
                            "rating": 5,
                            "quality_of_work": contractorRating,
                            "timely_completion": serviceRating,
                            "communication": overallRating,
                            "comment": commentController.text.trim(),
                          };

                          debugPrint(
                            "RATING DATA: $dd",
                          );
                          final CommonResponse? result = await ref
                              .read(reviewSubmitProvider.notifier)
                              .submitReview(dd);

// Handle the result safely
                          if (result != null) {
                            if (result.isSuccess) {
                              // Action on success (e.g., Navigate back, clear form, show success toast)
                              Utills.customPrint("Success: ${result.message}");
                              Navigator.pop(context);
                              CustomToast.displaySuccessToast(content: "Thank you for your feedback!");


                            } else {
                              // Action on failure
                              Utills.customPrint("Failed: ${result.message}");
                              CustomToast.displayWarningToast(content: result.message ?? "Failed to submit review.");

                            }
                          }

                          // ScaffoldMessenger.of(this.context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text(
                          //       "Thank you for your feedback!",
                          //     ),
                          //   ),
                          // );
                        },
                        child: const Text(
                          "Submit Review",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }



////////////////////////////////////////////////////////////
  /// 🔹 SECTIONS
////////////////////////////////////////////////////////////
  String maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    return 'X' * (phone.length - 4) + phone.substring(phone.length - 4);
  }
  Widget _buildProductSection(EnquiryDetails item) {
    return _buildCard(
      title: "Product Details",
      children: [
        // _infoRow("Pro", d.categoryName),
        // _infoRow("Brand", d.brandName),
        // _infoRow("Requested Qty", d.orderQuantity.toString()),
        // if (!widget.isVendor)
        //   _infoRow("Approved Qty", "${d.approvedQuantity}"),
        // _infoRow("Urgency", d.requirmentUrgency),
        // _infoRow("Location", d.location),
        // _infoRow("Created At", d.createdAt),
        widget.isVendor == true ?   _infoRow("Name", item.customerName.toString()):SizedBox(),
        widget.isVendor == false? _infoRow("Contractor", item.contractorName.toString()):SizedBox(),
        item.status == 3?
        _infoRow("Phone", item.phone.toString()) : _infoRow("Phone", maskPhone(item.phone.toString())),
        _infoRow("Location", item.location.toString()),
        _infoRow("Project Size", item.projectSize.toString()+" Feet"),
        _infoRow("Project Type", item.projectType.toString()),
     item.adminComments != null && item.adminComments!.isNotEmpty?
     widget.isVendor == false?
           Column(children: [
             Text("From SahajGhara Team",style: nunitoItalic14,),
             Text(item.adminComments.toString(),style: nunitoItalic13,)
           ],) : SizedBox():Text(""),
    item.vendorComments != null && item.vendorComments!.isNotEmpty?
    widget.isVendor == false?
           Column(children: [
             Text("From Contractor",style: nunitoItalic14,),
             Text(item.vendorComments.toString(),style: nunitoItalic13,)
           ],) : SizedBox():SizedBox(),
      // _infoRow("SahajaGhar Team", item.adminComments.toString()):SizedBox(),
      //   widget.isVendor == false? _infoRow("Contractor", item.vendorComments.toString()):SizedBox(),

      ],
    );
  }

  Widget _buildVendorSection(EnquiryDetails d) {
    return _buildCard(
      title: "Vendor Details",
      children: [
        _infoRow("Vendor Name", d.vendorName),
        _infoRow("Vendor Code", d.vendorCode),
        _infoRow("Price / Qty", "₹ ${d.pricePerQuantity}"),
        // _infoRow("Transport Applicable",
        //     d.transportApplicable == "1" ? "Yes" : "No"),
        // _infoRow("Transport Service", d.transportService),
      ],
    );
  }

  Widget _buildPriceSection(
     double? qtyprice,String transportapplic, double transportprice, double total) {
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
}
Widget _ratingBar({required BuildContext context,
  required String title,
  required String subtitle,
  required int rating,
  required Function(int) onChanged,
}) {
  return Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: AppTheme.surface(context, Color(0xFFF7F9FC)),
      borderRadius: BorderRadius.circular(13),
      border: Border.all(
        color: const Color(0xFFE7EBF0),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppTheme.foreground(context, Color(0xFF172B4D)),
          ),
        ),

        const SizedBox(height: 3),

        Text(
          subtitle,
          style: TextStyle(
            fontSize: 10,
            color: AppTheme.muted(context, Colors.grey.shade600),
          ),
        ),

        const SizedBox(height: 9),

        Row(
          children: List.generate(5, (index) {
            final int starNumber = index + 1;

            return GestureDetector(
              onTap: () {
                onChanged(starNumber);
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  starNumber <= rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  size: 29,
                  color: starNumber <= rating
                      ? const Color(0xFFFFB300)
                      : Colors.grey.shade400,
                ),
              ),
            );
          }),
        ),
      ],
    ),
  );
}
PreferredSizeWidget _buildAppBar1(BuildContext context, EnquiryDetails details) {
  return AppBar(
    backgroundColor: AppTheme.surface(context, Colors.white),
    elevation: 0,
    iconTheme: IconThemeData(
      color: AppTheme.foreground(context, Color(0xFF172B4D)),
    ),
    titleSpacing: 0,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Inquiry Details",
          style: TextStyle(
            color: AppTheme.foreground(context, Color(0xFF172B4D)),
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          "#${details.code ?? "-"}",
          style: TextStyle(
            color: AppTheme.muted(context, Colors.grey.shade500),
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
    // actions: [
    //   if (_canAddQuote(details))
    //     Padding(
    //       padding: const EdgeInsets.only(right: 12),
    //       child: ElevatedButton.icon(
    //         style: ElevatedButton.styleFrom(
    //           backgroundColor: AppColors.primary.withOpacity(0.10),
    //           foregroundColor: AppColors.primary,
    //           elevation: 0,
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(10),
    //           ),
    //         ),
    //         onPressed: () async {
    //           final result = await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (_) => VendorReplyScreen(
    //                 inquiryId: widget.inquiryId,
    //                 details: details,
    //               ),
    //             ),
    //           );
    //
    //           if (result == true) {
    //             await ref
    //                 .read(vendorDetailProvider.notifier)
    //                 .getEnquiryDetail(widget.inquiryId);
    //           }
    //         },
    //         icon: const Icon(
    //           Icons.add_rounded,
    //           size: 17,
    //         ),
    //         label: const Text(
    //           "Add Quote",
    //           style: TextStyle(
    //             fontSize: 11,
    //             fontWeight: FontWeight.w800,
    //           ),
    //         ),
    //       ),
    //     ),
    // ],
  );
}
Widget _buildStatusBadge(BuildContext context, String? status) {
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
