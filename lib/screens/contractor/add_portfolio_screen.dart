import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/contractor_controler.dart';
import '../../nwdata/api/api_contants.dart';

class AddPortfolioScreen extends ConsumerStatefulWidget {
  const AddPortfolioScreen({super.key});

  @override
  ConsumerState<AddPortfolioScreen> createState() => _AddPortfolioScreenState();
}

class _AddPortfolioScreenState extends ConsumerState<AddPortfolioScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  List<XFile> selectedImages = [];

  bool isSubmitting = false;

  // ================= PICK MULTIPLE IMAGES =================
  Future<void> pickImages() async {
    final images = await _picker.pickMultiImage(imageQuality: 80);

    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images);
      });
    }
  }

  // ================= SUBMIT =================
  Future<void> submitPortfolio() async {
    if (nameController.text.isEmpty ||
        areaController.text.isEmpty ||
        selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields and add images")),
      );
      return;
    }

    setState(() => isSubmitting = true);

    // TODO: Call your API here (Multipart request)
    List<MultipartFile> imageFiles = [];
    for (var image in selectedImages) {
      imageFiles.add(
        await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      );
    }
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);

    /// FormData
    FormData formData = FormData.fromMap({
      "user_id": userid,
      "name": nameController.text,
      "area": areaController.text,
      "description":"",
      "images": imageFiles, // API should accept array
    });

    ref.read(contractorControllerProvider).addPortfolio(formData).then((response){
      if(response.isSuccess){
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Portfolio added successfully")),
        );

        Navigator.pop(context,true);
      }else{
        setState(() => isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.message}")),
        );
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Add Portfolio",style: nunitoItalic16,)),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _inputField("Project name", nameController),
              const SizedBox(height: 10),
        
              _inputField("Project area", areaController),
              const SizedBox(height: 10),

              _inputField("Description", descriptionController),
              const SizedBox(height: 10),
        
              // Add more photos button
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: (){
                      pickImages();
                    },
                    child: Chip(label: Text("Add Image"))),
              ),
              // SizedBox(
              //   width: double.infinity,
              //   height: 48,
              //   child: ElevatedButton(
              //     onPressed: pickImages,
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: const Color(0xFFBEC0C4),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //     child:  Text("Add photos",style: nunitoItalic14White,),
              //   ),
              // ),
        
              const SizedBox(height: 12),
        
              // Image preview grid
              if (selectedImages.isNotEmpty) _imagePreview(),
        
              const Spacer(),
        
              // Save button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : submitPortfolio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF344C77),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      :  Text("Submit",style: nunitoItalic14White,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _inputField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _imagePreview() {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: selectedImages.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 8),
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    image: FileImage(File(selectedImages[index].path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 4,
                top: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImages.removeAt(index);
                    });
                  },
                  child: const CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.black54,
                    child: Icon(Icons.close, size: 12, color: Colors.white),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
