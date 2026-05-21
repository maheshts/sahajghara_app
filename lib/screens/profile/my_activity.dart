import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_enquiry_details.dart';
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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      ref.read(listControllerProvider).getEnquiryList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var enquiryWatch = ref.watch(listControllerProvider);
    final inquiryList = enquiryWatch.enquiryList;
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          "Inquiry List",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 3,
        //centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: enquiryWatch.getEnquiryStatus == EnquiryListStatus.loading?
        _buildShimmerList():enquiryWatch.getEnquiryStatus == EnquiryListStatus.loaded?
        inquiryList!.length> 0?
        ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: inquiryList!.length,
          itemBuilder: (context, index) {
            final inquiry = inquiryList[index];
            return InkWell(
              onTap: (){
                Utills.customPrint("click");
                Navigator.push(context, MaterialPageRoute(builder: (context)=>VendorEnquiryDetails(inquiryId: inquiry.sId.toString(),isVendor: false)));
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// --- Header Row -
                      Text(
                        "#${inquiry.code}",
                        style: nunitoItalic12White.copyWith(color: AppColors.primary, fontSize: 13),
                      ),
                      Row(
                       // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                        Icon(Icons.shopping_bag_outlined) , Text(
                            inquiry.vendorName ?? "",
                            style: nunitoItalic15,
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
                      _infoRow("Comments", inquiry.comments),

                      // const Divider(height: 18, color: Colors.black12),
                      //
                      // /// --- Bottom Row (Contact Info) ---
                      // Column(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Row(
                      //       children: [
                      //         const Icon(Icons.phone, size: 16, color: Colors.blueGrey),
                      //         const SizedBox(width: 5),
                      //         Text(
                      //           inquiry.phone.toString(),
                      //           style: const TextStyle(fontSize: 13, color: Colors.black87),
                      //         ),
                      //       ],
                      //     ),
                      //     Row(
                      //       children: [
                      //         const Icon(Icons.email_outlined, size: 16, color: Colors.blueGrey),
                      //         const SizedBox(width: 5),
                      //         Text(
                      //           inquiry.email ?? "",
                      //           style: const TextStyle(fontSize: 13, color: Colors.black87),
                      //         ),
                      //       ],
                      //     ),
                      //   ],
                      // ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green.shade600;
      case "pending":
        return Colors.orange.shade600;
      case "in-progres":
        return Colors.blue.shade600;
      default:
        return Colors.grey.shade600;
    }
  }
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/no_internet.png', // replace with your asset
              height: 150,
            ),
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
              label: const Text("Retry"),
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
