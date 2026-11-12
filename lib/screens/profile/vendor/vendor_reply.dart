import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/helpers/custom_toast.dart';

import '../../vendor/EnquiryDetailResponse.dart';
import '../../vendor/provider/update_controller.dart';

class VendorReplyScreen extends ConsumerStatefulWidget {
  final String inquiryId;
  final EnquiryDetails details;

  const VendorReplyScreen(
      {super.key, required this.inquiryId, required this.details});


  @override
  ConsumerState<VendorReplyScreen> createState() =>
      _VendorReplyScreenState();
}
class _VendorReplyScreenState extends ConsumerState<VendorReplyScreen> {
  final priceController = TextEditingController();
  final qtyController = TextEditingController();
  final deliveryController = TextEditingController();
  final noteController = TextEditingController();

  bool isTransportAdded = false;
  final transportController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  double get quantity =>
      double.tryParse(qtyController.text) ?? 0.0;

  double get price =>
      double.tryParse(priceController.text) ?? 0.0;

  double get transportcharge =>
      double.tryParse(transportController.text) ?? 0.0;

  double get total {
    final base = price * quantity;
    return base + transportcharge;
  }

  @override
  void initState() {
    super.initState();

    qtyController.text =
        widget.details.orderQuantity?.toString() ?? "";
  }

