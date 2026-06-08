
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:in_app_update/in_app_update.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/presentation/theme/app_strings.dart';
import 'package:sahajghara/screens/home/home_screen.dart';
import 'package:sahajghara/screens/intro_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../helpers/utillls.dart';

import '../main.dart';
import '../nwdata/api/api_contants.dart';
import '../presentation/theme/app_images.dart';
import 'location.dart';
import 'auth/login_screen.dart';



class Splashscreen extends StatefulWidget {
  @override
  State<Splashscreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splashscreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _showProgressIndicator = false;
  double _progress = 0.0; // Initial progress value
  late Timer _timer;
  bool isLocation = false;

  String _address = "Fetching address...";

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // Define scale animation
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);

    // Start the animation and show the progress indicator after completion
    _controller.forward().then((_) {
      setState(() {
        _showProgressIndicator = true;
        _startProgress();
      });
      checkForUpdate();

      Timer(Duration(seconds: 1), () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        bool isLogin = pref.getBool(APIConstants.authenticated) ?? false;
        Utills.customPrint('isLocation isLogin$isLogin');
        Utills.customPrint('isLocation isLogin!$isLogin!');

        if (isLogin) {
          Utills.customPrint('isLocation if $isLocation');

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                address: "address",
                latitude: 20.123344,
                longitude:80.234425,
              ),
            ),
                (Route<dynamic> route) => false,
          );


          // String? address = await showDialog(
          //   context: context,
          //   barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
          //   builder: (context) => LocationDialog(),
          // );
          //await getUserLocation();
          //  Utills.customPrint('isLocation $isLocation');
          //   Navigator.pushReplacement(
          //     context,
          //     MaterialPageRoute(builder: (context) => LocationScreen()),
          //   );
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     //builder: (context) => LoginPage(),
          //     builder: (context) => HomeScreen(title: "ddf"),
          //   ),
          // );

        } else {
          Utills.customPrint('isLocation else $isLocation');
          Navigator.pushReplacementNamed(context, '/intro');
          //
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     //builder: (context) => LoginPage(),
          //     builder: (context) => IntroScreen(),
          //   ),
          // );
        }
      });
    });
  }

  Future<void> checkForUpdate() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          // Force immediate update
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          // Start flexible update
          await InAppUpdate.startFlexibleUpdate();
          // After the update is downloaded, complete the update
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      print("Error checking for update: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel(); // Clean up the timer when widget is disposed
    super.dispose();
  }

  void _startProgress() {
    // Increment progress every 100ms
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        _progress += 0.05; // Increase progress by a small value
        if (_progress >= 1.0) {
          _timer.cancel(); // Stop the timer when progress reaches 1.0
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        color: AppColors.primary,
        child: Stack(
          children: [
            // Positioned(
            //   top: -44,
            //   right: -20,
            //   child: ClipOval(child:Image.asset(
            //     AppImages.ellipsesplash,
            //   ),),
            //   height: Utills.height(context) / 3,
            //   width: Utills.height(context) / 3,),
            // Transform.rotate(
            //     angle: 15 / 360,
            //     child:  Image.asset(
            //       AppImages.ellipsesplash4,
            //       height: Utills.height(context)/3,
            //       width: Utills.height(context) / 3,
            //     ),
            // ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   child: Transform.rotate(
            //     angle: 200 * (3.141592653589793 / 200), //
            //     child: Image.asset(
            //       AppImages.ellipsesplash4,
            //       height: Utills.height(context) / 3,
            //       width: Utills.height(context) / 3,
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated logo

                  ScaleTransition(
                    scale: _animation,
                    child: Container(
                      height: 120,
                      // width: 120,
                      child: Image.asset(
                        AppImages.logo,
                          width: 150,
                          height: 150,
                      )
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_showProgressIndicator)
                    SizedBox(
                      width: 200, // Set the width of the progress bar
                      child: LinearProgressIndicator(
                        minHeight: 6, // Increase the thickness of the bar
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white),
                        value: _progress,
                      ),
                    ),
                  const SizedBox(height: 20),
                  // Text below the logo
                  Text(
                    AppStrings.appName,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Show progress indicator after animation

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


}
