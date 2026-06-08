import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  Future<void> _openWhatsApp() async {
    final phone = "919876543210";
    final message = Uri.encodeComponent("Hi! I submitted an inquiry. Please assist me.");
    final url = "https://wa.me/$phone?text=$message";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text("Inquiry Posted",style: nunitoItalic16.copyWith(fontSize: 20),)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/successs.json',
                height: 150,
              ),

              // const Icon(Icons.thumb_up_alt_outlined,
              //     size: 100, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text(
                "THANK YOU!",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
               Text(
                "Thank you for your inquiry. \n Our support team will reach out to you at the earliest.",
                textAlign: TextAlign.center,style: nunitoItalic14.copyWith(color: AppColors.primary,fontWeight: FontWeight.w200),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child:  Text("Go Home",style: nunitoItalic14White,),
              ),
            ],
          ),
        ),
      ),

    );
  }
}
