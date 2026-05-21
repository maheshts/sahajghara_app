import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sahajghara/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/utillls.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_constants.dart';
import '../../presentation/theme/app_images.dart';


class OrderSuccess extends StatefulWidget {
  final orderAmount;
  final totalAmount;
  final orderNo;
  final propertyName;
  final propertyId;
  const OrderSuccess( {super.key,this.orderAmount,this.totalAmount,this.orderNo,this.propertyName,this.propertyId});

  @override
  State<OrderSuccess> createState() => _OrderSuccessState();
}

class _OrderSuccessState extends State<OrderSuccess> {


  gotoHome() async {
    Utills.customPrint("go HOme");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? add = prefs.getString("address");
    double? lat = prefs.getDouble("latitude");
    double? long = prefs.getDouble("longitude");
    Utills.customPrint('add $add');
    Utills.customPrint('lat $lat');
    Utills.customPrint('long $long');
    if (add != null && lat != null && long != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) =>
            HomeScreen(
                address: add.toString(), latitude: lat, longitude: long)),
            (Route<dynamic> route) => false,
      );
    }else {
      Utills.customPrint("Missing address or coordinates");
    }

  }


  @override
  Widget build(BuildContext context) {

    return  WillPopScope(


        onWillPop: () async => false,
        //await gotoHome();
        //return false;
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xfff7f6fb),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
             SizedBox(height: 10,),
               Text("Payment Success.",textAlign: TextAlign.center,style: nunitoItalic15,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                margin: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape:  BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(children: [
                  SizedBox(height: 12,),

                 // Lottie.asset('assets/lottie/successs.json',height: 150),
                  Lottie.asset(
                    'assets/lottie/successs.json',
                    height: 150,
                  ),

                  // FutureBuilder(
                  //   future: precacheImage(AssetImage('assets/lottie/successs.json'), context),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.connectionState == ConnectionState.done) {
                  //       return Lottie.asset('assets/lottie/successs.json', height: 150);
                  //     } else {
                  //       return SizedBox(height: 150); // or a placeholder
                  //     }
                  //   },
                  // ),

                  Text('₹${widget.totalAmount} paid to  Sahaja for ${widget.propertyName}',style: nunitoItalic15,textAlign: TextAlign.center,),
                  // Text("We have received your payment.",textAlign: TextAlign.center,style: nunitoItalic15,),
                  SizedBox(height: 12,),

                ],),
              ),
              // SizedBox(
              //     height: 120,
              //     child: RatingScreen(widget.propertyName,widget.orderNo,widget.propertyId)),

                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                     margin: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                     decoration: BoxDecoration(
                       color: Colors.deepPurple.shade50,
                       shape:  BoxShape.rectangle,
                       borderRadius: BorderRadius.circular(12),
                     ),
                     child: Column(children:[
                       SizedBox(height: 12),

                       Text("#${widget.orderNo} for future reference",textAlign: TextAlign.center,style: nunito16.copyWith(color: AppColors.black,fontWeight: FontWeight.w700),),
                       SizedBox(height: 16),

                             Image.asset(AppImages.logo_blue,height: 100,),

                       SizedBox(height: 16),
                       ElevatedButton(
                         style: ElevatedButton.styleFrom(
                           backgroundColor: Colors.white, // background color
                           foregroundColor: Colors.deepPurple, // text color
                           side: BorderSide(color: Colors.deepPurple, width: 1), // border
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(16), // rounded corners
                           ),
                           padding: EdgeInsets.symmetric(horizontal: 34, vertical: 12),
                         ),

                         onPressed: () => gotoHome(),
                         child: Text("Go To Home"),
                       ),
                       // InkWell(
                       //     onTap: (){
                       //       gotoHome();
                       //       },
                       //     child: CustomButton(text: "Go To Home",bgColor: Colors.grey.shade100,
                       //       textColor: AppColors.btnColor),borderRadius: BorderRadius.circular(16)),
                       SizedBox(height: 8),
                       //show rate option for property after 3 sec show donre button

                       // InkWell(
                       //     onTap: (){
                       //      // gotoHome();
                       //     },
                       //     child: CustomButton(text: "Rate Service",bgColor: Colors.black,
                       //         textColor: AppColors.logoYellow),borderRadius: BorderRadius.circular(16)),
                     //  InkWell(
                           // onTap: (){
                           //  // gotoHome();
                           //  //  Navigator.pushReplacement(
                           //  //    context,
                           //  //    MaterialPageRoute(builder: (context) => OrderHistory()),
                           //  //  );
                           //   Navigator.pushAndRemoveUntil(
                           //     context,
                           //     MaterialPageRoute(builder: (context) => OrderHistory()),
                           //         (Route<dynamic> route) => false,
                           //   );
                           // },
                           // child: CustomButton(text: "Transaction History",bgColor: Colors.white70,
                           //   textColor: Colors.deepOrange,),borderRadius: BorderRadius.circular(16)),

                             ]),
                   ),

            ],),
          ),
        ),
      ),
    );
  }
}
