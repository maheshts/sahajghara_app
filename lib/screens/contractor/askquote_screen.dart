import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/vendor_controller.dart';
import '../../helpers/custom_toast.dart';
import '../../helpers/navigation.dart';
import '../../helpers/utillls.dart';
import '../../nwdata/api/api_contants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_constants.dart';
import '../thank_you_screen.dart';

class AskquoteScreen extends ConsumerStatefulWidget {
  String contractorName;
  String contractorId;
  AskquoteScreen({super.key,required this.contractorId,required this.contractorName});

  @override
  ConsumerState<AskquoteScreen> createState() => _AskquoteScreenState();
}

class _AskquoteScreenState extends ConsumerState<AskquoteScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for fields
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();
  final categoryController = TextEditingController();
  final brandController = TextEditingController();
  final quantityController = TextEditingController();
  final locationController =
  TextEditingController(text: "250, Saheed Nagar, Bhubaneswar");
  String urgency = "Immediate";
  bool _loading = false;
  String name = "";
  String email = "";
  String phone = "";
  String address = "";
  String? selectedType;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      name = pref.getString(APIConstants.accountName) ?? "";
      phone = pref.getString(APIConstants.mobile) ?? "";
      email = pref.getString(APIConstants.email) ?? "";
     var  address = pref.getString("address") ?? "";
      nameController.text = name;
      phoneController.text = phone;
      emailController.text = email;
      //categoryController.text = widget.categoryName ?? "";
      //brandController.text = widget.brandName ?? "";
      // var address = pref.getString(APIConstants.address) ?? "";
      locationController.text = address;
    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(title: const Text("Inquiry Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Contactor -  ${widget.contractorName}",style: nunitoItalic16,),
              _textField("Name",false,
                  controller: nameController, validator: _validateName),
              _textField("Phone Number",false,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone),
              _textField("Email",false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail),


              _textField("Property Size (Sq. Ft.)",false,
                  controller: quantityController,
                  keyboardType: TextInputType.number,

                  validator: _validateSize),
              _textField("Location",false,
                  controller: locationController,
                  validator: (v) => _validateRequired(v, "location")),
              const SizedBox(height: 10),

              selectType(),
              _textField("Comments / Special Requests", false,controller: noteController),
              ElevatedButton(
                onPressed: _loading ? null : _submitInquiry,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14)),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    :  Text("Submit",
                    style: nunitoItalic14White),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedType == null || selectedType!.isEmpty) {
      CustomToast.displayErrorToast(content: "Please select building type");
      return;
    }

    setState(() => _loading = true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);
    var latitude = pref.getDouble("latitude");
    var longtitude = pref.getDouble("longitude");
    // 🔗 replace with your API
    final data = {
      //{"vendor":"IDOFCONTRCTOR","customer":"LoginID","name":"name","phone":"phone","email":"email",
      // "project_type":"project_type","project_size":"project_size",
      // "location":"location","comments":"comments"}
      "lat":latitude.toString(),"long":longtitude.toString(),
      "customer":userid,
      "vendor":widget.contractorId,
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "project_size": quantityController.text.trim(),
      "location": locationController.text.trim(),
      "project_type": selectedType,
      "comments": noteController.text.trim(),
    };
    Utills.customPrint('inquirySubmit data ${json.encode(data)}');

    ref.read(vendorControllerProvider).submitContractorData(data.cast<String, String>()).then((respone){
      setState(() => _loading = false);
      if(respone.isSuccess){
        CustomToast.displaySuccessToast(content:  "Inquiry submitted successfully");
        Navigation.sideNavigation(context, ThankYouScreen());
      }else{
        CustomToast.displayErrorToast(content:  respone.message);
      }
    });


  }
  Widget selectType(){
    return DropdownButtonFormField<String>(
      value: selectedType,
      hint: const Text(
        "Select Type",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 14,
        ),
      ),
      items: const [
        DropdownMenuItem(
          value: "Simplex",
          child: Text("Simplex"),
        ),
        DropdownMenuItem(
          value: "Duplex",
          child: Text("Duplex"),
        ),
      ],
      onChanged: (value) {
        setState(() {
          selectedType = value!;
        });
      },
      decoration: InputDecoration(
        labelText: "Building Type",
        labelStyle: const TextStyle(
          fontSize: 14,
          color: Color(0xFF707070),
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF003B73), width: 1.3),
        ),
      ),
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1E2432),
      ),
      icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF003B73)),
      dropdownColor: Colors.white,
    );
  }

  Widget _textField(String label,bool readOnly,
      {TextEditingController? controller,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your name";
    }
    if (value.trim().length < 3) {
      return "Name should be at least 3 characters";
    }
    return null;
  }
  String? _validateSize(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Please enter your size";
    }

    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your phone number";
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
      return "Enter a valid 10-digit phone number";
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }
    if (!RegExp(r'^[\w\.\-]+@[a-zA-Z0-9]+\.[a-zA-Z]+').hasMatch(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter quantity";
    }
    if (int.tryParse(value) == null) {
      return "Quantity must be a number";
    }
    return null;
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "Please enter $fieldName";
    }
    return null;
  }
}
