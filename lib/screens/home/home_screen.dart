import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:sahajghara/screens/contractor/contractor_list.dart';
import 'package:sahajghara/screens/home/HomePageResponse.dart';
import 'package:sahajghara/screens/home/sub_category.dart';
import 'package:sahajghara/screens/home/vendor_dashboard.dart';
import 'package:sahajghara/screens/profile/profile.dart';
import 'package:sahajghara/screens/profile/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../controllers/home_controller.dart';
import '../../core/AppData.dart';
import '../../helpers/navigation.dart';
import '../../helpers/utillls.dart';
import '../../nwdata/api/api_contants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_constants.dart';
import '../utils/DottedLoader.dart';
import '../utils/ErrorScreen.dart';
import '../utils/notification_icon.dart';
import 'dashboard_card.dart';
import 'notification_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  final String address;
  final double latitude;
  final double longitude;

  HomeScreen(
      {super.key, required this.address, required this.latitude, required this.longitude});


  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  bool? enableVendor;
  bool? enableContractor;
  bool? requestVendor;
  bool? requestContractor;
  final List<String> _hints = [
    "Search Property",
    "Search Restaurant",
    "Search Club",
  ];
  AppUpdateInfo? _updateInfo;

  // VideoPlayerController? _videoPlayerController;
  // ChewieController? _chewieController;
  bool _isLoading = true;
  String? _videoUrl;
  late YoutubePlayerController _ytController;
  late var filteredList = [];
  String uName = "";
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  final FocusNode _searchFocusNode = FocusNode();
  int _currentHintIndex = 0;
  late Timer _timer;
  String selectedCity = "Bhubaneswar";
  @override
  void dispose() {
    _ytController.dispose();
    super.dispose();
  }


  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final homeController = ref.read(homeControllerProvider.notifier);
      homeController.setLatitude(widget.latitude);
      homeController.setLongitude(widget.longitude);
      homeController.setFetch(false);
      homeController.getHomeData(context);

      _ytController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(
            "https://youtu.be/mZL1gnlKTeQ"
        )!,

        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,

          loop: false,
          enableCaption: true,
          controlsVisibleAtStart: true,
        ),
      );

      setName();
      checkForUpdate();
      checkApiStatus();
    });
  }

  Future<void> setName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      uName = pref.getString(APIConstants.accountName)!;
      Utills.customPrint('name $uName');
    });
  }
  void showCityDialog() {

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(

          title: const Text("Select City"),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              ListTile(
                title: const Text("Bhubaneswar"),

                onTap: () {

                  setState(() {
                    selectedCity = "Bhubaneswar";
                  });

                  Navigator.pop(context);
                },
              ),

              // ListTile(
              //   title: const Text("Cuttack"),
              //
              //   onTap: () {
              //
              //     setState(() {
              //       selectedCity = "Cuttack";
              //     });
              //
              //     Navigator.pop(context);
              //   },
              // ),
            ],
          ),
        );
      },
    );
  }

  Future<void> checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      print("Update check failed: $e");
    }
  }

  Future<void> checkApiStatus() async {
    final homeWatch = ref.watch(homeControllerProvider);
    if (homeWatch.getHomeDataStatus == GetHomeDataStatus.loaded) {
      Utills.customPrint(
          "Home screen dispose called ${homeWatch.getHomeDataStatus}");

      ref.invalidate(homeControllerProvider);
    }
    Utills.customPrint(
        "Home screen dispose called ${homeWatch.getHomeDataStatus}");
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("Exit App", style: nunitoItalic15,),
            content: Text(
              "Are you sure you want to exit?", style: nunitoItalic14,),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No", style: nunitoItalic14,),
              ),
              TextButton(
                onPressed: () =>
                    SystemNavigator.pop(),
                //Navigator.of(context).pop(true),
                child: Text("Yes", style: nunitoItalic14,),
              ),
            ],
          ),
    ) ??
        false; // If the user taps outside, return false (don't exit)
  }

  void _startHintTicker() {
    //_timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) setState(() =>
      _currentHintIndex = ++_currentHintIndex % _hints.length);
    });
  }


  @override
  Widget build(BuildContext context) {
    final homeWatch = ref.watch(homeControllerProvider);
    if(homeWatch.getHomeDataStatus == GetHomeDataStatus.loaded){

      if(homeWatch.homeResult!.enableVendor == true) {
        filteredList = homeWatch.homeResult!.vendorSummery!.where((item) => (item.count ?? 0) > 0).toList();
      }
    }
    return RefreshIndicator(
      onRefresh: (){
        return ref.read(homeControllerProvider).getHomeData(context);
      },
      child: WillPopScope(
        onWillPop: () async {
          return await _showExitDialog(context);
        },
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(

          
              backgroundColor: Color(0xfff7f6fb),
              body: homeWatch.getHomeDataStatus == GetHomeDataStatus.loading
                  ? Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: FractionalOffset.centerLeft,
                          end: FractionalOffset.centerRight,
                          //colors: [const Color(0xFF5d65ba)  , const Color(0xFF673b86)],
                          //colors: [AppColors.btnColor,AppColors.white],
                          //gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDeep],
          
                          stops: [0.4, 1.0]
                      )
                  ),
                  child: DottedLoader(text: "Loading"))
              // child: CircularProgressIndicator(color: AppColors.primary))
                  :
              homeWatch.getHomeDataStatus == GetHomeDataStatus.error ?
              ErrorScreen(
                message: "Server encountered an error. Please try again.",
                onRetry: () {
                  // 👇 Call your reload API
                  ref.read(homeControllerProvider).getHomeData(context);
                },
              )
                  : Column(
                children: [
                  Stack(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          height: Utills.height(context) * 0.11,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: FractionalOffset.centerLeft,
                                  end: FractionalOffset.centerRight,
                                  //colors: [const Color(0xFF5d65ba)  , const Color(0xFF673b86)],
                                  //colors: [AppColors.btnColor,AppColors.white],
                                  //gradient: const LinearGradient(
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryDeep
                                  ],
          
                                  stops: [0.4, 1.0]
                              )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              AppBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0.0,
                                centerTitle: false,
                                automaticallyImplyLeading: false,
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 18.0),
                                      child: Text(
                                          "Hi $uName", textAlign: TextAlign.start,
                                          style: nunitoItalic14White),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.zero,

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [

                                          const Icon(
                                            Icons.location_on,
                                            color: AppColors.white,
                                            size: 18,
                                          ),

                                          Flexible(
                                            child: Text(
                                              selectedCity,
                                              style: nunitoItalic12White,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          const SizedBox(width: 4),

                                          InkWell(
                                            onTap: showCityDialog,

                                            child: const Icon(
                                              Icons.edit,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  // IconButton(
                                  //   visualDensity: VisualDensity.compact,
                                  //   padding: EdgeInsets.zero,
                                  //   constraints: const BoxConstraints(),
                                  //   onPressed: () => ref.read(homeControllerProvider).getHomeData(context),
                                  //   icon: const Icon(Icons.refresh, size: 18, color: Colors.white),
                                  // ),
                                  //const SizedBox(width: 8), // Controlled spacing

                                  //const SizedBox(width: 8),
                                  NotificationBadgeIcon(phone: "phone"),
                                  InkWell(
                                      onTap: () => ref.read(homeControllerProvider).getHomeData(context),
                                      child: Icon(Icons.refresh, size: 18, color: Colors.white)),
                                  IconButton(
                                    visualDensity: VisualDensity.compact,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
          
                                       onPressed: () => Navigation.sideNavigation(context, ProfileScreens()),
                                    icon: const Icon(Icons.menu, size: 18, color: Colors.white),
                                  ),
                                 // Icon(Icons.person, size: 18, color: Colors.white),
                                 // const SizedBox(width: 4),
                                  //SizedBox(width: 8),
                                  //SizedBox(width: 8),
          //
                                //  Icon(Icons.person, size: 18, color: Colors.white),
          
                                  // IconButton(
                                  //   visualDensity: VisualDensity.compact,
                                  //   padding: EdgeInsets.zero,
                                  //   constraints: const BoxConstraints(),
                                  //     onPressed: (){
                                  //
                                  //     },
                                  //   // onPressed: () => Navigation.sideNavigation(context, NotificationScreen()),
                                  // //  onPressed: () => Navigation.sideNavigation(context, VendorDashboard()),
                                  //   icon: const Icon(Icons.notification_important_outlined, size: 18, color: Colors.white),
                                  // ),
                                  const SizedBox(width: 6), // End padding
                                ],
                              ),
          
                              // searchBar(),
          
          
                            ],
                          )
          
                      ),
                    ],
                  ),
          
          
                  Expanded(child:
                  RefreshIndicator(
                    onRefresh: () {
                      return ref.read(homeControllerProvider).getHomeData(context);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          bannerHeader(homeWatch.bannerList),
                          SizedBox(height: 8),
                          enquiryWidget(),
                          SizedBox(height: 8),
                          youtubeSection(),
                          SizedBox(height: 8),
                          // 👈 Add here
                       homeWatch.homeResult!.enableVendor == true?
                       vendorDashBoard(filteredList):SizedBox(),
                          SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                "Deal With Us",
                                style: nunitoItalic16.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDeep,
                                ),
                              ),
                            ),
                          ),
                          categoryWidget(homeWatch.categoryList, homeWatch.brandList),
                         // partnerWithUsButton(),
                        ],
                      ),
                    ),
                  ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }




  Widget bannerHeader(List<ImagegalleryList> banners) {
    return Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(height: Utills.height(context) * 0.18,
                viewportFraction: 1,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
                autoPlay: true),
            items: banners.map((i) {
              var item = i;
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    margin: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                       // color: AppColors.primary
                    ),
                    // child: Text('text $i', style: TextStyle(fontSize: 16.0),)
                    child:
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                        imageUrl: item.photoUrl.toString(),
                        placeholder: (context, url) =>
                        const Center(
                          child: SizedBox(
                            height: 20, // ⬅️ any small size you like
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),

                        //placeholder: (context, url) => const SizedBox(height: 10,width: 10, child: CircularProgressIndicator(color: Colors.amber,)),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                        fit: BoxFit.cover,
                      ),),
                    //Image.network(item.imagePath.toString(),fit: BoxFit.fill,)),
                  );
                },
              );
            }).toList(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: banners
                .asMap()
                .entries
                .map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ]

    );
  }

  Widget enquiryWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(5),
        ),
        color: Color.fromRGBO(255, 255, 255, 1),
        border: Border.all(
          color: Color.fromRGBO(234, 234, 234, 1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          Row(children: [
            Icon(Icons.person, color: AppColors.primaryDeep, size: 20,),
            SizedBox(width: 4,),
            Text("Hire Contractors", style: nunitoItalic14.copyWith(
                color: AppColors.primary, fontWeight: FontWeight.w200),)

          ],),
          Row(children: [
            InkWell(
              onTap: () {
                Navigation.sideNavigation(context, ContractorListScreen());
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      topRight: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                      bottomRight: Radius.circular(5),
                    ),
                    color: Color.fromRGBO(234, 234, 234, 1),
                  ),
                  child: Text("Enquiry Now", style: nunitoItalic14,)),
            ),
            Icon(Icons.call, color: AppColors.primaryDeep, size: 20,),


          ],),
        ],
      ),
    );
  }

  Widget categoryWidget(List<Category> categoryList, List<Brand> brandList) {
    return Container(
      height: Utills.height(context) / 3 -30,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GridView.count(
        padding: EdgeInsets.zero,
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(
          categoryList.length > 6 ? 6 : categoryList.length,
              (index) {
            var item = categoryList[index];
            Utills.customPrint("item $item");

            return Center(
              child: InkWell(
                onTap: () {
                  Utills.customPrint('item name {${item.title}}');
                  Utills.customPrint('item name {${json.encode(item)}}');
                  AppData().units = item.units;
                  Navigation.sideNavigation(
                    context,
                    SubCategory(
                      categoryId: item.sId,
                      categoryName: item.title,
                      image: item.photoUrl,
                      subcategoryList: item.subcategory,
                      brandList: brandList,

                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                     // height: Utills.height(context) * 0.08,
                      //width: Utills.height(context) * 0.08,
                     // color: Colors.white,
                      decoration: BoxDecoration(
                      //  color: AppColors.primaryDeep.withOpacity(0.9),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.white,
                        border: Border.all(
                          color: AppColors.primaryDeep.withOpacity(0.5),

                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 1, left: 8, right: 8, bottom: 1),
                        // ✅ reduce image size by padding
                        child: ClipOval(
                          child: CachedNetworkImage(
                            height: 76,
                            imageUrl: item.photoUrl ?? '',
                            fit: BoxFit.fill,
                            placeholder: (context, url) =>
                            const Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                            const Icon(
                              Icons.error,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 3),
                    Text(
                      capitalizeFirstOnly(item.title!),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: nunitoItalic14.copyWith(
                          color: AppColors.primaryDeep),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget youtubeSection() {
    return Container(
      height: Utills.height(context) * 0.22,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: YoutubePlayer(
          controller: _ytController,
          showVideoProgressIndicator: false,

          progressIndicatorColor: AppColors.primary,
        ),
      ),
    );
  }

  Widget vendorDashBoard(list) {
    if (list.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔹 Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            "Vendor Dashboard",
            style: nunitoItalic16.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDeep,
            ),
          ),
        ),

        /// 🔹 Grid
        GridView.builder(
          shrinkWrap: true, // 🔥 VERY IMPORTANT
          physics: const NeverScrollableScrollPhysics(), // 🔥 VERY IMPORTANT
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: list.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 22,
            childAspectRatio: 1.65,
          ),
          itemBuilder: (context, index) {
            final item = list[index];
            return DashboardCard(item: item);
          },
        ),

        const SizedBox(height: 10),
      ],
    );
  }

}

String capitalizeFirstOnly(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}


