import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sahajghara/presentation/theme/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/custom_toast.dart';
import '../presentation/theme/app_colors.dart';
import '../presentation/theme/app_constants.dart';
import 'home/home_screen.dart';


class LocationDialog extends StatefulWidget {
  @override
  _LocationDialogState createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> with WidgetsBindingObserver {
  bool isLoading = true;
  String locationMessage = "Checking location services...";
  BuildContext? _dialogContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // Observe app lifecycle changes
    _checkLocationServiceAndFetch();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer on dispose
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App returned to the foreground, recheck location services
      //CustomToast.displaySuccessToast(content: "retriving location please wait.");
      _dialogContext = null;
      _checkLocationServiceAndFetch();
    }
  }

  Future<void> _checkLocationServiceAndFetch() async {
    setState(() {
      isLoading = true;
      locationMessage = "Checking location services...";
    });

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await _showEnableLocationDialog();
      return;
    }

    await _fetchUserLocation();
  }
  Future<void> _fetchUserLocation() async {
    try {
      if (!mounted) return;
      setState(() {
        locationMessage = "Fetching current location...";
      });

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              locationMessage = "Location permission denied.";
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            locationMessage = "Location permission permanently denied.";
          });
        }
        return;
      }

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        ).timeout(
          const Duration(seconds: 10),
          onTimeout: () async {
            // ✅ If timeout, try last known location
            Position? lastPosition = await Geolocator.getLastKnownPosition();
            if (lastPosition != null) {
              return lastPosition;
            } else {
              throw TimeoutException("Fetching location timed out. No last known location available.");
            }
          },
        );

        String address = await _getAddressFromCoordinates(position);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("address", address);
        prefs.setDouble("latitude", position.latitude);
        prefs.setDouble("longitude", position.longitude);

        if (mounted) {
          setState(() {
            isLoading = false;
            locationMessage = "Your Location : $address";
          });
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                address: address,
                latitude: position.latitude,
                longitude: position.longitude,
              ),
            ),
                (Route<dynamic> route) => false,
          );
        }

      } on TimeoutException catch (_) {
        // ✅ Timeout happened → use last known location
        Position? lastPosition = await Geolocator.getLastKnownPosition();

        if (lastPosition != null) {
          await _handlePosition(lastPosition, isLast: true);
        } else {
          if (mounted) {
            CustomToast.displayErrorToast(
                content: "Location request timed out. No last known location.");
          }
        }
        // if (mounted) {
        //   CustomToast.displayErrorToast(content: "Location request timed out.");
        // }
      } on LocationServiceDisabledException {
        if (mounted) {
          CustomToast.displayErrorToast(content: "Location services are disabled.");
        }
      } on PermissionDeniedException {
        if (mounted) {
          CustomToast.displayErrorToast(content: "Location permission denied.");
        }
      } catch (e) {
        if (mounted) {
          CustomToast.displayErrorToast(content: "Failed to get location: $e");
        }
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          locationMessage = "Error fetching location: $e";
        });
      }
    }
  }

  Future<void> _handlePosition(Position position, {bool isLast = false}) async {
    String address = await _getAddressFromCoordinates(position);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("address", address);
    prefs.setDouble("latitude", position.latitude);
    prefs.setDouble("longitude", position.longitude);

    if (mounted) {
      setState(() {
        isLoading = false;
        locationMessage =
        isLast ? "Last Known Location: $address" : "Your Location: $address";
      });
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => NewHomeScreen(
      //       address: address,
      //       latitude: position.latitude,
      //       longitude: position.longitude,
      //     ),
      //   ),
      //       (Route<dynamic> route) => false,
      // );
    }
  }

  // Future<void> _fetchUserLocation1() async {
  //   try {
  //     setState(() {
  //       locationMessage = "Fetching current location...";
  //     });
  //
  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         setState(() {
  //           locationMessage = "Location permission denied.";
  //         });
  //         return;
  //       }
  //     }
  //
  //     if (permission == LocationPermission.deniedForever) {
  //       setState(() {
  //         locationMessage = "Location permission permanently denied.";
  //       });
  //       return;
  //     }
  //
  //     // Position position = await Geolocator.getCurrentPosition(
  //     //   desiredAccuracy: LocationAccuracy.high,
  //     // );
  //     // String address = await _getAddressFromCoordinates(position);
  //     try {
  //       Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high,
  //       ).timeout(
  //         const Duration(seconds: 10),
  //         onTimeout: () {
  //           throw TimeoutException("Fetching location timed out. Try again.");
  //         },
  //       );
  //
  //       String address = await _getAddressFromCoordinates(position);
  //       // Use the position and address here
  //       print("Latitude: ${position.latitude}, Address: $address");
  //
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       prefs.setString("address", address);
  //       prefs.setDouble("latitide", position.latitude);
  //       prefs.setDouble("longitiude", position.longitude);
  //       setState(() {
  //         isLoading = false;
  //         locationMessage = "Your Location : $address";
  //       });
  //       Navigator.pushAndRemoveUntil(
  //         context,
  //         MaterialPageRoute(builder: (context) =>
  //             NewHomeScreen(address: address,latitude: position.latitude,
  //                 longitude: position.longitude)),
  //             (Route<dynamic> route) => true,
  //       );
  //
  //
  //     } on TimeoutException catch (e) {
  //       // Handle timeout
  //       print("Timeout Error: ${e.message}");
  //       CustomToast.displayErrorToast(content: "Location request timed out.");
  //     } on LocationServiceDisabledException {
  //       // Location services turned off
  //       CustomToast.displayErrorToast(content: "Location services are disabled.");
  //     } on PermissionDeniedException {
  //       // Permission was denied
  //       CustomToast.displayErrorToast(content: "Location permission denied.");
  //     } catch (e) {
  //       // Any other unexpected error
  //       CustomToast.displayErrorToast(content: "Failed to get location: $e");
  //     }
  //
  //
  //
  //   } catch (e) {
  //     setState(() {
  //       locationMessage = "Error fetching location: $e";
  //     });
  //   }
  // }

  Future<void> _showEnableLocationDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        _dialogContext = ctx; // Save the dialog context
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Enable Location Services",style: nunito16,),
          content: Text("Location services are disabled. Please enable them to proceed.",style: nunitoItalic15,),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(ctx); // Close dialog
              },
              child: Text("Cancel",style: nunitoItalic15,),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Geolocator.openLocationSettings(); // Open location settings
              },
              child: Text("Settings",style: nunitoItalic15,),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: Text(AppStrings.appName,style: nunito16,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading) CircularProgressIndicator(color: AppColors.logoYellow),
          SizedBox(height: 16),
          Text(locationMessage,style: nunito14,),
        ],
      ),
      actions: [
        if (!isLoading)
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: Text("Close",style: nunito14),
          ),
      ],
    );
  }
}
Future<String> _getAddressFromCoordinates(Position position) async {
  List<Placemark> placemarks = await placemarkFromCoordinates(
    position.latitude,
    position.longitude,
  );
  Placemark place = placemarks[0];
  return "${place.name}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
}


