import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahajghara/controllers/vendor_controller.dart';
import 'package:sahajghara/helpers/utillls.dart';
import 'package:sahajghara/helpers/validators.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/contractor_controler.dart';
import '../../../nwdata/api/api_contants.dart';
import '../model/ProfileResponse.dart';

class ContractorProfileScreen extends ConsumerStatefulWidget {
  const ContractorProfileScreen({super.key});

  @override
  ConsumerState<ContractorProfileScreen> createState() =>
      _ContractorProfileScreenState();
}

class _ContractorProfileScreenState
    extends ConsumerState<ContractorProfileScreen> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  final Map<String, TextEditingController> controllers = {
    "phone": TextEditingController(),
    "name": TextEditingController(),
    "email": TextEditingController(),
    "address_details": TextEditingController(),
    "experience": TextEditingController(),
    "alternate_number": TextEditingController(),

    "grade": TextEditingController(),
    "numberofproject": TextEditingController(),
    "min_project_budget": TextEditingController(),
    "max_project_budget": TextEditingController(),
  };
  final Map<String, String?> originalValues = {};

  bool isChanged = false;
  bool isUpdating = false;
  bool isInitializing = false;

  final _formKey = GlobalKey<FormState>();

  /// Controllers map (key = API field name)

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
      _setInitialProfileData(profileAsync.profileData!);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          "My Profile",
          style: nunitoItalic16.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: profileAsync.profileDataStatus == ProfileDataStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : profileAsync.profileDataStatus == ProfileDataStatus.error
          ? const Center(child: Text("Error loading profile"))
          : profileAsync.profileDataStatus == ProfileDataStatus.loaded
          ? SafeArea(
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _profileHeader(profileAsync.profileData),
                    const SizedBox(height: 24),
                    _profileFields(profileAsync.profileData),
                    const SizedBox(height: 24),
                    //  _saveButton(),
                  ],
                ),
              ),
          )
          : const Center(child: Text("No profile data")),
    );
  }

  void _setInitialProfileData(Result data) {
    isInitializing = true;

    controllers["phone"]!.text = data.phone ?? "";
    controllers["name"]!.text = data.name ?? "";
    controllers["email"]!.text = data.email ?? "";
    controllers["alternate_number"]!.text = data.alternateNumber ?? "";
    controllers["address_details"]!.text = data.addressDetails ?? "";
    controllers["experience"]!.text = data.experience ?? "";
    controllers["grade"]!.text = data.grade ?? "";
    controllers["numberofproject"]!.text = data.numberofproject ?? "";
    controllers["min_project_budget"]!.text = data.minProjectBudget ?? "";
    controllers["max_project_budget"]!.text = data.maxProjectBudget ?? "";

    for (final entry in controllers.entries) {
      originalValues[entry.key] = entry.value.text;
    }

    isChanged = false;
    isInitializing = false;
  }



  Widget _profileFields(Result? data) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

          _editableField("Name", "name",
              validator: Validators.requiredText),

          _editableField("Email", "email",
              validator:Validators.emailValidator),
          _readOnlyField(
            "Phone", "phone",

          ),

          _editableField("Alternate Number", "alternate_number",
              isNumber: true),





          _editableField("Address", "address_details",
              validator: (v) => Validators.requiredText(v, min: 5)),



          _editableField("Experience (Years)", "experience",
              isNumber: true, validator : (v) => Validators.requiredText(v)),

          _editableField("Grade (A/B/C)", "grade",
             ),
          _editableField("Number of Projects", "numberofproject",
              isNumber: true,  validator: (v) => Validators.requiredText(v,min: 2)),

          Row(
            children: [
              Expanded(
                child: _editableField(
                  "Min Budget (Lakhs)",
                  "min_project_budget",
                  isNumber: true,
      validator: (v) => Validators.requiredText(v,min: 2)),
                ),

              const SizedBox(width: 12),
              Expanded(
                child: _editableField(
                  "Max Budget (Lakhs)",
                  "max_project_budget",
                  isNumber: true,
                  validator: (v) {
                    final min = num.tryParse(
                        controllers["min_project_budget"]?.text ?? "0") ??
                        0;
                    final max = num.tryParse(v ?? "");
                    if (max == null) return "Invalid";
                    if (max <= min) return "Must be > Min budget";
                    return null;
                  },
                ),
              ),
          ]),


          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isUpdating
                  ? null
                  : () {
                print("Button clicked");
                if (_formKey.currentState!.validate()) {
                  updateProfile();
                }
              },
              child: isUpdating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Update Profile"),
            ),
          ),




          // const SizedBox(height: 4),
          //
          // Text("Managed Projects", style: nunitoItalic16),
          // const SizedBox(height: 8),
          // Row(
          //   children: [
          //     Expanded(
          //       child: _editableField(
          //         "Minimum (Lakhs)",
          //         controllers["min_project_budget"]!,
          //       ),
          //     ),
          //     const SizedBox(width: 16),
          //     Expanded(
          //       child: _editableField(
          //         "Maximum (Lakhs)",
          //         controllers["max_project_budget"]!,
          //       ),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.40,
          //       child: _readOnlyField("Grade", controllers["grade"]!.text),
          //     ),
          //     const SizedBox(width: 24),
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.40,
          //       child: _readOnlyField("Number of Projects",controllers["numberofproject"]!.text),
          //     ),
          //   ],
          // ),
          // ElevatedButton(
          //   onPressed: isChanged ? _updateProfile : null,
          //   child: const Text("Save Changes"),
          // ),

          // Product Assigned
          // if (data.productAsign != null && data.productAsign!.isNotEmpty)
          //_productSection(data.productAsign!.first),

      ]),
    );
  }

  Future<void> updateProfile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String customerId = preferences.getString(APIConstants.userId) ?? "";
    Utills.customPrint("update profile called");
    if (!_formKey.currentState!.validate()){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fix errors before submitting")),
      );
      return;
    };

    setState(() => isUpdating = true);

    try {
      FormData formData = FormData.fromMap({
        "name": controllers["name"]?.text.trim(),
        "email": controllers["email"]?.text.trim(),
        "phone": controllers["phone"]?.text.trim(),
        "alternate_number":
        controllers["alternate_number"]?.text.trim(),
        "address_details":
        controllers["address_details"]?.text.trim(),
        "experience":
        controllers["experience"]?.text.trim(),
        "grade": controllers["grade"]?.text.trim(),
        "numberofproject":
        controllers["numberofproject"]?.text.trim(),
        "min_project_budget":
        controllers["min_project_budget"]?.text.trim(),
        "max_project_budget":
        controllers["max_project_budget"]?.text.trim(),
        "user_id":customerId,

        // If image selected, send it also
        if (_selectedImage != null)
          "profileimage": await MultipartFile.fromFile(
            _selectedImage!.path,
            filename: "profile.jpg",
          ),
      });
      Utills.customPrint("profile submit");

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


    } catch (e) {
      debugPrint("Update error: $e");
    }

    setState(() => isUpdating = false);
  }



  Widget _productSection(ProductAsignList product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Product Assignment",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
     //   _readOnlyField("Brand ID", product.brand?.oid),
       // _readOnlyField("Category ID", product.category?.oid),
        _readOnlyField("Sub Categories", product.subcategories?.join(", ")),
      ],
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
        keyboardType: isNumber
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.blueGrey.shade100,
        ),
      ),
    );
  }



  Widget _readOnlyField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
      //  initialValue: value ?? "-",
        controller: controllers[value],
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.blueGrey.shade100,
        ),
      ),
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
                            : null)
                        as ImageProvider?,
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
                  child: _isUploading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(
                          Icons.camera_alt,
                          size: 18,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          data.name ?? "",
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

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await uploadProfileImage();
    }
  }

  Future<void> uploadProfileImage() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      FormData formData = FormData.fromMap({
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


    } catch (e) {
      debugPrint("Upload error: $e");
    }

    setState(() => _isUploading = false);
  }
}
