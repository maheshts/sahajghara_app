import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sahajghara/presentation/theme/app_constants.dart';
import 'package:sahajghara/presentation/widgets/button/login_button.dart';

import 'location.dart';

class SignupSuccess extends StatelessWidget {
  const SignupSuccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Lottie.asset(
              'assets/lottie/success.json',

              //fit: BoxFit.fill,
            ),
            Text(
              'Account Created Successfully.',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50,),
            Text("Find reliable experts for every build",
                style:nunitoItalic14),
            InkWell(
              onTap: () async {
                String? address = await showDialog(
                  context: context,
                  barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
                  builder: (context) => LocationDialog(),
                );

              },
              child: LoginButton(


                  labeltext: "Continue"),
            )
          ],
        ),
      ),
    );
  }
}
