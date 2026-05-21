import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/controllers/list_controller.dart';
import 'package:sahajghara/helpers/navigation.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/widgets/dummy_shimmer.dart';
import 'package:sahajghara/screens/contractor/askquote_screen.dart';
import 'package:shimmer/shimmer.dart';

import 'ContractorReposne.dart';
import 'contractor_portfolio_screen.dart';

class ContractorListScreen extends ConsumerStatefulWidget {
  const ContractorListScreen({super.key});

  @override
  ConsumerState<ContractorListScreen> createState() => _ContractorListScreenState();
}

class _ContractorListScreenState extends ConsumerState<ContractorListScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listControllerProvider).getContractorList();
    });
  }
  @override
  Widget build(BuildContext context) {
    // You can read/watch providers here when needed
    // Example: final contractorList = ref.watch(contractorProvider);
var bookingWatch = ref.watch(listControllerProvider);

    return Scaffold(
     backgroundColor: const Color(0xFFF5F6FA),
     //  backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Contractor List",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body:bookingWatch.getContractorListDataStatus == ContractorListStatus.loading?DummyShimmer():
      bookingWatch.getContractorListDataStatus == ContractorListStatus.loaded?
      ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookingWatch.contractorlist!.length,
        itemBuilder: (context, index) {
          Contractorlist c = bookingWatch.contractorlist![index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// --- Header Row ---
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      //backgroundImage: AssetImage(""),
                      backgroundImage: NetworkImage(c.profileUrl!),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name ?? "N/A",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E2432),
                            ),
                          ),
                          Text(
                            '${c.experience} Years Experience',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.addressDetails ?? "N/A",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF707070),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFE0E0E0)),
                const SizedBox(height: 12),

                /// --- Managed Project Budget ---
                const Text(
                  "Managed Project Budget",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _budgetTile("Minimum", c.minProjectBudget!),
                    _budgetTile("Maximum", c.maxProjectBudget!),
                  ],
                ),

                const SizedBox(height: 12),

                /// --- Grade and Projects ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoTile("Grade", c.grade!),
                    _infoTile("Current Projects", c.numberofproject!),
                  ],
                ),

                const SizedBox(height: 16),

                /// --- Buttons ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigation.sideNavigation(context, AskquoteScreen(contractorId: c.sId.toString(), contractorName: c.name.toString()));
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFF003B73)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          "Ask for a quote",
                          style: TextStyle(
                            color: Color(0xFF003B73),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ContractorPortfolioScreen(
                                contractorName: c.name!,
                                portfolioList: c.portfolioList,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003B73),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        child: const Text(
                          "View Portfolio",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ):Text("Server error"),
    );
  }

  /// --- Reusable Widgets ---
  Widget _budgetTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF1E2432),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E2432),
          ),
        ),
      ],
    );
  }
}

/// --- Dummy Data ---
final List<Map<String, String>> contractors = [
  {
    'name': 'Mahadev Mishra',
    'experience': '25',
    'address': 'Plot 205, Satya Villa, Saheed Nagar,\nBhubaneswar, Odisha, 751035',
    'min': '₹25,00,000 Lakhs',
    'max': '₹30,00,000 Lakhs',
    'grade': 'Class 1',
    'projects': '10',
    'image': 'assets/images/person1.png',
  },
  {
    'name': 'Sourav Das',
    'experience': '20',
    'address': 'Plot 205, Satya Villa, Saheed Nagar,\nBhubaneswar, Odisha, 751035',
    'min': '₹25,00,000 Lakhs',
    'max': '₹30,00,000 Lakhs',
    'grade': 'Class 1',
    'projects': '10',
    'image': 'assets/images/person2.png',
  },
  {
    'name': 'Mohan Gobinda Puhan',
    'experience': '25',
    'address': 'Plot 205, Satya Villa, Saheed Nagar,\nBhubaneswar, Odisha, 751035',
    'min': '₹25,00,000 Lakhs',
    'max': '₹30,00,000 Lakhs',
    'grade': 'Class 1',
    'projects': '10',
    'image': 'assets/images/person3.png',
  },
];
