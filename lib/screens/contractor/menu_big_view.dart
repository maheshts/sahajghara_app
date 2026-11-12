import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../profile/contractor/ContractorDetailData.dart';
import 'ContractorReposne.dart';

class MenuViewScreen extends StatefulWidget {
  final List<Imagepath>? menuimageList;
  final String description;
  final String title;
  const MenuViewScreen({super.key,required this.menuimageList,required this.description,required this.title});

  @override
  State<MenuViewScreen> createState() => _MenuViewScreenState();
}
class _MenuViewScreenState extends State<MenuViewScreen> {
  late PageController _pageController;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.menuimageList ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFF101216),

      body: SafeArea(
        child: Column(
          children: [
            // =====================================================
            // TOP BAR
            // =====================================================

            Padding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                10,
              ),
              child: Row(
                children: [
                  // Back / Close button
                  InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context, Colors.white).withOpacity(0.10),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // =================================================
                  // TITLE
                  // =================================================

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title ?? "Menu",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 3),

                        if (images.isNotEmpty)
                          Text(
                            "${_currentIndex + 1} of ${images.length}",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      ],
                    ),
                  ),

                  // =================================================
                  // IMAGE COUNT
                  // =================================================

                  if (images.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surface(context, Colors.white).withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.photo_library_outlined,
                            size: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "${images.length}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),

            // =====================================================
            // IMAGE VIEWER
            // =====================================================

            Expanded(
              child: images.isEmpty
                  ? _buildEmptyImageState()
                  : Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    onPageChanged: _onPageChanged,

                    itemBuilder: (
                        context,
                        index,
                        ) {
                      final imageUrl =
                          images[index].profileUrl?.toString() ?? "";

                      return InteractiveViewer(
                        panEnabled: true,
                        minScale: 0.8,
                        maxScale: 4.0,

                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,

                            fit: BoxFit.contain,

                            width: double.infinity,
                            height: double.infinity,

                            placeholder: (
                                context,
                                url,
                                ) {
                              return const Center(
                                child: SizedBox(
                                  width: 28,
                                  height: 28,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },

                            errorWidget: (
                                context,
                                url,
                                error,
                                ) {
                              return _buildImageError();
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  // =================================================
                  // LEFT ARROW
                  // =================================================

                  if (_currentIndex > 0)
                    Positioned(
                      left: 12,
                      child: _navigationButton(
                        icon: Icons.chevron_left_rounded,
                        onTap: () {
                          _pageController.previousPage(
                            duration:
                            const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),

                  // =================================================
                  // RIGHT ARROW
                  // =================================================

                  if (_currentIndex < images.length - 1)
                    Positioned(
                      right: 12,
                      child: _navigationButton(
                        icon: Icons.chevron_right_rounded,
                        onTap: () {
                          _pageController.nextPage(
                            duration:
                            const Duration(milliseconds: 250),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),

            // =====================================================
            // DESCRIPTION
            // =====================================================

            if (widget.description != null &&
                widget.description!.trim().isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  14,
                  4,
                  14,
                  12,
                ),
                padding: const EdgeInsets.all(14),

                decoration: BoxDecoration(
                  color: const Color(0xFF1B1E24),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),

                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,

                      decoration: BoxDecoration(
                        color: AppTheme.surface(context, Colors.white).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(9),
                      ),

                      child: const Icon(
                        Icons.info_outline_rounded,
                        color: Colors.white70,
                        size: 18,
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            widget.description!,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.62),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // =====================================================
            // THUMBNAILS
            // =====================================================

            if (images.isNotEmpty)
              SizedBox(
                height: 82,

                child: ListView.builder(
                  scrollDirection: Axis.horizontal,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                  ),

                  itemCount: images.length,

                  itemBuilder: (
                      context,
                      index,
                      ) {
                    final imageUrl =
                        images[index].profileUrl?.toString() ?? "";

                    final bool isSelected =
                        _currentIndex == index;

                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration:
                          const Duration(milliseconds: 280),
                          curve: Curves.easeInOut,
                        );
                      },

                      child: AnimatedContainer(
                        duration:
                        const Duration(milliseconds: 200),

                        width: 64,
                        height: 64,

                        margin: const EdgeInsets.only(
                          right: 10,
                        ),

                        padding: EdgeInsets.all(
                          isSelected ? 2 : 0,
                        ),

                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),

                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),

                        child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(8),

                          child: Opacity(
                            opacity:
                            isSelected ? 1.0 : 0.50,

                            child: CachedNetworkImage(
                              imageUrl: imageUrl,

                              fit: BoxFit.cover,

                              placeholder: (
                                  context,
                                  url,
                                  ) {
                                return Container(
                                  color:
                                  const Color(0xFF242830),

                                  child: const Center(
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child:
                                      CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              },

                              errorWidget: (
                                  context,
                                  url,
                                  error,
                                  ) {
                                return Container(
                                  color:
                                  const Color(0xFF242830),

                                  child: const Icon(
                                    Icons
                                        .broken_image_outlined,
                                    color:
                                    Colors.white54,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // NAVIGATION BUTTON
  // =============================================================

  Widget _navigationButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(24),

        onTap: onTap,

        child: Container(
          width: 42,
          height: 42,

          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.45),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
            ),
          ),

          child: Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
  }

  // =============================================================
  // IMAGE ERROR
  // =============================================================

  Widget _buildImageError() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          color: const Color(0xFF1B1E24),
          borderRadius: BorderRadius.circular(14),
        ),

        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.broken_image_outlined,
              color: Colors.white54,
              size: 40,
            ),

            SizedBox(height: 8),

            Text(
              "Unable to load image",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =============================================================
  // EMPTY IMAGE STATE
  // =============================================================

  Widget _buildEmptyImageState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 76,
            height: 76,

            decoration: BoxDecoration(
              color: AppTheme.surface(context, Colors.white).withOpacity(0.08),
              shape: BoxShape.circle,
            ),

            child: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white54,
              size: 36,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "No images available",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
