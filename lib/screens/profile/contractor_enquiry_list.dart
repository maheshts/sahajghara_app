import 'package:sahajghara/presentation/theme/app_theme.dart';
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
      backgroundColor: AppTheme.surface(context, Color(0xFFF4F6F9)),
      appBar: AppBar(
        title: Text(
          "Contractor Inquiry List",
          style: TextStyle(color: AppTheme.foreground(context, Colors.black87), fontWeight: FontWeight.w600,fontSize: 20),
        ),
        backgroundColor: AppTheme.surface(context, Colors.white),
        elevation: 1,
        //centerTitle: true,
        iconTheme: IconThemeData(color: AppTheme.foreground(context, Colors.black87)),
      ),
      body:enquiryWatch.contractorEnquiryStatus == ContractorEnquiryListStatus.loading?Center(child: CircularProgressIndicator()): RefreshIndicator(
        onRefresh: _refresh,
        child: cinquiryList.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text('No inquiries found')),
          ],
        )
            : SafeArea(
              child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        itemCount: cinquiryList!.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
              final item = cinquiryList![index];
              return  InkWell(
                  onTap: (){
                    //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ContractorEnquiryDetails(inquiryId: item.sId.toString(),isVendor: false,)));
                  },
                  child: _InquiryCard(item,context));
                        },
                      ),
            ),
      ),
    );
  }
}



Widget _InquiryCard(CList item, BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: AppTheme.gradient(context, [
          Color(0xFFF3F8FF),
          Color(0xFFE4F0FF),
          Color(0xFFD7E9FF),
        ]),
      ),
      border: Border.all(
        color: const Color(0xFFD1E3F5),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF1565C0).withOpacity(0.08),
          blurRadius: 12,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractorEnquiryDetails(
                inquiryId: item.sId.toString(),
                isVendor: false,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =========================================================
              // HEADER
              // =========================================================
              Row(
                children: [

                  // Construction icon
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.home_work_rounded,
                      color: AppTheme.accent(context, AppColors.primary),
                      size: 24,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "${item.contractorName ?? "Contractor"}",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: nunitoItalic15.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.foreground(context, const Color(0xFF18324B)),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          "Contractor • ${item.contractorCode ?? "-"}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.muted(context, Colors.grey.shade600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Inquiry number
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.surface(context, Colors.white).withOpacity(0.75),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFD0E2F5),
                      ),
                    ),
                    child: Text(
                      "#${item.code ?? "-"}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.accent(context, AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // =========================================================
              // PROJECT INFORMATION
              // =========================================================
              Row(
                children: [

                  Expanded(
                    child: _projectInfoBox(context: context,
                      icon: Icons.category_outlined,
                      title: "Project Type",
                      value: item.projectType?.toString() ?? "-",
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _projectInfoBox(context: context,
                      icon: Icons.straighten_rounded,
                      title: "Project Size",
                      value: "${item.projectSize ?? "-"} Feet",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // =========================================================
              // LOCATION
              // =========================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Colors.white).withOpacity(0.65),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context, Color(0xFFFFF3E0)),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        color: Color(0xFFE88900),
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: 9),

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

                          const SizedBox(height: 2),

                          Text(
                            item.location?.toString() ?? "-",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF243746),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 13),

              // =========================================================
              // FOOTER
              // =========================================================
              Row(
                children: [

                  Icon(
                    Icons.access_time_rounded,
                    size: 15,
                    color: AppTheme.muted(context, Colors.grey.shade600),
                  ),

                  const SizedBox(width: 5),

                  Expanded(
                    child: Text(
                      "Posted On: ${item.createdAt ?? "-"}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.muted(context, Colors.grey.shade600),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // View details
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [

                        Text(
                          "View Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        SizedBox(width: 4),

                        Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _projectInfoBox({required BuildContext context,
  required IconData icon,
  required String title,
  required String value,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 10,
      vertical: 10,
    ),
    decoration: BoxDecoration(
      color: AppTheme.surface(context, Colors.white).withOpacity(0.65),
      borderRadius: BorderRadius.circular(11),
      border: Border.all(
        color: Colors.white.withOpacity(0.8),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppTheme.accent(context, AppColors.primary),
          ),
        ),

        const SizedBox(width: 7),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  color: AppTheme.muted(context, Colors.grey.shade600),
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.foreground(context, Color(0xFF18324B)),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _InquiryCard1(BuildContext context, CList item) {
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
              Text("${item.contractorName}-${item.contractorCode}",style: nunitoItalic15.copyWith(color: AppTheme.accent(context, AppColors.primary))),
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
            style: TextStyle(color: AppTheme.muted(context, Colors.grey.shade600), fontSize: 12),
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
