import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:sahajghara/controllers/vendor_controller.dart';
import 'package:sahajghara/helpers/custom_toast.dart';
import 'package:sahajghara/helpers/navigation.dart';
import 'dart:convert';

import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/screens/thank_you_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/utillls.dart';
import '../nwdata/api/api_contants.dart';

class InquiryFormScreen extends ConsumerStatefulWidget {
  final String? categoryId;
  final String? categoryName;
  final String? image;
  final String? brandName;
  final String? brandId;
  final String? subcategory;
  final String? vendorId;
  const InquiryFormScreen({super.key,
    this.categoryId,
    this.categoryName,
    this.image,this.brandName,this.brandId, this.subcategory,this.vendorId});


  @override
  ConsumerState<InquiryFormScreen> createState() => _InquiryFormScreenState();
}

class _InquiryFormScreenState extends  ConsumerState<InquiryFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for fields
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();
  final categoryController = TextEditingController(text: "Low Heat Cement");
  final brandController = TextEditingController(text: "Ambuja Cements");
  final quantityController = TextEditingController(text: "250");
  final locationController =
  TextEditingController(text: "250, Saheed Nagar, Bhubaneswar");
  String urgency = "Immediate";
  bool _loading = false;
  String name = "";
  String email = "";
  String phone = "";
  String address = "";

  Future<void> _submitInquiry() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);
    var latitude = pref.getDouble("latitude");
    var longtitude = pref.getDouble("longitude");
    // 🔗 replace with your API
    final data = {
      "lat":latitude.toString(),"long":longtitude.toString(),
      "customer":userid,
      "vendor":widget.vendorId,
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "email": emailController.text.trim(),
      "category": widget.categoryId,
      "subcategory": widget.subcategory,
      "brand": widget.brandId,
      "order_quantity": quantityController.text.trim(),
      "location": locationController.text.trim(),
      "requirment_urgency": urgency,
      "comments": noteController.text.trim(),
    };
    Utills.customPrint('inquirySubmit data ${json.encode(data)}');

    ref.read(vendorControllerProvider).submitVendorData(data.cast<String, String>()).then((respone){
      setState(() => _loading = false);
      if(respone.isSuccess){
        CustomToast.displaySuccessToast(content:  "Inquiry submitted successfully");
        Navigation.sideNavigation(context, ThankYouScreen());
      }else{
        CustomToast.displayErrorToast(content:  respone.message);
      }
    });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
     SharedPreferences pref = await SharedPreferences.getInstance();
      name = pref.getString(APIConstants.accountName) ?? "";
      phone = pref.getString(APIConstants.mobile) ?? "";
      email = pref.getString(APIConstants.email) ?? "";
      address = pref.getString("address") ?? "";
     nameController.text = name;
     phoneController.text = phone;
     emailController.text = email;
     categoryController.text = widget.categoryName ?? "";
     brandController.text = widget.brandName ?? "";
     locationController.text = address;
    });



  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inquiry Form")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
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
              _textField("Category",true,
                  controller: categoryController,
                  validator: (v) => _validateRequired(v, "cement category")),
              _textField("Brand",true,
                  controller: brandController,
                  validator: (v) => _validateRequired(v, "cement brand")),
              _textField("Order Quantity (KG)",false,
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  validator: _validateQuantity),
              _textField("Location",false,
                  controller: locationController,
                  validator: (v) => _validateRequired(v, "location")),
              const SizedBox(height: 10),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Requirement Urgency")),
              Row(
                children: [
                  Radio(
                    value: "Immediate",
                    groupValue: urgency,
                    onChanged: (val) =>
                        setState(() => urgency = val.toString()),
                  ),
                  const Text("Immediately (<2 Days)"),
                ],
              ),
              Row(
                children: [
                  Radio(
                    value: "Later",
                    groupValue: urgency,
                    onChanged: (val) =>
                        setState(() => urgency = val.toString()),
                  ),
                  const Text("Later (Not decided yet)"),
                ],
              ),
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
