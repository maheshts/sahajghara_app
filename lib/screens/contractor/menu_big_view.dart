import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'ContractorReposne.dart';

class MenuViewScreen extends StatefulWidget {
  final List<Imagepath>? menuimageList;
  final String description;
  const MenuViewScreen({super.key,required this.menuimageList,required this.description});

  @override
  State<MenuViewScreen> createState() => _MenuViewScreenState();
}

class _MenuViewScreenState extends State<MenuViewScreen> {
  // final List<String> imageUrls = [
  //   'https://zingara.club/CategoryImages/1.svg',
  //   'https://zingara.club/CategoryImages/2.svg',
  //   'https://zingara.club/CategoryImages/3.svg',
  //   'https://zingara.club/CategoryImages/4.svg',
  //   'https://zingara.club/CategoryImages/5.svg',
  // ];
  late PageController _pageController;
  int _currentIndex = 0;

  // Default selected image
  String? selectedImage;

  @override
  void initState() {
    super.initState();
   // imageUrls = widget.menuimageList;
    selectedImage = widget.menuimageList!.first.profileUrl; // Set first image as default
    _pageController = PageController(initialPage: _currentIndex);
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 40),
        child: Stack(
          children: [
            Column(
              children: [
                // Main image
                Expanded(
                  child: Center(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: widget.menuimageList!.length,
                      itemBuilder: (context, index) {
                        return InteractiveViewer(
                          panEnabled: true,
                          minScale: 0.5,
                          maxScale: 4.0,
                          child: CachedNetworkImage(
                            imageUrl: widget.menuimageList![index].profileUrl.toString(),
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error, color: Colors.grey),
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ONE description for all images
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    widget.description ?? "",
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Image thumbnails
                if (widget.menuimageList!.isNotEmpty)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.menuimageList!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Opacity(
                              opacity: _currentIndex == index ? 1.0 : 0.5,
                              child: CachedNetworkImage(
                                imageUrl: widget
                                    .menuimageList![index]
                                    .profileUrl
                                    .toString(),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey,
                                      child: const Icon(
                                        Icons.broken_image,
                                        color: Colors.white,
                                      ),
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Text(
                    "No images available",
                    style: TextStyle(color: Colors.white),
                  ),
              ],
            ),

            // Close button
            Positioned(
              right: 16,
              top: 2,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
