
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
  late final AnimationController _controller;
  late final Animation<double> _animation;

  Timer? _timer;

  bool _showProgressIndicator = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start logo animation
    await _controller.forward();

    if (!mounted) return;

    setState(() {
      _showProgressIndicator = true;
    });

    _startProgress();

    // Check Play Store update (don't block app if it fails)
    await checkForUpdate();

    // Small splash delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final pref = await SharedPreferences.getInstance();

    final isLogin =
        pref.getBool(APIConstants.authenticated) ?? false;

    Utills.customPrint("User Logged In : $isLogin");

    if (!mounted) return;

    if (isLogin) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(
            address: "address",
            latitude: 20.123344,
            longitude: 80.234425,
          ),
        ),
            (route) => false,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/intro');
    }
  }

  Future<void> checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();

      if (updateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          await InAppUpdate.performImmediateUpdate();
        } else if (updateInfo.flexibleUpdateAllowed) {
          await InAppUpdate.startFlexibleUpdate();
          await InAppUpdate.completeFlexibleUpdate();
        }
      }
    } catch (e) {
      debugPrint("Update Check Error : $e");
    }
  }

  void _startProgress() {
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
          (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        setState(() {
          _progress += 0.05;

          if (_progress >= 1.0) {
            _progress = 1.0;
            timer.cancel();
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.primary,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _animation,
                child: SizedBox(
                  height: 120,
                  child: Image.asset(
                    AppImages.logo,
                    width: 150,
                    height: 150,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              if (_showProgressIndicator)
                SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    minHeight: 6,
                    value: _progress,
                    backgroundColor: Colors.grey.shade400,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
