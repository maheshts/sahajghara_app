import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sahajghara/helpers/navigation.dart';

import '../../controllers/home_controller.dart';
import '../../helpers/utillls.dart';
import '../../nwdata/model/brand_response.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_constants.dart';
import '../vendor/VendorListResponse.dart';
import '../vendor/vendor_list.dart';
import 'HomePageResponse.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class BrandScreen extends ConsumerStatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final String? image;
  final List<Brand>? brandList;
  final String? subcategory;

  const BrandScreen({
    super.key,
    this.brandList,
    this.categoryId,
    this.categoryName,
    this.image, this.subcategory,
  });

  @override
  ConsumerState<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends ConsumerState<BrandScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Brands> filteredList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeControllerProvider).getbrandList(widget.categoryId,widget.subcategory).then((respone){

        if(respone.isSuccess){
          filteredList = respone.data;
        }
      });
    });
    //filteredList = ref.read(ho)

  }


  void _filterBrands(String query) {
    final allItems =filteredList ?? [];
    if (query.isEmpty) {
      setState(() => filteredList = allItems);
    } else {
      setState(() {
        filteredList = allItems
            .where((brand) =>
            brand.name!.toLowerCase().contains(query.toLowerCase().trim()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Example: You can read providers using ref.watch or ref.read here
    // final myProviderValue = ref.watch(myProvider);
    var homeWatch = ref.watch(homeControllerProvider);
    filteredList = homeWatch.brandLists ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text("Select ${widget.categoryName} Brand",style: nunitoItalic16),
      ),
      body:homeWatch.detailStatus == GetDetailStatus.loading?Center(child: CircularProgressIndicator(color: Colors.blue,)): SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.image ?? "",
              height: Utills.height(context) * 0.25,
              fit: BoxFit.fill,
            ),


            // 🔹 Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                controller: _searchController,
                hintText: 'Search brand...',
                onChanged: _filterBrands,
                leading: const Icon(Icons.search),
              ),
            ),

            // 🔹 Filtered List
        GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: filteredList.length,
          itemBuilder: (context, index) {
            final brand = filteredList[index];

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigation.sideNavigation(
                  context,
                  VendorList(
                    image: widget.image,
                    categoryId: widget.categoryId,
                    categoryName: widget.categoryName,
                    brandName: brand.name,
                    brandId: brand.id,
                    subcategory: widget.subcategory,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Expanded(
                    //   child: CachedNetworkImage(
                    //     imageUrl: brand.photoUrl ?? "",
                    //     fit: BoxFit.contain,
                    //     placeholder: (_, __) =>
                    //      SizedBox(height:3,width:10,child: CircularProgressIndicator(strokeWidth: 2)),
                    //     errorWidget: (_, __, ___) =>
                    //     const Icon(Icons.image_not_supported),
                    //   ),
                    // ),
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: brand.photoUrl ?? "",
                        fit: BoxFit.contain,

                        placeholder: (_, __) => const Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),

                        errorWidget: (_, __, ___) =>
                        const Icon(Icons.image_not_supported),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      brand.name ?? "",
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
          ],
        ),
      ),
    );
  }
}

