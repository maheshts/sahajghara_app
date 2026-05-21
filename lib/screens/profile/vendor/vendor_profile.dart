import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahajghara/controllers/vendor_controller.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/contractor_controler.dart';
import '../../../helpers/utillls.dart';
import '../../../nwdata/api/api_contants.dart';
import '../model/ProfileResponse.dart';



class VendorProfileScreen extends ConsumerStatefulWidget {
  const VendorProfileScreen({super.key});

  @override
  ConsumerState<VendorProfileScreen> createState() => _VendorProfileScreenState();
}


class _VendorProfileScreenState
    extends ConsumerState<VendorProfileScreen> {

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  bool isUpdating = false;
  bool isInitializing = false;
  bool isChanged = false;

  final Map<String, TextEditingController> controllers = {
    "phone": TextEditingController(),
    "address_details": TextEditingController(),
    "email": TextEditingController(),
    "alternate_number": TextEditingController(),
    // "alternate_number": TextEditingController(),

    "lat": TextEditingController(),
    "long": TextEditingController(),
  };

  final Map<String, String?> originalValues = {};

  @override
  void initState() {
    super.initState();

    for (final c in controllers.values) {
      c.addListener(_onFieldChanged);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vendorControllerProvider).getProfile();
    });
  }

  void _onFieldChanged() {
    if (isInitializing) return;

    bool changed = false;

    for (final entry in controllers.entries) {
      if (originalValues[entry.key] != entry.value.text) {
        changed = true;
        break;
      }
    }

    if (_selectedImage != null) changed = true;

    setState(() => isChanged = changed);
  }

  @override
  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(vendorControllerProvider);

    if (profileAsync.profileDataStatus == ProfileDataStatus.loaded &&
        originalValues.isEmpty) {
      _setInitialData(profileAsync.profileData!);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("My Profile",
            style: nunitoItalic16.copyWith(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: profileAsync.profileDataStatus == ProfileDataStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _profileHeader(profileAsync.profileData),
              const SizedBox(height: 24),
              _profileForm(),
              const SizedBox(height: 24),
              _saveButton(),
              const SizedBox(height: 14),

              _productAssignSection(profileAsync.profileData!.productAsignList),
            ],
          ),
        ),
      ),
    );
  }

  void _setInitialData(Result data) {
    isInitializing = true;

    controllers["phone"]!.text = data.phone ?? "";
    controllers["address_details"]!.text = data.addressDetails ?? "";
    controllers["email"]!.text = data.email ?? "";
    controllers["alternate_number"]!.text = data.alternateNumber ?? "";
    controllers["lat"]!.text = data.lat?.toString() ?? "";
    controllers["long"]!.text = data.long?.toString() ?? "";

    for (final entry in controllers.entries) {
      originalValues[entry.key] = entry.value.text;
    }

    isInitializing = false;
  }

  Widget _profileForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          /// PHONE
          _readOnlyField(
            "Phone", "phone","phone",

          ),

          /// ADDRESS
          _editableField(
            "Address",
            "address_details",
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return "Address is required";
              }
              if (v.length < 5) {
                return "Minimum 5 characters";
              }
              return null;
            },
          ),

          /// LAT + LONG
          Row(
            children: [
              Expanded(
                child: _editableField(
                  "Latitude",
                  "lat",
                  isNumber: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Required";
                    if (double.tryParse(v) == null) {
                      return "Invalid";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _editableField(
                  "Longitude",
                  "long",
                  isNumber: true,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Required";
                    if (double.tryParse(v) == null) {
                      return "Invalid";
                    }
                    return null;
                  },
                ),
              ),
              IconButton(
                onPressed: _fetchLocation,
                icon: const Icon(Icons.gps_fixed),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _readOnlyField(String label, String? value,keyName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(

        readOnly: true,
        controller: controllers[keyName],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.blueGrey.shade100,
        ),
      ),
    );
  }

  Widget _editableField(
      String label,
      String keyName, {
        bool isNumber = false,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controllers[keyName],
        validator: validator,
        keyboardType:
        isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.blueGrey.shade100,
        ),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isUpdating || !isChanged
            ? null
            : () async {
          await updateProfile();
        },
        child: isUpdating
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Update Profile"),
      ),
    );
  }

  Future<void> updateProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String customerId = preferences.getString(APIConstants.userId) ?? "";
    if (!_formKey.currentState!.validate()) return;

    setState(() => isUpdating = true);

    try {
      FormData formData = FormData.fromMap({
        "phone": controllers["phone"]!.text.trim(),
        "address_details": controllers["address_details"]!.text.trim(),
        "email": controllers["email"]?.text.trim(),
        "alternate_number":
        controllers["alternate_number"]?.text.trim(),
        "lat": controllers["lat"]!.text.trim(),
        "long": controllers["long"]!.text.trim(),
        "user_id":customerId,
        if (_selectedImage != null)
          "profileimage": await MultipartFile.fromFile(
            _selectedImage!.path,
            filename: "profile.jpg",
          ),
      });

      ref.read(contractorControllerProvider).updateProfile(formData).then((response){
        if(response.isSuccess){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.message)),
          );
          // Refresh profile data
          ref.read(vendorControllerProvider).getProfile();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Update failed: ${response.message}")),
          );
        }
      });




      _selectedImage = null;

    } catch (e) {
      debugPrint("Update error: $e");
    }

    setState(() => isUpdating = false);
  }
  Future<void> _fetchLocation() async {
    Utills.customPrint("_fetchLocation");

    try {
      // 1️⃣ Check if location service (GPS) is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showSnack("Please turn on location (GPS)");
        await Geolocator.openLocationSettings();
        await Future.delayed(const Duration(seconds: 3));
        _fetchLocation();
        return;
      }


      // 2️⃣ Check permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showSnack("Location permission denied");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showSnack("Enable location permission from settings");
        await Geolocator.openAppSettings();
        return;
      }

      // 3️⃣ Get location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      controllers["lat"]!.text = position.latitude.toString();
      controllers["long"]!.text = position.latitude.toString();
      //  latCtrl.text = position.latitude.toString();
      // lngCtrl.text = position.longitude.toString();

      Utills.customPrint("Location: ${position.latitude}, ${position.longitude}");
    } catch (e) {
      Utills.customPrint("Location error: $e");
      _showSnack("Failed to get location");
    }
  }
  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
  Widget _profileHeader(Result? data) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : (data!.profileUrl != null
                  ? NetworkImage(data.profileUrl!)
                  : null) as ImageProvider?,
              child: data!.profileUrl == null && _selectedImage == null
                  ? const Icon(Icons.person, size: 50)
                  : null,
            ),

            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _showImageSourceSheet(),
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.blue,
                  child:  const Icon(Icons.camera_alt,
                      size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          data.name ?? ""+"- ${data.vendorCode}" ,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: const Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _productAssignSection(List<ProductAsignList>? products) {
    if (products == null || products.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "My Products",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 14),

        ...products.map((product) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔹 BRAND IMAGE + TITLES
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// BRAND IMAGE WITH CACHE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: product.brandImage != null
                            ? CachedNetworkImage(
                          imageUrl: product.brandImage!,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              Container(
                                width: 70,
                                height: 70,
                                alignment: Alignment.center,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                          errorWidget:
                              (context, url, error) =>
                              Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image),
                              ),
                        )
                            : Container(
                          width: 70,
                          height: 70,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.image),
                        ),
                      ),

                      const SizedBox(width: 14),

                      /// TITLES
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.brandTitle ?? "-",
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product.categoryTitle ?? "-",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 🔥 HORIZONTAL SCROLL CHIPS
                  if (product.subcategories != null &&
                      product.subcategories!.isNotEmpty)
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        physics:
                        const BouncingScrollPhysics(),
                        itemCount:
                        product.subcategories!.length,
                        separatorBuilder: (_, __) =>
                        const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final sub =
                          product.subcategories![index];
                          return AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              sub,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }


  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
     // await uploadProfileImage();
    }
  }

}