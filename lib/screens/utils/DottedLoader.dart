import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sahajghara/presentation/theme/app_images.dart';

import '../../presentation/theme/app_constants.dart';

class DottedLoader extends StatefulWidget {
  final String text;
  const DottedLoader({super.key, required this.text});

  @override
  State<DottedLoader> createState() => _DottedLoaderState();
}

class _DottedLoaderState extends State<DottedLoader> {
  int dotCount = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        dotCount = (dotCount + 1) % 4; // cycles 0 → 3 dots
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(AppImages.logo_circle,height: 110,width: 110, fit: BoxFit.cover),
        SizedBox(height: 10,),
          Text(
            "${widget.text}${"." * dotCount}",
            style: nunitoItalic14.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
