import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../controllers/list_controller.dart';
import '../../helpers/navigation.dart';
import '../../presentation/widgets/dummy_shimmer.dart';
import '../profile/contractor/ContractorDetailData.dart';
import 'askquote_screen.dart';
import 'contractor_portfolio_screen.dart';

class ContractorDetailScreen extends ConsumerStatefulWidget {
  final String contractorId;
  const ContractorDetailScreen({super.key, required this.contractorId});

  @override
  ConsumerState<ContractorDetailScreen> createState() => _ContractordetailscreenState();
}

class _ContractordetailscreenState
    extends ConsumerState<ContractorDetailScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(listControllerProvider)
          .getContractorDetails(widget.contractorId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final contractorWatch = ref.watch(listControllerProvider);

    Details? contractor = contractorWatch.contractorDetail;

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
          "Contractor Profile",
          style: TextStyle(
            color: Color(0xFF1E2432),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        actions: [
          // IconButton(
          //   onPressed: () {
          //     // TODO: Share contractor
          //   },
          //   icon: const Icon(
          //     Icons.share_outlined,
          //     color: Color(0xFF003B73),
          //   ),
          // ),
        ],
      ),

      body: contractorWatch.getContractorDetailDataStatus ==
          ContractorDetailStatus.loading
          ? DummyShimmer()
          : contractorWatch.getContractorDetailDataStatus ==
          ContractorDetailStatus.loaded
          ?  SafeArea(
        bottom: false,
        child: _buildDetailsPage(
          context,
          contractor!,
        ),
      )
          : _buildErrorState(),

      bottomNavigationBar:
      contractorWatch.getContractorDetailDataStatus ==
          ContractorListStatus.loaded &&
          contractor != null
          ? _buildBottomBar(
        context,
        contractor,
      )
          : null,
    );
  }

  // ============================================================
  // MAIN DETAIL PAGE
  // ============================================================

  Widget _buildDetailsPage(
      BuildContext context,
      Details contractor,
      ) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),

      padding: const EdgeInsets.fromLTRB(
        14,
        14,
        14,
        110,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ------------------------------------------------------
          // PROFILE HEADER
          // ------------------------------------------------------

          _buildProfileHeader(contractor),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // QUICK STATS
          // ------------------------------------------------------

          _buildQuickStats(contractor),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // SPECIALIZATIONS
          // ------------------------------------------------------

          if (contractor.specializations != null &&
              contractor.specializations!.isNotEmpty)
            _buildSpecializationSection(contractor),

          if (contractor.specializations != null &&
              contractor.specializations!.isNotEmpty)
            const SizedBox(height: 14),

          // ------------------------------------------------------
          // ABOUT
          // ------------------------------------------------------

          if (contractor.bio != null &&
              contractor.bio.toString().trim().isNotEmpty)
            _buildAboutSection(contractor),

          if (contractor.bio != null &&
              contractor.bio.toString().trim().isNotEmpty)
            const SizedBox(height: 14),

          // ------------------------------------------------------
          // PORTFOLIO
          // ------------------------------------------------------

          _buildPortfolioSection(
            context,
            contractor,
          ),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // PRICING
          // ------------------------------------------------------

          _buildPricingSection(contractor),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // RATING BREAKDOWN
          // ------------------------------------------------------

          _buildRatingBreakdown(contractor),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // RECENT REVIEWS
          // ------------------------------------------------------

          _buildReviewsSection(contractor),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // VERIFICATION
          // ------------------------------------------------------

          _buildVerificationSection(contractor),

          const SizedBox(height: 14),

          // ------------------------------------------------------
          // CONTACT INFORMATION
          // ------------------------------------------------------

          _buildContactSection(contractor),
          _buildBottomQuoteButton(contractor),
        ],
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(dynamic contractor) {
    final String name =
    contractor.name?.toString().trim().isNotEmpty == true
        ? contractor.name.toString()
        : "Contractor";

    final String company =
    contractor.companyName?.toString().trim().isNotEmpty == true
        ? contractor.companyName.toString()
        : "Construction Professional";

    final String code =
        contractor.contractorCode?.toString() ?? "-";

    final String experience =
        contractor.experience?.toString() ?? "-";

    final String grade =
        contractor.grade?.toString() ?? "-";

    final double rating =
    _toDouble(contractor.ratingAvg);

    final int ratingCount =
    _toInt(contractor.ratingCount);

    final String profileUrl =
        contractor.profileUrl?.toString() ?? "";

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],

        border: Border.all(
          color: const Color(0xFFE6EAF0),
        ),
      ),

      child: Column(
        children: [

          // ----------------------------------------------------
          // COVER
          // ----------------------------------------------------

          Stack(
            clipBehavior: Clip.none,
            children: [

              Container(
                height: 125,

                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),

                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF003B73),
                      Color(0xFF1976D2),
                      Color(0xFF42A5F5),
                    ],
                  ),
                ),

                child: Stack(
                  children: [

                    Positioned(
                      right: -20,
                      top: -25,
                      child: Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.surface(context, Colors.white)
                              .withOpacity(0.07),
                        ),
                      ),
                    ),

                    Positioned(
                      right: 20,
                      bottom: 15,
                      child: Icon(
                        Icons.home_work_rounded,
                        size: 75,
                        color: Colors.white
                            .withOpacity(0.10),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [

                          Icon(
                            Icons.verified_user_rounded,
                            color: Colors.white,
                            size: 18,
                          ),

                          SizedBox(width: 6),

                          Text(
                            "SahajGhara Verified Contractor",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ------------------------------------------------
              // PROFILE IMAGE
              // ------------------------------------------------

              Positioned(
                left: 18,
                bottom: -38,

                child: Container(
                  width: 82,
                  height: 82,

                  padding: const EdgeInsets.all(3),

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.surface(context, Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                      ),
                    ],
                  ),

                  child: CircleAvatar(
                    backgroundColor:
                    AppTheme.surface(context, Color(0xFFEAF2FA)),

                    backgroundImage:
                    profileUrl.isNotEmpty
                        ? NetworkImage(profileUrl)
                        : null,

                    child: profileUrl.isEmpty
                        ? const Icon(
                      Icons.engineering_rounded,
                      size: 40,
                      color: Color(0xFF003B73),
                    )
                        : null,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 48),

          // ----------------------------------------------------
          // NAME
          // ----------------------------------------------------

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Row(
                  children: [

                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF172033),
                        ),
                      ),
                    ),

                    _gradeBadge(grade),
                  ],
                ),

                const SizedBox(height: 3),

                Text(
                  company,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF687386),
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "Contractor ID: $code",
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF9AA3B1),
                  ),
                ),

                const SizedBox(height: 10),

                // Rating
                Row(
                  children: [

                    ...List.generate(
                      5,
                          (index) {
                        return Icon(
                          index < rating.round()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: 19,
                          color: const Color(0xFFF2A900),
                        );
                      },
                    ),

                    const SizedBox(width: 6),

                    Text(
                      rating > 0
                          ? rating.toStringAsFixed(1)
                          : "New",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF293242),
                      ),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      "($ratingCount reviews)",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8992A1),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    const Icon(
                      Icons.workspace_premium_rounded,
                      size: 16,
                      color: Color(0xFFE28A00),
                    ),

                    const SizedBox(width: 5),

                    Text(
                      experience,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF596273),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(width: 15),

                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Color(0xFF003B73),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        contractor.addressDetails
                            ?.toString() ??
                            "Location not available",
                        maxLines: 1,
                        overflow:
                        TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Color(0xFF596273),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QUICK STATS
  // ============================================================

  Widget _buildQuickStats(dynamic contractor) {
    final int projects =
    _toInt(contractor.numberofproject);

    final int completed =
    _toInt(contractor.stats?.projectsCompleted);

    final int active =
    _toInt(contractor.stats?.projectsInprogress);

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 8,
      ),

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE6EAF0),
        ),
      ),

      child: Row(
        children: [

          Expanded(
            child: _stat(
              Icons.business_rounded,
              projects.toString(),
              "Projects",
            ),
          ),

          _verticalDivider(),

          Expanded(
            child: _stat(
              Icons.check_circle_outline_rounded,
              completed.toString(),
              "Completed",
            ),
          ),

          _verticalDivider(),

          Expanded(
            child: _stat(
              Icons.construction_rounded,
              active.toString(),
              "In Progress",
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(
      IconData icon,
      String value,
      String title,
      ) {
    return Column(
      children: [

        Icon(
          icon,
          size: 21,
          color: const Color(0xFF003B73),
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF172033),
          ),
        ),

        const SizedBox(height: 2),

        Text(
          title,
          style: const TextStyle(
            fontSize: 10.5,
            color: Color(0xFF8992A1),
          ),
        ),
      ],
    );
  }

  Widget _verticalDivider() {
    return Container(
      width: 1,
      height: 45,
      color: AppTheme.surface(context, Color(0xFFE5E8ED)),
    );
  }

  // ============================================================
  // SPECIALIZATION
  // ============================================================

  Widget _buildSpecializationSection(dynamic contractor) {
    return _sectionCard(
      title: "Specializations",
      icon: Icons.category_outlined,

      child: Wrap(
        spacing: 8,
        runSpacing: 8,

        children: contractor.specializations
            .map<Widget>(
              (item) => Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),

            decoration: BoxDecoration(
              color: AppTheme.surface(context, Color(0xFFF1F6FC)),
              borderRadius:
              BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFDCE8F5),
              ),
            ),

            child: Text(
              item.toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF003B73),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  Widget _buildAboutSection(dynamic contractor) {
    return _sectionCard(
      title: "About Contractor",
      icon: Icons.person_outline_rounded,

      child: Text(
        contractor.bio.toString(),
        style: const TextStyle(
          fontSize: 13,
          height: 1.5,
          color: Color(0xFF596273),
        ),
      ),
    );
  }

  // ============================================================
  // PORTFOLIO
  // ============================================================

  Widget _buildPortfolioSection(
      BuildContext context,
      Details contractor,
      ) {
    final portfolio =
        contractor.portfolioList ?? [];

    final int total =
    _toInt(contractor.portfolioCounts?.all);

    return _sectionCard(
      title: "Portfolio",
      icon: Icons.photo_library_outlined,

      trailing: total > 0
          ? Text(
        "$total Projects",
        style: const TextStyle(
          fontSize: 11.5,
          color: Color(0xFF003B73),
          fontWeight: FontWeight.w600,
        ),
      )
          : null,

      child: portfolio.isEmpty
          ? _emptySmall(
        Icons.photo_library_outlined,
        "No portfolio projects available",
      )
          : Column(
        children: [

          SizedBox(
            height: 125,

            child: ListView.separated(
              scrollDirection:
              Axis.horizontal,

              itemCount:
              portfolio.length > 3
                  ? 3
                  : portfolio.length,

              separatorBuilder:
                  (_, __) =>
              const SizedBox(width: 10),

              itemBuilder:
                  (context, index) {

                final item =
                portfolio[index];

                final images =
                    item.imagepath ?? [];

                String imageUrl = "";

                if (images.isNotEmpty) {
                  imageUrl =
                      images.first.toString();
                }

                return Container(
                  width: 145,

                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(12),
                    color:
                    AppTheme.surface(context, Color(0xFFF2F4F7)),
                  ),

                  clipBehavior:
                  Clip.antiAlias,

                  child: Stack(
                    fit: StackFit.expand,
                    children: [

                      imageUrl.isNotEmpty
                          ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) =>
                            _portfolioPlaceholder(),
                      )
                          : _portfolioPlaceholder(),

                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,

                        child: Container(
                          padding:
                          const EdgeInsets.all(8),

                          decoration:
                          const BoxDecoration(
                            gradient:
                            LinearGradient(
                              begin:
                              Alignment.topCenter,
                              end:
                              Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black87,
                              ],
                            ),
                          ),

                          child: Text(
                            item.name
                                ?.toString() ??
                                "Project",
                            maxLines: 1,
                            overflow:
                            TextOverflow.ellipsis,
                            style:
                            const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          if (total > 0)
            TextButton(
              onPressed: () {

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ContractorPortfolioScreen(
                          contractorName:
                          contractor.name
                              .toString(),
                          portfolioList:
                          contractor.portfolioList,
                        ),
                  ),
                );
              },

              child: const Text(
                "View All Portfolio →",
                style: TextStyle(
                  color: Color(0xFFE27E00),
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _portfolioPlaceholder() {
    return Container(
      color: AppTheme.surface(context, Color(0xFFEAF2FA)),

      child: const Icon(
        Icons.home_work_rounded,
        color: Color(0xFF003B73),
        size: 35,
      ),
    );
  }

  // ============================================================
  // PRICING
  // ============================================================

  Widget _buildPricingSection(Details contractor) {
    final pricingList = contractor.pricing ?? [];

    // If category-wise pricing is not available,
    // fallback to overall project budget.
    if (pricingList.isEmpty) {
      final String min =
          contractor.minProjectBudget?.toString() ?? "0";

      final String max =
          contractor.maxProjectBudget?.toString() ?? "0";

      return _sectionCard(
        title: "Approx. Pricing",
        icon: Icons.payments_outlined,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.surface(context, Color(0xFFFFF8ED)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFFFE2B5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Colors.white),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.currency_rupee_rounded,
                  color: Color(0xFFE28A00),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Typical project budget",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8B7457),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "₹ $min - ₹ $max",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF9A5A00),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return _sectionCard(
      title: "Approx. Pricing",
      icon: Icons.payments_outlined,
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: pricingList.length,
          separatorBuilder: (context, index) =>
          const SizedBox(width: 10),
          itemBuilder: (context, index) {
            final pricing = pricingList[index];

            final String category =
            pricing.category?.trim().isNotEmpty == true
                ? pricing.category!
                : "General";

            final String min =
                pricing.min?.toString() ?? "0";

            final String max =
                pricing.max?.toString() ?? "0";

            final String unit =
            pricing.unit?.trim().isNotEmpty == true
                ? pricing.unit!
                : "";

            return Container(
              width: 230,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.surface(context, Color(0xFFFFF8ED)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFFFE2B5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.surface(context, Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.currency_rupee_rounded,
                      size: 21,
                      color: Color(0xFFE28A00),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF3A3024),
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "₹ $min - ₹ $max",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF9A5A00),
                          ),
                        ),

                        if (unit.isNotEmpty)
                          Text(
                            "Per $unit",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Color(0xFF8B7457),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 4),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Color(0xFFD3A45C),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // RATING BREAKDOWN
  // ============================================================

  Widget _buildRatingBreakdown(dynamic contractor) {
    final breakdown =
        contractor.ratingBreakdown;

    final double quality =
    _toDouble(breakdown?.qualityOfWork);

    final double timely =
    _toDouble(breakdown?.timelyCompletion);

    final double communication =
    _toDouble(breakdown?.communication);

    return _sectionCard(
      title: "Rating Breakdown",
      icon: Icons.star_outline_rounded,

      child: Column(
        children: [

          _ratingProgress(
            "Quality of Work",
            quality,
          ),

          const SizedBox(height: 12),

          _ratingProgress(
            "Timely Completion",
            timely,
          ),

          const SizedBox(height: 12),

          _ratingProgress(
            "Communication",
            communication,
          ),
        ],
      ),
    );
  }

  Widget _ratingProgress(
      String title,
      double rating,
      ) {
    final double value =
    (rating / 5).clamp(0.0, 1.0);

    return Column(
      children: [

        Row(
          children: [

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF596273),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Text(
              rating > 0
                  ? rating.toStringAsFixed(1)
                  : "-",
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF293242),
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: LinearProgressIndicator(
            value: value,
            minHeight: 7,
            backgroundColor:
            AppTheme.surface(context, Color(0xFFE9EDF2)),
            valueColor:
            const AlwaysStoppedAnimation<Color>(
              Color(0xFFE88900),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REVIEWS
  // ============================================================

  Widget _buildReviewsSection(Details contractor) {
    final reviews =
        contractor.recentReviews ?? [];

    return _sectionCard(
      title: "Recent Reviews",
      icon: Icons.rate_review_outlined,

      child: reviews.isEmpty
          ? _emptySmall(
        Icons.rate_review_outlined,
        "No reviews yet",
      )
          : Column(
        children: reviews
            .take(3)
            .map<Widget>(
              (review) => _reviewItem(review),
        )
            .toList(),
      ),
    );
  }

  Widget _reviewItem(RecentReviews review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),

      padding: const EdgeInsets.all(11),

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Color(0xFFF8F9FB)),
        borderRadius: BorderRadius.circular(11),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              CircleAvatar(
                radius: 16,
                backgroundColor:
                AppTheme.surface(context, Color(0xFFEAF2FA)),

                child: Icon(
                  Icons.person,
                  size: 17,
                  color: Color(0xFF003B73),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  review.customerName?.toString() ??
                      "Customer",
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Row(
                children: List.generate(
                  review.rating?.round() ?? 0,
                      (index) => const Icon(
                    Icons.star_rounded,
                    size: 13,
                    color: Color(0xFFE89A00),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          Text(
            review.comment?.toString() ?? "",
            style: const TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF687386),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VERIFICATION
  // ============================================================

  Widget _buildVerificationSection(dynamic contractor) {
    final verification =
        contractor.verifications;

    final int aadhaar =
    _toInt(verification?.aadhaar);

    final int gst =
    _toInt(verification?.gst);

    final int bank =
    _toInt(verification?.bank);

    return _sectionCard(
      title: "Verification",
      icon: Icons.verified_user_outlined,

      child: Column(
        children: [

          _verificationRow(
            "Identity Verified (Aadhaar)",
            aadhaar == 1,
          ),

          _verificationRow(
            "GST Registered",
            gst == 1,
          ),

          _verificationRow(
            "Bank Account Verified",
            bank == 1,
          ),
        ],
      ),
    );
  }

  Widget _verificationRow(
      String title,
      bool verified,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 9,
      ),

      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE9EDF2),
          ),
        ),
      ),

      child: Row(
        children: [

          Icon(
            verified
                ? Icons.check_circle_rounded
                : Icons.cancel_outlined,

            size: 19,

            color: verified
                ? const Color(0xFF28A745)
                : const Color(0xFF9AA3B1),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF4F5968),
              ),
            ),
          ),

          Text(
            verified ? "Verified" : "Pending",
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: verified
                  ? const Color(0xFF28A745)
                  : const Color(0xFF8A93A3),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CONTACT
  // ============================================================

  Widget _buildContactSection(dynamic contractor) {
    return _sectionCard(
      title: "Contact Information",
      icon: Icons.contact_phone_outlined,

      child: Column(
        children: [

          _contactRow(
            Icons.phone_outlined,
            contractor.phone?.toString() ?? "-",
          ),

          _contactRow(
            Icons.email_outlined,
            contractor.email?.toString() ?? "-",
          ),

          _contactRow(
            Icons.location_on_outlined,
            contractor.addressDetails?.toString() ?? "-",
          ),
        ],
      ),
    );
  }

  Widget _contactRow(
      IconData icon,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            size: 18,
            color: const Color(0xFF003B73),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12.5,
                color: Color(0xFF596273),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // COMMON SECTION CARD
  // ============================================================

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),
        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: const Color(0xFFE6EAF0),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Container(
                width: 32,
                height: 32,

                decoration: BoxDecoration(
                  color: AppTheme.surface(context, Color(0xFFEAF2FA)),
                  borderRadius:
                  BorderRadius.circular(9),
                ),

                child: Icon(
                  icon,
                  size: 17,
                  color: const Color(0xFF003B73),
                ),
              ),

              const SizedBox(width: 9),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF172033),
                  ),
                ),
              ),

              if (trailing != null)
                trailing,
            ],
          ),

          const SizedBox(height: 13),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // GRADE
  // ============================================================

  Widget _gradeBadge(String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
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
            size: 14,
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
  // EMPTY SMALL
  // ============================================================

  Widget _emptySmall(
      IconData icon,
      String message,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),

      child: Center(
        child: Column(
          children: [

            Icon(
              icon,
              size: 28,
              color: const Color(0xFFB1B8C3),
            ),

            const SizedBox(height: 6),

            Text(
              message,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF8A93A3),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM BAR
  // ============================================================

  Widget _buildBottomBar(
      BuildContext context,
      dynamic contractor,
      ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        14,
        10,
        14,
        10 + MediaQuery.of(context).padding.bottom,
      ),

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),

      child: Row(
        children: [

          // CHAT
          SizedBox(
            width: 52,
            height: 48,

            child: OutlinedButton(
              onPressed: () {
                // TODO: Chat
              },

              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,

                side: const BorderSide(
                  color: Color(0xFF003B73),
                ),

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(11),
                ),
              ),

              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                color: Color(0xFF003B73),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // ASK QUOTE
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {

                Navigation.sideNavigation(
                  context,
                  AskquoteScreen(
                    contractorId:
                    contractor.id?.toString() ??
                        contractor.sId?.toString() ??
                        "",
                    contractorName:
                    contractor.name?.toString() ??
                        "Contractor",
                  ),
                );
              },

              icon: const Icon(
                Icons.request_quote_outlined,
                size: 19,
              ),

              label: const Text(
                "Ask for a Quote",
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor:
                const Color(0xFF003B73),

                foregroundColor: Colors.white,

                minimumSize:
                const Size(0, 48),

                elevation: 0,

                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(11),
                ),

                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // NO DATA
  // ============================================================

  Widget _buildNoDataState() {
    return const Center(
      child: Text(
        "Contractor details not found",
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF687386),
        ),
      ),
    );
  }

  Widget _buildBottomQuoteButton(Details contractor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        44,
      ),

      decoration: BoxDecoration(
        color: AppTheme.surface(context, Colors.white),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),

      child: SizedBox(
        width: double.infinity,
        height: 50,

        child: ElevatedButton.icon(
          onPressed: () {


            Navigation.sideNavigation(
              context,
              AskquoteScreen(
                contractorId:contractor.sId.toString(),

                contractorName:
                contractor.name.toString(),
              ),
            );
          },

          style: ElevatedButton.styleFrom(
            backgroundColor:
            const Color(0xFF003B73),

            foregroundColor: Colors.white,

            elevation: 0,

            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(12),
            ),
          ),

          icon: const Icon(
            Icons.request_quote_outlined,
            size: 20,
          ),

          label: const Text(
            "Ask for a Quote",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }


  // ============================================================
  // ERROR
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
            color: Color(0xFF9AA3B1),
          ),

          const SizedBox(height: 12),

          const Text(
            "Unable to load contractor",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
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

  // ============================================================
  // HELPERS
  // ============================================================

  double _toDouble(dynamic value) {
    if (value == null) return 0;

    if (value is double) return value;

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    ) ??
        0;
  }

  int _toInt(dynamic value) {
    if (value == null) return 0;

    if (value is int) return value;

    return int.tryParse(
      value.toString(),
    ) ??
        0;
  }
}
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