  @override
  void dispose() {
    priceController.dispose();
    qtyController.dispose();
    deliveryController.dispose();
    noteController.dispose();
    transportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quotationState = ref.watch(vendorQuotationProvider);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: AppTheme.surface(context, Color(0xFFF5F7FA)),

        // ---------------------------------------------------------
        // APP BAR
        // ---------------------------------------------------------
        appBar: AppBar(
          elevation: 0,
          backgroundColor: const Color(0xFF003B73),
          foregroundColor: Colors.white,
          centerTitle: false,
          titleSpacing: 16,
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Send Quotation",
                style: TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Prepare your best offer",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // =====================================================
                // QUOTATION HEADER
                // =====================================================
                _buildQuotationHeader(),

                const SizedBox(height: 18),

                // =====================================================
                // PRODUCT DETAILS
                // =====================================================
                _buildProductSection(),

                const SizedBox(height: 18),

                // =====================================================
                // PRICING
                // =====================================================
                _buildSectionTitle(
                  icon: Icons.payments_outlined,
                  title: "Pricing",
                  subtitle: "Set your quotation amount",
                ),

                const SizedBox(height: 10),

                _buildPricingCard(),

                const SizedBox(height: 18),

                // =====================================================
                // TRANSPORT
                // =====================================================
                _buildSectionTitle(
                  icon: Icons.local_shipping_outlined,
                  title: "Transport",
                  subtitle: "Add transportation charges if applicable",
                ),

                const SizedBox(height: 10),

                _buildTransportCard(),

                const SizedBox(height: 18),

                // =====================================================
                // NOTE
                // =====================================================
                _buildSectionTitle(
                  icon: Icons.notes_outlined,
                  title: "Additional Note",
                  subtitle: "Add any message for the customer",
                ),

                const SizedBox(height: 10),

                _buildNoteCard(),

                const SizedBox(height: 20),

                // =====================================================
                // TOTAL
                // =====================================================
                _buildTotalCard(),
              ],
            ),
          ),
        ),

        // ===========================================================
        // BOTTOM ACTION
        // ===========================================================
        bottomNavigationBar: _buildBottomAction(quotationState),
      ),
    );
  }

  // ===============================================================
  // QUOTATION HEADER
  // ===============================================================

  Widget _buildQuotationHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF003B73),
            Color(0xFF005A9C),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003B73).withOpacity(.18),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppTheme.surface(context, Colors.white).withOpacity(.14),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Create Quotation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Submit your pricing for this inquiry",
                  style: TextStyle(
                    color: Colors.white.withOpacity(.78),
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // PRODUCT SECTION
  // ===============================================================

  Widget _buildProductSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE7EBF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.035),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Color(0xFFEAF3FF)),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.inventory_2_outlined,
                  color: Color(0xFF003B73),
                  size: 21,
                ),
              ),

              const SizedBox(width: 11),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Inquiry Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF17202A),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Requested product information",
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF7A8490),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _buildProductInfo(
                  icon: Icons.category_outlined,
                  label: "Category",
                  value: widget.details.categoryName,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _buildProductInfo(
                  icon: Icons.branding_watermark_outlined,
                  label: "Brand",
                  value: widget.details.brandName,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          _buildProductInfo(
            icon: Icons.shopping_cart_outlined,
            label: "Requested Quantity",
            value: widget.details.orderQuantity?.toString() ?? "-",
            fullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildProductInfo({
    required IconData icon,
    required String label,
    required String? value,
    bool fullWidth = false,
  }) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Color(0xFFF7F9FC)),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: const Color(0xFFE8ECF1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF52708D),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF87919D),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value?.isNotEmpty == true ? value! : "-",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF202A34),
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

  // ===============================================================
  // SECTION TITLE
  // ===============================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            color: AppTheme.surface(context, Color(0xFFEAF3FF)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 19,
            color: const Color(0xFF003B73),
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF17202A),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF89939F),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // PRICING CARD
  // ===============================================================

  Widget _buildPricingCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [

          Expanded(
            child: _buildInputField(
              controller: priceController,
              label: "Price / Unit",
              hint: "Enter price",
              icon: Icons.currency_rupee,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Enter price";
                }

                if (double.tryParse(value) == null) {
                  return "Invalid";
                }

                if (double.parse(value) <= 0) {
                  return "Invalid";
                }

                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: _buildInputField(
              controller: qtyController,
              label: "Quantity",
              hint: "Enter quantity",
              icon: Icons.numbers_rounded,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  // ===============================================================
  // INPUT FIELD
  // ===============================================================

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required TextInputType keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(
          icon,
          size: 19,
          color: const Color(0xFF52708D),
        ),
        filled: true,
        fillColor: AppTheme.surface(context, Color(0xFFF8FAFC)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        labelStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFF77818D),
        ),
        hintStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFFB0B7C0),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE4E9EF),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE4E9EF),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFF003B73),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // TRANSPORT CARD
  // ===============================================================

  Widget _buildTransportCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isTransportAdded
            ? const Color(0xFFF1F8F4)
            : Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: isTransportAdded
              ? const Color(0xFFB8DEC7)
              : const Color(0xFFE5EAF0),
        ),
      ),
      child: Column(
        children: [

          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: isTransportAdded
                      ? const Color(0xFFDDF3E5)
                      : const Color(0xFFF1F4F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.local_shipping_outlined,
                  color: isTransportAdded
                      ? const Color(0xFF21864A)
                      : const Color(0xFF607080),
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transport Charges",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF202A34),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Include delivery/transportation cost",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF87919D),
                      ),
                    ),
                  ],
                ),
              ),

              Switch(
                value: isTransportAdded,
                activeColor: const Color(0xFF21864A),
                onChanged: (value) {
                  setState(() {
                    isTransportAdded = value;

                    if (!isTransportAdded) {
                      transportController.clear();
                    }
                  });
                },
              ),
            ],
          ),

          if (isTransportAdded) ...[
            const SizedBox(height: 14),

            _buildInputField(
              controller: transportController,
              label: "Transport Charge",
              hint: "Enter transport amount",
              icon: Icons.local_shipping_outlined,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
    );
  }

  // ===============================================================
  // NOTE CARD
  // ===============================================================

  Widget _buildNoteCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: TextField(
        controller: noteController,
        maxLines: 4,
        style: const TextStyle(
          fontSize: 13,
          height: 1.4,
        ),
        decoration: InputDecoration(
          hintText: "Write a message for the customer...",
          hintStyle: const TextStyle(
            color: Color(0xFFA0A8B2),
            fontSize: 12,
          ),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(
              left: 12,
              right: 8,
              top: 12,
            ),
            child: Icon(
              Icons.edit_note_rounded,
              color: Color(0xFF52708D),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 42,
            minHeight: 42,
          ),
          filled: true,
          fillColor: AppTheme.surface(context, Color(0xFFF8FAFC)),
          contentPadding: const EdgeInsets.all(13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // TOTAL CARD
  // ===============================================================

  Widget _buildTotalCard() {
    final baseAmount = price * quantity;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppTheme.gradient(context, [
            Color(0xFFEAF8F0),
            Color(0xFFF7FCF9),
          ]),
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFCBE8D6),
        ),
      ),
      child: Column(
        children: [

          Row(
            children: [
              Container(
                height: 44,
                width: 44,
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Color(0xFFD8F1E2)),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Color(0xFF21864A),
                  size: 23,
                ),
              ),

              const SizedBox(width: 12),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quotation Total",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C3325),
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "Final amount payable",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF708277),
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                "₹${total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF178344),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            height: 1,
            color: AppTheme.surface(context, Color(0xFFD8EBDD)),
          ),

          const SizedBox(height: 13),

          _buildAmountRow(
            "Product Amount",
            "₹${baseAmount.toStringAsFixed(2)}",
          ),

          if (isTransportAdded) ...[
            const SizedBox(height: 8),
            _buildAmountRow(
              "Transport",
              "₹${transportcharge.toStringAsFixed(2)}",
            ),
          ],

          const SizedBox(height: 8),

          _buildAmountRow(
            "Total",
            "₹${total.toStringAsFixed(2)}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(
      String title,
      String amount, {
        bool isTotal = false,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 13 : 12,
            fontWeight:
            isTotal ? FontWeight.w700 : FontWeight.w500,
            color: isTotal
                ? const Color(0xFF1C3325)
                : const Color(0xFF6F7B73),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 14 : 12,
            fontWeight:
            isTotal ? FontWeight.w800 : FontWeight.w600,
            color: isTotal
                ? const Color(0xFF178344)
                : const Color(0xFF46534A),
          ),
        ),
      ],
    );
  }

  // ===============================================================
  // BOTTOM ACTION
  // ===============================================================

  Widget _buildBottomAction(dynamic quotationState) {
    final isLoading = quotationState.isLoading;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        14,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.10),
            blurRadius: 18,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 54,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _sendQuotation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003B73),
              disabledBackgroundColor:
              const Color(0xFFE3FFE8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: isLoading
                ? const SizedBox(
              height: 23,
              width: 23,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
                : const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.send_rounded,
                  size: 20,
                  color: Colors.white60,
                ),
                SizedBox(width: 9),
                Text(
                  "Send Quotation",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ===============================================================
  // SEND QUOTATION
  // ===============================================================

  Future<void> _sendQuotation() async {
    if (qtyController.text.trim().isEmpty) {
      CustomToast.displayWarningToast(
        content: "Enter quantity",
      );
      return;
    }

    if (priceController.text.trim().isEmpty) {
      CustomToast.displayWarningToast(
        content: "Enter price per quantity",
      );
      return;
    }

    if (double.tryParse(qtyController.text) == null ||
        quantity <= 0) {
      CustomToast.displayWarningToast(
        content: "Enter valid quantity",
      );
      return;
    }

    if (double.tryParse(priceController.text) == null ||
        price <= 0) {
      CustomToast.displayWarningToast(
        content: "Enter valid price",
      );
      return;
    }

    if (isTransportAdded) {
      if (transportController.text.trim().isEmpty ||
          transportcharge <= 0) {
        CustomToast.displayWarningToast(
          content: "Enter transport charge",
        );
        return;
      }
    }

    final body = {
      "_id": widget.inquiryId,
      "status": 3,
      "price_per_quantity": price.toString(),
      "transport_applicable":
      isTransportAdded ? "yes" : "no",
      "transport_price": isTransportAdded
          ? transportcharge.toString()
          : "0",
      "transport_service":
      isTransportAdded ? "Vendor" : "Sahaja",
      "approved_quantity": quantity.toString(),
      "total": total,
      "vendor_comments": noteController.text,
    };

    await ref
        .read(vendorQuotationProvider.notifier)
        .addVendorQuotation(body)
        .then((response) {
      if (!mounted) return;

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              "Quotation sent successfully",
            ),
          ),
        );

        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(response.message),
          ),
        );
      }
    });
  }

  // ===============================================================
  // COMMON DECORATION
  // ===============================================================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppTheme.surface(context, Colors.white),
      borderRadius: BorderRadius.circular(17),
      border: Border.all(
        color: const Color(0xFFE5EAF0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.035),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    );
  }
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