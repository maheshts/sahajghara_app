import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_reply.dart';
import 'package:sahajghara/screens/vendor/EnquiryDetailResponse.dart';
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
                    color: AppColors.primary,
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

              // if (_canShowVendorDetails(details))
              //   _buildVendorSection(details),
              //
              // if (_canShowVendorPriceBreakdown(details) ||
              //     _canShowCustomerPriceBreakdown(details))
              //   _buildPriceSection(details.pricePerQuantity,details.transportApplicable.toString(), details.transportPrice!,total!),
              //
              // const SizedBox(height: 10),

              // _buildCommentSection(details),
              //
              // const SizedBox(height: 14),

             if(_canShowCustomerPrice(details))
               ElevatedButton(
                 style: ElevatedButton.styleFrom(
                   backgroundColor: AppColors.primary,
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10),
                   ),
                 ),
                onPressed: () async {

                  final body = {
                    "_id": widget.inquiryId,
                    "status": 5,
                  };
                  await ref
                      .read(vendorQuotationProvider.notifier)
                      .addVendorQuotation(body).then((response) {
                    if(response.isSuccess){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Quotation Confirmed Successfully")),
                      );
                      Navigator.pop(context,true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(response.message)),
                      );
                    }
                  });
                },
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDeep,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      ),
                      onPressed: () async {
                        final body = {
                          "_id": widget.inquiryId,
                          "status": 5,
                        };
                        await ref
                            .read(vendorQuotationProvider.notifier)
                            .addVendorQuotation(body).then((response) {
                          if(response.isSuccess){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Quotation Confirmed successfully")),
                            );
                            Navigator.pop(context,true);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(response.message)),
                            );
                          }
                        });

                  }, child: Text("Confirm Order",style: nunitoItalic14White))
                  //,
                ),
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
        _infoRow("Name", item.customerName.toString()),
        item.status == 3?
        _infoRow("Phone", item.phone.toString()) : _infoRow("Phone", maskPhone(item.phone.toString())),
        _infoRow("Location", item.location.toString()),
        _infoRow("Project Size", item.projectSize.toString()+" Feet"),
        _infoRow("Project Type", item.projectType.toString()),

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
            style: nunitoItalic15.copyWith(color: AppColors.primary),
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
Widget _buildStatusBadge(String? status) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 6,
    ),
    decoration: BoxDecoration(
      color: Colors.orange.shade100,
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
