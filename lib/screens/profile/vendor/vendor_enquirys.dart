import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/helpers/utillls.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_enquiry_details.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_quote_detail.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controllers/list_controller.dart';
import '../../../presentation/theme/app_colors.dart';
import '../../../presentation/theme/app_constants.dart';

class VendorEnquirys extends ConsumerStatefulWidget {
  final int itemStatus;
  const VendorEnquirys({super.key,required this.itemStatus});

  @override
  ConsumerState<VendorEnquirys> createState() => _VendorEnquirysState();
}

class _VendorEnquirysState extends  ConsumerState<VendorEnquirys> {
  final filterList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Utills.customPrint("start call");

      ref.read(listControllerProvider).getVendorMyEnquiryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var enquiryWatch = ref.watch(listControllerProvider);
   // final inquiryList = enquiryWatch.enquiryList;
    if(enquiryWatch.getEnquiryStatus == EnquiryListStatus.loaded){
        filterList.clear();
        // 1. Clear the filter list first to remove old data

        if (widget.itemStatus > 0) {
          // 2. Use .where() for a cleaner, more readable Dart syntax
          var matchedElements = enquiryWatch.enquiryList!
              .where((element) => element.status == widget.itemStatus);

          filterList.addAll(matchedElements);
        } else {
          // 3. This adds ALL items when itemStatus is 0 or less
          filterList.addAll(enquiryWatch.enquiryList!);
        }

        Utills.customPrint("filter list ${filterList.length}");
      // Utills.customPrint("enquiry list ${enquiryWatch.enquiryList!.length}");
      Utills.customPrint("item status ${widget.itemStatus}");
      // Utills.customPrint("enquiry list ${enquiryWatch.enquiryList![0].status}");
      // Utills.customPrint("enquiry list ${enquiryWatch.enquiryList![0].sId}");
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          "My Enquiry's",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        //c
        // enterTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        top: true,
        child: enquiryWatch.getEnquiryStatus == EnquiryListStatus.loading?
        _buildShimmerList():enquiryWatch.getEnquiryStatus == EnquiryListStatus.loaded?
        enquiryWatch.enquiryList!.isNotEmpty?
        ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filterList.length,
          itemBuilder: (context, index) {
            final inquiry =filterList[index];
            return InkWell(
              onTap: (){
                Utills.customPrint("click");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>VendorQuoteDetail(inquiryId: inquiry.sId.toString(),isVendor: true)));
              },
              child: Container(
              //  margin: const EdgeInsets.only(bottom: 12),
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF3F8FF),
                      Color(0xFFE4F0FF),
                      Color(0xFFD7E9FF),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFD1E3F5),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1565C0).withOpacity(0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
               // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                //elevation: 3,
                //shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// --- Header Row ---
                      Text(
                        "#${inquiry.code}",
                        style: nunitoItalic12White.copyWith(color: AppColors.primary, fontSize: 13),
                      ),
                      //Text("status: ${inquiry.status}"),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            inquiry.name ?? "",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          //   decoration: BoxDecoration(
                          //     color: _getStatusColor(inquiry.status ?? ""),
                          //     borderRadius: BorderRadius.circular(20),
                          //   ),
                          //   child: Text(
                          //     inquiry.status ?? "",
                          //     style: const TextStyle(
                          //       color: Colors.white,
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.w500,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),

                      const SizedBox(height: 8),
                      _infoRow("Category", inquiry.categoryName),
                      _infoRow("Brand", inquiry.brandName),
                      _infoRow("Quantity", inquiry.orderQuantity.toString()),
                      _infoRow("Location", inquiry.location),
                      _infoRow("Urgency", inquiry.requirmentUrgency),
                      _infoRow("Date", inquiry.createdAt),
                      _infoRow("Status", inquiry.statusMessage),

                    ],
                  ),
                ),
              ),
            );
          },
        ):Center(child: Text("No Enquiry Found",style: nunitoItalic16,)) :_buildErrorView(),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Color _getStatusColor(String status) {
  //   switch (status.toLowerCase()) {
  //     case "completed":
  //       return Colors.green.shade600;
  //     case "pending":
  //       return Colors.orange.shade600;
  //     case "in-progres":
  //       return Colors.blue.shade600;
  //     default:
  //       return Colors.grey.shade600;
  //   }
  // }
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(
            //   'assets/images/no_internet.png', // replace with your asset
            //   height: 150,
            // ),
            const SizedBox(height: 20),
            const Text(
              "Connection Error",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            const Text(
              "Please check your internet connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ref.read(listControllerProvider).getEnquiryList();

              },
              icon: const Icon(Icons.refresh),
              label:  Text("Retry",style: nunitoItalic14White,),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
/// --- Error View ---
Widget _buildShimmerList() {
  return ListView.builder(
    padding: const EdgeInsets.all(12),
    itemCount: 5,
    itemBuilder: (context, index) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          height: 130,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    },
  );

}
