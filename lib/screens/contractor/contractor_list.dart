import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/controllers/list_controller.dart';
import 'package:sahajghara/helpers/navigation.dart';
import 'package:sahajghara/helpers/utillls.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/widgets/dummy_shimmer.dart';
import 'package:sahajghara/screens/contractor/askquote_screen.dart';
import 'package:shimmer/shimmer.dart';

import 'ContractorDetailScreen.dart';
import 'ContractorReposne.dart';
import 'contractor_portfolio_screen.dart';

class ContractorListScreen extends ConsumerStatefulWidget {
  const ContractorListScreen({super.key});

  @override
  ConsumerState<ContractorListScreen> createState() => _ContractorListScreenState();
}

class _ContractorListScreenState
    extends ConsumerState<ContractorListScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(listControllerProvider).getContractorList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingWatch = ref.watch(listControllerProvider);

    final contractors = bookingWatch.contractorlist ?? [];

    return Scaffold(
      backgroundColor: AppTheme.surface(context, Color(0xFFF5F7FA)),

      appBar: AppBar(
        backgroundColor: AppTheme.surface(context, Colors.white),
        elevation: 0,
        centerTitle: true,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF1E2432),
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Contractors",
          style: TextStyle(
            color: Color(0xFF1E2432),
            fontSize: 19,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: bookingWatch.getContractorListDataStatus ==
          ContractorListStatus.loading
          ? DummyShimmer()
          : bookingWatch.getContractorListDataStatus ==
          ContractorListStatus.loaded
          ? contractors.isEmpty
          ? _buildEmptyState()
          : SafeArea(
            child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
            14,
            16,
            14,
            40,
                    ),
                    itemCount: contractors.length,
                    itemBuilder: (context, index) {
            final Contractorlist contractor =
            contractors[index];

            return _contractorCard(
              context,
              contractor,
            );
                    },
                  ),
          )
          : _buildErrorState(),
    );
  }

  // ============================================================
  // CONTRACTOR CARD
  // ============================================================

  Widget _contractorCard(
      BuildContext context,
      Contractorlist c,
      ) {
    final String contractorName =
    c.name?.trim().isNotEmpty == true
        ? c.name!.trim()
        : "Contractor";

    final String contractorCode =
        c.contractorCode?.toString() ?? "-";

    final String experience =
        c.experience?.toString() ?? "0";

    final String grade =
        c.ratingAvg?.toString() ?? "N/A";

    final String projects =
        c.numberofproject?.toString() ?? "0";

    final String minBudget =
        c.minProjectBudget?.toString() ?? "-";

    final String maxBudget =
        c.maxProjectBudget?.toString() ?? "-";

    final String address =
    c.addressDetails?.trim().isNotEmpty == true
        ? c.addressDetails!.trim()
        : "Location not available";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(18),

        border: Border.all(
          color: const Color(0xFFE7EBF0),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),

      child: Material(
        color: Colors.transparent,

        child: InkWell(
          borderRadius: BorderRadius.circular(18),

          onTap: () {
            // Later navigate to ContractorDetailScreen
            //
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (_) => ContractorDetailScreen(
            //       contractor: c,
            //     ),
            //   ),
            // );
          },

          child: Padding(
            padding: const EdgeInsets.all(15),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ==================================================
                // HEADER
                // ==================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Profile Image
                    _buildProfileImage(c),

                    const SizedBox(width: 12),

                    // Name + Experience + Location
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [

                              Expanded(
                                child: Text(
                                  contractorName,
                                  maxLines: 1,
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight:
                                    FontWeight.w700,
                                    color:
                                    Color(0xFF172033),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 6),

                              _buildGradeBadge(grade),
                            ],
                          ),

                          const SizedBox(height: 3),

                          Text(
                            "Contractor ID: $contractorCode",
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF8A93A3),
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Row(
                            children: [
                              const Icon(
                                Icons.workspace_premium_rounded,
                                size: 15,
                                color: Color(0xFFE28A00),
                              ),

                              const SizedBox(width: 4),

                              Text(
                                "$experience Years Experience",
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF596273),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ==================================================
                // LOCATION
                // ==================================================

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 9,
                  ),

                  decoration: BoxDecoration(
                    color: AppTheme.surface(context, Color(0xFFF6F8FB)),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      const Icon(
                        Icons.location_on_rounded,
                        size: 17,
                        color: Color(0xFF003B73),
                      ),

                      const SizedBox(width: 7),

                      Expanded(
                        child: Text(
                          address,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Color(0xFF4F5968),
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ==================================================
                // PROJECT STATS
                // ==================================================

                Row(
                  children: [

                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.business_center_rounded,
                        title: "Current Projects",
                        value: projects,
                      ),
                    ),

                    Container(
                      width: 1,
                      height: 40,
                      color: AppTheme.surface(context, Color(0xFFE5E8ED)),
                    ),

                    Expanded(
                      child: _buildStatItem(
                        icon: Icons.star_rounded,
                        title: "Contractor Grade",
                        value: grade,
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 14),

                // ==================================================
                // BUDGET
                // ==================================================

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(12),

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppTheme.gradient(context, [
                        Color(0xFFF1F7FF),
                        Color(0xFFE8F2FF),
                      ]),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD9E8F8),
                    ),
                  ),

                  child: Row(
                    children: [

                      Container(
                        width: 38,
                        height: 38,

                        decoration: BoxDecoration(
                          color: AppTheme.surface(context, Colors.white),
                          borderRadius:
                          BorderRadius.circular(10),
                        ),

                        child: const Icon(
                          Icons.account_balance_wallet_rounded,
                          color: Color(0xFF003B73),
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [

                            const Text(
                              "Managed Project Budget",
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF687386),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 3),

                            Text(
                              "₹ $minBudget  -  ₹ $maxBudget",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF003B73),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Color(0xFF8B96A5),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // ==================================================
                // BUTTONS
                // ==================================================

                Row(
                  children: [

                    // ASK QUOTE
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigation.sideNavigation(
                            context,
                            AskquoteScreen(
                              contractorId:
                              c.sId.toString(),
                              contractorName:
                              contractorName,
                            ),
                          );
                        },

                        icon: const Icon(
                          Icons.request_quote_outlined,
                          size: 17,
                        ),

                        label: const Text(
                          "Ask Quote",
                        ),

                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                          const Color(0xFF003B73),

                          side: const BorderSide(
                            color: Color(0xFF003B73),
                          ),

                          minimumSize:
                          const Size(0, 44),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),

                          textStyle:
                          const TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    // VIEW DETAILS
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _openContractorDetails(
                            context,
                            c,
                          );
                        },

                        icon: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 17,
                        ),

                        label: const Text(
                          "View Details",
                        ),

                        style:
                        ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF003B73),

                          foregroundColor:
                          Colors.white,

                          elevation: 0,

                          minimumSize:
                          const Size(0, 44),

                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10),
                          ),

                          textStyle:
                          const TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w600,
                          ),
                        ),
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

  // ============================================================
  // PROFILE IMAGE
  // ============================================================

  Widget _buildProfileImage(Contractorlist c) {
    final bool hasImage =
        c.profileUrl != null &&
            c.profileUrl!.trim().isNotEmpty;

    return Container(
      width: 58,
      height: 58,

      padding: const EdgeInsets.all(2),

      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFD9E4EF),
          width: 2,
        ),
      ),

      child: CircleAvatar(
        backgroundColor: AppTheme.surface(context, Color(0xFFEAF2FA)),

        backgroundImage:
        hasImage
            ? NetworkImage(c.profileUrl!)
            : null,

        child: !hasImage
            ? const Icon(
          Icons.engineering_rounded,
          color: Color(0xFF003B73),
          size: 30,
        )
            : null,
      ),
    );
  }

  // ============================================================
  // GRADE BADGE
  // ============================================================

  Widget _buildGradeBadge(String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Color(0xFFFFF4DD)),
        borderRadius: BorderRadius.circular(20),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          const Icon(
            Icons.star_rounded,
            size: 13,
            color: Color(0xFFE89A00),
          ),

          const SizedBox(width: 3),

          Text(
            grade,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFFB56B00),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STAT ITEM
  // ============================================================

  Widget _buildStatItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Icon(
          icon,
          size: 20,
          color: const Color(0xFF003B73),
        ),

        const SizedBox(width: 7),

        Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [

            Text(
              title,
              style: const TextStyle(
                fontSize: 10.5,
                color: Color(0xFF8A93A3),
              ),
            ),

            const SizedBox(height: 2),

            Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E2432),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // OPEN DETAIL SCREEN
  // ============================================================

  void _openContractorDetails(
      BuildContext context,
      Contractorlist c,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContractorDetailScreen(
          contractorId: c.sId.toString(),
        ),
      ),
    );
    /*
    Later replace this with your detail screen:


    */

    // Temporary:
    Utills.customPrint(
      "Open contractor details: ${c.sId}",
    );
  }

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Container(
              width: 90,
              height: 90,

              decoration: BoxDecoration(
                color: AppTheme.surface(context, Color(0xFFEAF2FA)),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.engineering_rounded,
                size: 45,
                color: Color(0xFF003B73),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "No Contractors Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E2432),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "There are no contractors available at the moment.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF7B8493),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // ERROR STATE
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,

        children: [

          const Icon(
            Icons.cloud_off_rounded,
            size: 50,
            color: Color(0xFF8A93A3),
          ),

          const SizedBox(height: 12),

          const Text(
            "Unable to load contractors",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E2432),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "Please try again later.",
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF7B8493),
            ),
          ),
        ],
      ),
    );
  }
}


