import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/navigation.dart';
import '../../helpers/utillls.dart';
import '../profile/contractor/ContractorDetailData.dart';
import 'ContractorReposne.dart';
import 'askquote_screen.dart';
import 'menu_big_view.dart';

class ContractorPortfolioScreen extends ConsumerStatefulWidget {
  final String contractorName;
  final List<PortfolioList>? portfolioList;

  const ContractorPortfolioScreen({
    super.key,
    required this.contractorName,
    required this.portfolioList,
  });

  @override
  ConsumerState<ContractorPortfolioScreen> createState() =>
      _ContractorPortfolioScreenState();
}

class _ContractorPortfolioScreenState
    extends ConsumerState<ContractorPortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    final portfolioList = widget.portfolioList ?? [];

    final bool hasPortfolio = portfolioList.isNotEmpty &&
        portfolioList.any(
              (item) =>
          item.imagepath != null &&
              item.imagepath!.isNotEmpty,
        );

    return Scaffold(
      backgroundColor: AppTheme.surface(context, Color(0xFFF5F7FA)),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        backgroundColor: AppTheme.surface(context, Colors.white),
        elevation: 0,

        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF172033),
            size: 20,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Portfolio",
              style: TextStyle(
                color: Color(0xFF172033),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              widget.contractorName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF7A8495),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: SafeArea(
        child: !hasPortfolio
            ? _buildEmptyState()
            : Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // =================================================
                  // HEADER
                  // =================================================

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        16,
                        16,
                        10,
                      ),
                      child: _buildPortfolioHeader(
                        portfolioList,
                      ),
                    ),
                  ),

                  // =================================================
                  // PROJECT GRID
                  // =================================================

                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      4,
                      16,
                      100,
                    ),

                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final project =
                          portfolioList[index];

                          final hasImages =
                              project.imagepath != null &&
                                  project
                                      .imagepath!
                                      .isNotEmpty;

                          if (!hasImages) {
                            return const SizedBox.shrink();
                          }

                          return _buildProjectCard(
                            project,
                          );
                        },

                        childCount:
                        portfolioList.length,
                      ),

                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,

                        crossAxisSpacing: 12,
                        mainAxisSpacing: 14,

                        childAspectRatio: 0.72,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // =========================================================
      // ASK FOR QUOTE
      // =========================================================

      bottomNavigationBar: hasPortfolio
          ? _buildBottomQuoteButton()
          : null,

    );
  }

  // =============================================================
  // PORTFOLIO HEADER
  // =============================================================

  Widget _buildPortfolioHeader(
      List<PortfolioList> portfolioList,
      ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF003B73),
            Color(0xFF0A5A9C),
          ],
        ),

        borderRadius: BorderRadius.circular(18),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003B73)
                .withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          // =======================================================
          // ICON
          // =======================================================

          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: AppTheme.surface(context, Colors.white).withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),

            child: const Icon(
              Icons.apartment_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 14),

          // =======================================================
          // TEXT
          // =======================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  "Construction Projects",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "${portfolioList.length} project${portfolioList.length == 1 ? '' : 's'} showcased",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // =======================================================
          // PROJECT COUNT
          // =======================================================

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 9,
            ),

            decoration: BoxDecoration(
              color: AppTheme.surface(context, Colors.white).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [
                Text(
                  "${portfolioList.length}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const Text(
                  "Projects",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // PROJECT CARD
  // =============================================================

  Widget _buildProjectCard(
      PortfolioList project,
      ) {
    final imageList = project.imagepath ?? [];

    final String imageUrl =
    imageList.isNotEmpty
        ? imageList.first.profileUrl ?? ""
        : "";

    final String projectName =
    (project.name != null &&
        project.name!.trim().isNotEmpty)
        ? project.name!.trim()
        : "Construction Project";

    final String location =
    (project.location != null &&
        project.location!.trim().isNotEmpty)
        ? project.location!.trim()
        : "Location not available";

    final String status =
    (project.status != null &&
        project.status!.trim().isNotEmpty)
        ? project.status!.trim()
        : "Completed";

    final bool isCompleted =
        status.toLowerCase() == "completed";

    return GestureDetector(
      onTap: () {
        Navigation.sideNavigation(
          context,
          MenuViewScreen(
            menuimageList: project.imagepath,
            description:
            "${project.title ?? ""}"
                "${project.description != null && project.description!.isNotEmpty ? " - ${project.description}" : ""}",
            title: projectName,
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface(context, Colors.white),
          borderRadius: BorderRadius.circular(16),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        clipBehavior: Clip.antiAlias,

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [
            // =====================================================
            // IMAGE
            // =====================================================

            Expanded(
              flex: 6,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,

                      fit: BoxFit.cover,

                      placeholder:
                          (context, url) {
                        return Container(
                          color:
                          AppTheme.surface(context, Color(0xFFEFF2F6)),

                          child: const Center(
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child:
                              CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        );
                      },

                      errorWidget:
                          (context, url, error) {
                        return Container(
                          color:
                          AppTheme.surface(context, Color(0xFFEFF2F6)),

                          child: const Center(
                            child: Icon(
                              Icons
                                  .broken_image_outlined,
                              color:
                              Color(0xFF9AA3B2),
                              size: 34,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // =================================================
                  // STATUS BADGE
                  // =================================================

                  Positioned(
                    top: 10,
                    left: 10,

                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),

                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(0xFFE8F7EF)
                            : const Color(0xFFFFF4DD),

                        borderRadius:
                        BorderRadius.circular(20),

                        boxShadow: [
                          BoxShadow(
                            color:
                            Colors.black.withOpacity(
                              0.08,
                            ),
                            blurRadius: 5,
                          ),
                        ],
                      ),

                      child: Row(
                        mainAxisSize:
                        MainAxisSize.min,
                        children: [
                          Icon(
                            isCompleted
                                ? Icons
                                .check_circle_rounded
                                : Icons
                                .access_time_rounded,

                            size: 12,

                            color: isCompleted
                                ? const Color(0xFF159447)
                                : const Color(0xFFE18A00),
                          ),

                          const SizedBox(width: 4),

                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight:
                              FontWeight.w700,
                              color: isCompleted
                                  ? const Color(
                                0xFF159447,
                              )
                                  : const Color(
                                0xFFE18A00,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // =================================================
                  // IMAGE COUNT
                  // =================================================

                  if (imageList.length > 1)
                    Positioned(
                      right: 10,
                      bottom: 10,

                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.black
                              .withOpacity(0.65),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),

                        child: Row(
                          mainAxisSize:
                          MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons
                                  .photo_library_outlined,
                              color: Colors.white,
                              size: 12,
                            ),

                            const SizedBox(width: 4),

                            Text(
                              "${imageList.length}",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9.5,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // =================================================
                  // VIEW ICON
                  // =================================================

                  Positioned(
                    right: 10,
                    top: 10,

                    child: Container(
                      width: 30,
                      height: 30,

                      decoration: BoxDecoration(
                        color: Colors.black
                            .withOpacity(0.45),
                        shape: BoxShape.circle,
                      ),

                      child: const Icon(
                        Icons
                            .open_in_full_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // =====================================================
            // PROJECT INFORMATION
            // =====================================================

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  11,
                  10,
                  11,
                  9,
                ),

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [
                    // PROJECT NAME

                    Text(
                      projectName,
                      maxLines: 1,
                      overflow:
                      TextOverflow.ellipsis,

                      style: const TextStyle(
                        color: Color(0xFF172033),
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // LOCATION

                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF7A8495),
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            location,
                            maxLines: 2,
                            overflow:
                            TextOverflow.ellipsis,

                            style: const TextStyle(
                              color:
                              Color(0xFF7A8495),
                              fontSize: 10.5,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // VIEW PROJECT

                    Row(
                      children: [
                        const Text(
                          "View project",
                          style: TextStyle(
                            color:
                            Color(0xFF003B73),
                            fontSize: 10.5,
                            fontWeight:
                            FontWeight.w700,
                          ),
                        ),

                        const SizedBox(width: 3),

                        const Icon(
                          Icons
                              .arrow_forward_rounded,
                          size: 14,
                          color:
                          Color(0xFF003B73),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // BOTTOM ASK QUOTE BUTTON
  // =============================================================

  Widget _buildBottomQuoteButton() {
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
            if (widget.portfolioList == null ||
                widget.portfolioList!.isEmpty) {
              return;
            }

            Navigation.sideNavigation(
              context,
              AskquoteScreen(
                contractorId: widget
                    .portfolioList!
                    .first
                    .userId
                    .toString(),

                contractorName:
                widget.contractorName,
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

  // =============================================================
  // EMPTY STATE
  // =============================================================

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
                color: AppTheme.surface(context, Color(0xFFEAF2F9)),
                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons
                    .photo_library_outlined,
                size: 42,
                color: Color(0xFF003B73),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              "No Portfolio Found",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF172033),
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              "This contractor has not added any project photos yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF7A8495),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
