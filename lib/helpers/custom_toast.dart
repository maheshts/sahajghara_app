import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:fluttertoast/fluttertoast.dart';

class CustomToast extends StatelessWidget {
  const CustomToast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container();

  // show snackbar

  static displaySnackBar(BuildContext context, {String? content}) {
    final snackBar = SnackBar(content: Text(content!));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

// show error toast
  static displayErrorToast({
    String? content,
  }) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: content.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // show warning toast

  static displayWarningToast({
    String? content,
  }) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: content.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.orangeAccent,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // show success toast

  static displaySuccessToast({
    String? content,
  }) {
    Fluttertoast.cancel();
    return Fluttertoast.showToast(
        msg: content.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
