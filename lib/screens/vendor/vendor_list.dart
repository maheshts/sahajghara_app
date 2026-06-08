import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/controllers/vendor_controller.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/presentation/widgets/button/login_button.dart';

import '../../helpers/utillls.dart';
import '../InquiryFormScreen.dart';

class VendorList extends ConsumerStatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final String? image;
  final String? brandName;
  final String? brandId;
  final String? subcategory;
  const VendorList({super.key,
    this.categoryId,
    this.categoryName,
    this.image,this.brandName,this.brandId, this.subcategory});

  @override
  ConsumerState<VendorList> createState() => _VendorListState();
}

class _VendorListState extends ConsumerState<VendorList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vendorControllerProvider).getVendorList(widget.categoryId,widget.brandId,widget.subcategory);
    });
  }
  List<String> selectedVendors = [];
  @override
  Widget build(BuildContext context) {
    var vendorWatch = ref.watch(vendorControllerProvider);
    final vendorList = vendorWatch.vendorList ?? [];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
           //   backgroundColor: AppColors.primary,
              title: Text(" ${widget.brandName} Vendors".toUpperCase(), style: nunitoItalic16.copyWith(fontSize: 16))),

          // ✅ Show button only when vendors selected
          bottomNavigationBar: selectedVendors.isNotEmpty
              ? Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () {
                String selectedIds = selectedVendors.join(",");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => InquiryFormScreen(
                      image: widget.image,
                      categoryId: widget.categoryId,
                      categoryName: widget.categoryName,
                      brandId: widget.brandId,
                      brandName: widget.brandName,
                      subcategory: widget.subcategory,
                      vendorId: selectedIds,
                    ),
                  ),
                );
              },
              child: Text(
                "Continue (${selectedVendors.length} Vendors Selected)",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
              : null, // ❗ no "No vendor available" here

          body: vendorWatch.vendorListStatus == VendorListStatus.loading
              ? Center(child: CircularProgressIndicator()) // FIXED
              : vendorList.isEmpty
              ? Center(child: Text("No Vendor Available", style: nunitoItalic16))
              : Column(
            children: [
              CachedNetworkImage(
                imageUrl: widget.image ?? "",
                height: Utills.height(context) * 0.20,
                fit: BoxFit.fill,
              ),
              SizedBox(height: 4),
              Text("Ask Quote for ${widget.subcategory}", style: nunitoItalic16),
              SizedBox(height: 4),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListView.builder(

                    itemCount: vendorList.length,
                    itemBuilder: (context, index) {
                      final item = vendorList[index];
                      final isSelected = selectedVendors.contains(item.sId);

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedVendors.remove(item.sId);
                            } else {
                              if (selectedVendors.length < 4) {
                                selectedVendors.add(item.sId!);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("You can select only max 4 vendors"),
                                  ),
                                );
                              }
                            }
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color:
                            isSelected ? Colors.green.shade100 : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.green
                                  : Colors.grey.shade300,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color:
                                isSelected ? Colors.green : Colors.grey,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: vendorSwiggyCard(
                                  context,
                                  name:  "${item.name} ${item.vendorCode ?? ""}",
                                  address: item.addressDetails ?? "",
                                  timing: "7am - 8pm",
                                  days: "Monday-Saturday",
                                  grade: "4.5",
                                  imageUrl: item.photoUrl,
                                  id: item.sId,
                                ),

                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _vendorCard(
      BuildContext context, {
        required String name,
        required String address,
        required String timing,
        required String days,
        required String? id,
        String? imageUrl,
        String? grade,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👤 Vendor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? "",
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade200,
                child: const Icon(Icons.store, size: 30),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: Colors.grey.shade200,
                child: const Icon(Icons.error, size: 30),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 📋 Vendor Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: nunitoItalic14.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: nunitoItalic14.copyWith(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 6),

                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    _infoChip(Icons.schedule, timing),
                    _infoChip(Icons.calendar_today, days),
                    if (grade != null)
                      _infoChip(Icons.star, grade),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget vendorSwiggyCard(
      BuildContext context,{
    required String name,
    required String address,
    required String timing,
    required String days,
    String? imageUrl,
    String? rating,
    String? distance,
    String? category,
        required String? id,

        String? grade,

  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // 🔥 Image Banner
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: imageUrl ?? "",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                  ),
                  errorWidget: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.store),
                  ),
                ),
              ),

              // ⭐ Rating Badge
              if (rating != null)
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.white, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // 🟡 Offer Tag (optional)
              // Positioned(
              //   top: 10,
              //   left: 10,
              //   child: Container(
              //     padding:
              //     const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              //     decoration: BoxDecoration(
              //       color: Colors.black.withOpacity(0.6),
              //       borderRadius: BorderRadius.circular(6),
              //     ),
              //     child: const Text(
              //       "20% OFF",
              //       style: TextStyle(color: Colors.white, fontSize: 11),
              //     ),
              //   ),
              // ),
            ],
          ),

          const SizedBox(height: 10),

          // 🏪 Name + Distance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (distance != null)
                Text(
                  distance,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 4),

          // 🍽 Category (like "North Indian • Chinese")
          if (category != null)
            Text(
              category,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),

          const SizedBox(height: 4),

          // 📍 Address
          Text(
            address,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 6),

          // ⏰ Timing + Days
          Row(
            children: [
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text(
                timing,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "• $days",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Divider(color: Colors.grey.shade200, thickness: 1),
        ],
      ),
    );
  }
  Widget _infoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 4),
          Text(
            text,
            style: nunitoRegular12.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _vendorCard1(
      BuildContext context, {
        required String name,
        required String address,
        required String timing,
        required String days,required String?
        id,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15,left: 8,right: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgColor1,
        border: Border.all(color: AppColors.borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabelValueRow("Vendor Name", name),
          _buildLabelValueRow("Address", address),
          _buildLabelValueRow("Store Time", timing),
          _buildLabelValueRow("Open Days", days),
          const SizedBox(height: 8),
          // ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (_) =>  InquiryFormScreen( image: widget.image,categoryId: widget.categoryId,
          //           categoryName: widget.categoryName,brandId: widget.brandId,brandName: widget.brandName,
          //           subcategory: widget.subcategory,vendorId: id,),
          //       ),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: AppColors.primary,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(6),
          //     ),
          //   ),
          //   child:  Text("Ask for a quote",style: nunitoItalic14White,),
          // ),
        ],
      ),
    );
  }

  Widget _buildLabelValueRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Fixed width for label column
            child: Text(
              "$label:",
              style: nunitoItalic14.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.black54
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:  nunitoItalic14.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }


}
