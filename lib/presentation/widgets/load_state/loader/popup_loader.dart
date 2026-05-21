import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../helpers/utillls.dart';
import '../../../theme/app_constants.dart';
import '../../../theme/app_theme.dart';

class PopupLoader {
  static PopupLoader? _PopupLoader;

  PopupLoader._createObject();

  factory PopupLoader() {
    if (_PopupLoader != null) {
      return _PopupLoader!;
    } else {
      _PopupLoader = PopupLoader._createObject();
      return _PopupLoader!;
    }
  }

  //static OverlayEntry _overlayEntry;
  OverlayState? _overlayState; //= new OverlayState();
  OverlayEntry? _overlayEntry;

  _buildLoader(context) {
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: buildLoader(context));
      },
    );
  }

  showLoader(context) {
    _overlayState = Overlay.of(context);
    _buildLoader(context);
    _overlayState!.insert(_overlayEntry!);
  }

  hideLoader() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      Utills.customPrint("Exception:: $e");
    }
  }

  buildLoader(BuildContext context, {Color? backgroundColor}) {
    backgroundColor ??= const Color(0xffa8a8a8).withOpacity(.5);
    var height = 150.0;
    return CustomScreenLoader(
      height: height,
      width: height,
      backgroundColor: backgroundColor,
    );
  }
}

class CustomScreenLoader extends StatelessWidget {
  final Color backgroundColor;
  final double height;
  final double width;
  const CustomScreenLoader(
      {Key? key,
      this.backgroundColor = const Color(0xfff8f8f8),
      this.height = 30,
      this.width = 30})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Container(
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Container(
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          decoration: const BoxDecoration(
              color: Colors.white60,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Platform.isIOS
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoActivityIndicator(
                          radius: 15.sp,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Material(
                            color: Colors.transparent,
                            child: Text(
                              "Please wait..",
                              style: nunitoItalic15,
                            ))
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          strokeWidth: 3,
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Material(
                            color: Colors.transparent,
                            child: Text(
                              "Please wait..",
                              style: AppTheme.run().textTheme.bodySmall,
                            ))
                      ],
                    ),
              // Image.asset(
              //   'assets/images/icon-480.png',
              //   height: 30,
              //   width: 30,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
