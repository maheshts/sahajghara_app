import 'package:sahajghara/presentation/theme/app_theme.dart';
import 'category_banner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sahajghara/helpers/navigation.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/home/HomePageResponse.dart';
import 'package:sahajghara/screens/home/brand_screen.dart';

class SubCategory extends StatefulWidget {
  String? categoryId;
  String? categoryName;
  String? image;
  List<String>? subcategoryList;
  List<Brand>? brandList;
   SubCategory({super.key, this.categoryId, this.categoryName, this.image, this.subcategoryList, this.brandList});

  @override
  State<SubCategory> createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  final FocusNode _focusNode = FocusNode();
  bool _showCursor = false; // initially hide cursor
  List<String> filteredList = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    filteredList = widget.subcategoryList ?? [];
    _focusNode.addListener(() {
      setState(() {
        _showCursor = _focusNode.hasFocus; // show cursor only when tapped
      });
    });
  }
  void _filterSearch1(String query) {
    final allItems = widget.subcategoryList ?? [];
    if (query.isEmpty) {
      setState(() => filteredList = allItems);
    } else {
      setState(() {
        filteredList = allItems
            .where((item) =>
            item.toLowerCase().contains(query.toLowerCase().trim()))
            .toList();
      });
    }
  }
  void _filterSearch(String query) {
    print("Query: $query");

    final allItems = widget.subcategoryList ?? [];

    print("Total Items: ${allItems.length}");

    if (query.isEmpty) {
      setState(() {
        filteredList = allItems;
      });
    } else {
      setState(() {
        filteredList = allItems.where((item) {
          print("Checking: $item");

          return item
              .toLowerCase()
              .contains(query.toLowerCase().trim());
        }).toList();
        print("Filtered List: $filteredList");
      });
    }

    print("Filtered Count: ${filteredList.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select ${widget.categoryName} Category",style: nunitoItalic16,),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategoryBanner(imageUrl: widget.image),
            const SizedBox(height: 8),
            search(),
            ListView.builder(
              shrinkWrap: true, // ✅ important
              physics: const NeverScrollableScrollPhysics(),
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(color: AppColors.borderColor),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      dense: true, // makes the tile more compact
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      minVerticalPadding: 0, // minimizes height even more
                      title: Text(
                        filteredList[index],
                        style: nunitoItalic14,
                      ),
                      trailing: Icon(
                        Icons.arrow_circle_right,
                        color: AppTheme.accent(context, AppColors.primary),
                        size: 24, // optional: reduce icon size slightly
                      ),
                      onTap: () {
                        Navigation.sideNavigation(
                          context,
                          BrandScreen(
                            brandList: widget.brandList,
                            categoryId: widget.categoryId,
                            categoryName: widget.categoryName,
                            image: widget.image,
                            subcategory: filteredList[index],
                          ),
                        );
                      },
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

  Widget search(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 4),
      child: SearchBar(

        controller: _searchController,
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        ),
        focusNode: _focusNode,
        hintText: 'Search...',
        elevation: MaterialStateProperty.all(2),
        backgroundColor: MaterialStateProperty.all(AppTheme.surface(context, AppColors.bgColor1)),
        shadowColor: MaterialStateProperty.all(AppTheme.surface(context, AppColors.bgColor1)),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side:  BorderSide(color:AppColors.borderColor1, width: 1),
          ),
        ),
        textStyle: MaterialStateProperty.all(
          TextStyle(fontSize: 16, color: AppTheme.foreground(context, Colors.black)),
        ),
        hintStyle: MaterialStateProperty.all(
          TextStyle(color: AppTheme.muted(context, Colors.grey), fontStyle: FontStyle.italic),
        ),
        leading:  Icon(Icons.search, color: AppColors.bgColors),
        trailing: [
          _searchController.text.length > 0 ? IconButton(
            icon: const Icon(Icons.clear, color: Colors.red),
            onPressed: () {
              _searchController.clear();
            },
          ):SizedBox(),
        ],
        onTap: () {
          debugPrint('Search bar tapped!');
        },
        onChanged: _filterSearch,
        onSubmitted: (value) {
          debugPrint('User submitted: $value');
        },
      ),
    );
  }
}
