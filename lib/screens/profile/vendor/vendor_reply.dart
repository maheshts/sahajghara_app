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

  double get quantity =>
      double.tryParse(qtyController.text) ?? 0.0;

  double get price =>
      double.tryParse(priceController.text) ?? 0;


  double get transportcharge =>
      double.tryParse(transportController.text) ?? 0;

  double get total {
    double base = price * quantity;
    //double gstAmount = base * gst / 100;
    return base + transportcharge;
  }

  final _formKey = GlobalKey<FormState>();


  @override
  initState() {
    super.initState();
    // priceController.text = widget.details.pricePerQuantity ?? "";
    qtyController.text = widget.details.orderQuantity.toString() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final quotationState = ref.watch(vendorQuotationProvider);

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        appBar: AppBar(title: const Text("Send Quotation")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _buildCard(
                    title: "Product Details",
                    children: [
                      _infoRow("Category", widget.details.categoryName),
                      _infoRow("Brand", widget.details.brandName),
                      _infoRow("Requested Qty",
                          widget.details.orderQuantity.toString()),
                    ],
                  ),

                  const SizedBox(height: 15),

                  /// PRICE
                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Price per Unit",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter price";
                      }
                      if (double.tryParse(value) == null) {
                        return "Invalid number";
                      }
                      if (double.parse(value) <= 0) {
                        return "Price must be greater than 0";
                      }
                      return null;
                    },
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 10),

                  /// QUANTITY
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.number,
                    decoration:
                    const InputDecoration(labelText: "Quantity"),
                    onChanged: (_) => setState(() {}),
                  ),

                  const SizedBox(height: 10),

                  /// TRANSPORT CHECKBOX
                  Row(
                    children: [
                      Checkbox(
                        value: isTransportAdded,
                        onChanged: (value) {
                          setState(() {
                            isTransportAdded = value!;
                            if (!isTransportAdded) {
                              transportController.clear();
                            }
                          });
                        },
                      ),
                      const Text("Transport Applicable"),
                    ],
                  ),

                  if (isTransportAdded) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: transportController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Transport Charge",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ],

                  const SizedBox(height: 10),

                  /// NOTE
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    decoration:
                    const InputDecoration(labelText: "Comment/Note"),
                  ),

                  const SizedBox(height: 20),

                  /// TOTAL CARD
                  Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total Amount",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold)),
                          Text(
                            "₹${total.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ACTION BUTTONS
                  Row(
                    children: [
                      // Expanded(
                      //   child: OutlinedButton(
                      //     onPressed: () {},
                      //     child: const Text("Reject"),
                      //   ),
                      // ),
                      // const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: quotationState.isLoading
                              ? null
                              : () async {
                            if (qtyController.text.isEmpty) {
                              CustomToast.displayWarningToast(
                                  content: "Enter quantity");
                              return;
                            } else if (priceController.text.isEmpty) {
                              CustomToast.displayWarningToast(
                                  content: "Enter price per quantity");
                              return;
                            } else if (isTransportAdded && transportcharge == 0) {
                              CustomToast.displayWarningToast(
                                  content: "Enter transport charge");
                              return;
                            }
else {
                              final body = {
                                "_id": widget.inquiryId,
                                "status": 3,
                                "price_per_quantity": price.toString(),
                                "transport_applicable":
                                isTransportAdded ? "yes" : "no",
                                "transport_price": "${isTransportAdded
                                    ? transportcharge.toString()
                                    : "0"}",
                                "transport_service":
                                isTransportAdded
                                    ? "Vendor"
                                    : "Sahaja",
                                "approved_quantity": quantity.toString(),
                                "total": total,
                                "vendor_comments":
                                noteController.text,
                              };

                              await ref
                                  .read(vendorQuotationProvider.notifier)
                                  .addVendorQuotation(body).then((response) {
                                if (response.isSuccess) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text(
                                        "Quotation sent successfully")),
                                  );
                                  Navigator.pop(context, true);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(response.message)),
                                  );
                                }
                              });
                            }
                          },

                          child: quotationState.isLoading
                              ? const CircularProgressIndicator(
                              color: Colors.white)
                              : const Text("Send Quote"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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