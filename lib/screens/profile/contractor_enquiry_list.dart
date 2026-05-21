import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/profile/contractor/contractor_enquiry_details.dart';

import '../../controllers/list_controller.dart';
import 'model/ContractorEnquiryListResponse.dart';

class ContractorEnquiryList extends ConsumerStatefulWidget {
  const ContractorEnquiryList({super.key});

  @override
  ConsumerState<ContractorEnquiryList> createState() => _ContractorEnquiryListState();
}

class _ContractorEnquiryListState extends ConsumerState<ContractorEnquiryList> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {

      ref.read(listControllerProvider).getContractorEnquiryList();
    });
  }

  Future<void> _refresh() async {
// call your API here and reload
    ref.read(listControllerProvider).getContractorEnquiryList();

  }
  @override
  Widget build(BuildContext context) {
    var enquiryWatch = ref.watch(listControllerProvider);
   final cinquiryList = enquiryWatch.contractorEnquiryList ?? [];
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text(
          "Contractor Inquiry List",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600,fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        //centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body:enquiryWatch.contractorEnquiryStatus == ContractorEnquiryListStatus.loading?Center(child: CircularProgressIndicator()): RefreshIndicator(
        onRefresh: _refresh,
        child: cinquiryList!.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text('No inquiries found')),
          ],
        )
            : ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: cinquiryList!.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final item = cinquiryList![index];
            return  InkWell(
                onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ContractorEnquiryDetails(inquiryId: item.sId.toString(),isVendor: false,)));
                },
                child: _InquiryCard(item));
          },
        ),
      ),
    );
  }
}

Widget _InquiryCard(CList item) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#${item.code}",
            style: nunitoItalic14,
          ),


          Row(
            children: [
              Icon(Icons.engineering_rounded)
              ,
              Text("${item.contractorName}-${item.contractorCode}",style: nunitoItalic15.copyWith(color: AppColors.primary)),
            ],
          ),
          SizedBox(height: 8),

          _infoRow("Project Type", item.projectType.toString()),
          _infoRow("My Location", item.location.toString()),
          _infoRow("Project Size", item.projectSize.toString()+" Feet"),
          _infoRow("Project Type", item.projectType.toString()),
          //_infoRow("Vendor", item["vendor_name"]),
         // _infoRow("Phone", item["phone"]),
          //_infoRow("Email", item["email"]),

          SizedBox(height: 5),
          Text(
            "Posted On: ${item.createdAt}",
            style: TextStyle(color: Colors.grey[600], fontSize: 12),
          ),
        ],
      ),
    ),
  );
}
Widget _infoRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 4.0),
    child: Row(
      children: [
        SizedBox(width: 110, child: Text("$title:", style: TextStyle(fontWeight: FontWeight.w600))),
        Expanded(child: Text(value)),
      ],
    ),
  );
}
