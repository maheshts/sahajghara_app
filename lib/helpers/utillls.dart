import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utills {
  static double height(context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(context) {
    return MediaQuery.of(context).size.width;
  }

  static String getPercentageData(
      {required int totalValue, required int givenValue}) {
    if (totalValue == 0 && givenValue == 0) {
      return "0";
    }
    try {
      var data = (givenValue * 100) / totalValue;
      Utills.customPrint('percgg$data');
      return data.toStringAsFixed(0);
    } catch (error) {
      return "";
    }
  }

  static customPrint(value) {
    if (kDebugMode) {
       print(json.encode(value));
    }
  }

  checkOS() {
    return Platform.operatingSystem;
  }

  static String stripHtmlIfNeeded(String text) {
    // The regular expression is simplified for an HTML tag (opening or
    // closing) or an HTML escape. We might want to skip over such expressions
    // when estimating the text directionality.
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  static createFileFromBse64String(base64Image) {
    var fileImage = const Base64Decoder().convert(base64Image);
    return fileImage;
  }

  static String formatDate(String? date) {
    try {
      if (date == null || date.isEmpty) return "";
      final parsedDate = DateFormat("MM/dd/yyyy HH:mm:ss").parse(date);
      return DateFormat("dd-MMM-yyyy HH:mm").format(parsedDate);
    } catch (e) {
      return "";
    }
  }
  static epochToDate(int? inputDate) {
    final date =
        // DateTime.fromMillisecondsSinceEpoch(1640979000000, isUtc: true);
        DateTime.fromMillisecondsSinceEpoch(
            DateTime.now().timeZoneOffset.inMilliseconds + inputDate!,
            isUtc: false);
    print('checkinputDate $inputDate');
    // Utills.customPrint('omgdate$date');
    // var data=date.
    DateFormat formatter = DateFormat('dd-MM-yyyy');

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  static epochToDateComplaint(int? inputDate) {
    final date =
        // DateTime.fromMillisecondsSinceEpoch(1640979000000, isUtc: true);
        DateTime.fromMillisecondsSinceEpoch(inputDate!, isUtc: false);
    //print('checkinputDate $inputDate');
    // Utills.customPrint('omgdate$date');
    // var data=date.
    DateFormat formatter = DateFormat('dd-MM-yyyy');

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  static epochToDateTime(int? inputDate) {
    print("chckthat${DateTime.now().timeZoneOffset.inMilliseconds}");
    final date = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().timeZoneOffset.inMilliseconds + inputDate!,
        isUtc: true);
    // Utills.customPrint('omgdate$date');
    // var data=date.
    DateFormat formatter = DateFormat('dd-MM-yyyy hh:mm:ss a');

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  static epochToHMS(int? inputDate) {
    print("chckthat${DateTime.now().timeZoneOffset.inMilliseconds}");
    final date = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().timeZoneOffset.inMilliseconds + inputDate!,
        isUtc: true);
    // Utills.customPrint('omgdate$date');
    // var data=date.
    DateFormat formatter = DateFormat('hh:mm:ss');

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  static hMSWithMilliSecs(String? inputDate) {
    try {
      print('inputDate|$inputDate');
      DateFormat formatter = DateFormat('HHmmss.00');

      String formattedDate = formatter.format(DateTime.parse(inputDate!));

      print('finalTime|$formattedDate');

      // var secs = DateTime.parse(formattedDate).millisecondsSinceEpoch;

      return formattedDate.toString();
    } catch (err) {
      return "";
    }
  }

  static dMY(String? inputDate) {
    try {
      print('inputDate|$inputDate');
      DateFormat formatter = DateFormat('ddMMyy');

      String formattedDate = formatter.format(DateTime.parse(inputDate!));

      print('finalTime|$formattedDate');

      // var secs = DateTime.parse(formattedDate).millisecondsSinceEpoch;

      return formattedDate.toString();
    } catch (err) {
      return "";
    }
  }

  static epochToDateTimeForEvent(int? inputDate) {
    print("chckthassst$inputDate");
    final date = DateTime.fromMillisecondsSinceEpoch(inputDate!, isUtc: true);
    // Utills.customPrint('omgdate$date');
    // var data=date.
    DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm:ss a');

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  static epochToHMSNormal(int? inputDate) {
    print("chckthat${DateTime.now().timeZoneOffset.inMilliseconds}");
    final date =
        DateTime.fromMillisecondsSinceEpoch((inputDate!) * 1000, isUtc: true);
    // Utills.customPrint('omgdate$date');
    // var data=date.
    DateFormat formatter = DateFormat('hh:mm:ss');

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  static epochToHMSLocalTimeZone(int? inputDate) {
    print("chckthat${DateTime.now().timeZoneOffset.inMilliseconds}");
    final date =
        DateTime.fromMillisecondsSinceEpoch((inputDate!), isUtc: false);
    // Utills.customPrint('omgdate$date');
    // var data=date.
    // DateFormat formatter = DateFormat('hh:mm:ss');
    DateFormat formatter = DateFormat.Hms();

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  // static epochToHMSLocalTimeZoneSample(int? inputDate) {
  //   print("chckthat${DateTime.now().timeZoneOffset.inMilliseconds}");
  //   final date = DateTime.fromMillisecondsSinceEpoch((inputDate!), isUtc: true);
  //   // Utills.customPrint('omgdate$date');
  //   // var data=date.
  //   DateFormat formatter = DateFormat.Hms();

  //   // cDate = formatter1.format(currentDate);
  //   String formattedDate = formatter.format(date);
  //   // DateFormat.yMd().add_jms().format(date).toString();
  //   return formattedDate.toString();
  // }

  static epochToHMSMeridiane(int? inputDate) {
    print("chckthat${DateTime.now().timeZoneOffset.inMilliseconds}");
    final date = DateTime.fromMillisecondsSinceEpoch(
        DateTime.now().timeZoneOffset.inMilliseconds + inputDate!,
        isUtc: true);
    // Utills.customPrint('omgdate$date');
    // var data=date.
    DateFormat formatter = DateFormat('hh:mm:ss a');

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  static epochToHMSGMTMeridiane(int? inputDate) {
    print("chckthat${DateTime.now().timeZoneOffset.inMilliseconds}");
    final date = DateTime.fromMillisecondsSinceEpoch(inputDate!, isUtc: true);
    // Utills.customPrint('omgdate$date');
    // var data=date.
    DateFormat formatter = DateFormat('hh:mm:ss a');

    // cDate = formatter1.format(currentDate);
    String formattedDate = formatter.format(date);
    // DateFormat.yMd().add_jms().format(date).toString();
    return formattedDate.toString();
  }

  static launchUrl(url) async {
    Utills.customPrint("click $url");
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  static Future<bool> checkConnectivity() async {
    try {
      bool isConnected;
      var connectivity = await (Connectivity().checkConnectivity());
      if (connectivity == ConnectivityResult.mobile) {
        isConnected = true;
      } else if (connectivity == ConnectivityResult.wifi) {
        isConnected = true;
      } else {
        isConnected = false;
      }

      if (isConnected) {
        try {
          final result = await InternetAddress.lookup('google.com');
          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
            isConnected = true;
          }
        } on SocketException catch (_) {
          isConnected = false;
        }
      }

      return isConnected;
    } catch (e) {
      Utills.customPrint(
          'Exception - businessRule.dart - checkConnectivity():${e.toString()} ');
    }
    return false;
  }

  static showNetworkErrorSnackBar(context) {
    try {
      // bool isConnected;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(days: 1),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Icon(
              Icons.signal_wifi_off,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  'No internet available',
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
            textColor: Colors.white,
            label: 'RETRY',
            onPressed: () async {
              // checkConnectivity();
            }),
        backgroundColor: Colors.grey,
      ));
    } catch (e) {
      Utills.customPrint(
          'Exception - businessRule.dart - checkConnectivity():${e.toString()} ');
    }
  }

  static showOnlyLoaderDialog(context) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}


