import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'ContractorReposne.dart';

class MenuViewScreen extends StatefulWidget {
  final List<Imagepath>? menuimageList;
  const MenuViewScreen({super.key,required this.menuimageList});

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
                // Display selected image (swipe-enabled)
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
                          child:CachedNetworkImage(
                            imageUrl:widget.menuimageList![index].profileUrl.toString(),
                   fit: BoxFit.contain,
                        width: double.infinity,
                        height: double.infinity,
                        errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.grey),
                        // Use a placeholder while the image is loading
                   placeholder: (context, url) => const Center(
                        child: SizedBox(
                        height: 20,   // ⬅️ any small size you like
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        ),

                          ),


                          // Image.network(
                          //   fit: BoxFit.contain,
                          //   errorBuilder: (context, error, stackTrace) =>
                          //   const Text("Failed to load image",
                          //       style: TextStyle(color: Colors.white)),
                          // ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Image list at the bottom
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
                              child: Image.network(
                                widget.menuimageList![index].profileUrl.toString(),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey,
                                      child: const Icon(Icons.broken_image, color: Colors.white),
                                    ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  const Text("No images available", style: TextStyle(color: Colors.white)),
              ],
            ),

            // Close Button at the top right
            Positioned(
              right: 16,
              top: 2,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.close, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
