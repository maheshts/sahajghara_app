import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sahajghara/controllers/home_controller.dart';
import 'package:sahajghara/screens/profile/contractor_enquiry_list.dart';
import 'package:sahajghara/screens/profile/my_activity.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../helpers/navigation.dart';
import '../../nwdata/api/api_contants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_constants.dart';
import '../auth/login_screen.dart';


//
// class ProfileScreen extends ConsumerStatefulWidget {
//
//   //final Function(int) onNavigate;
//   const ProfileScreen({super.key});
//
//   @override
//   ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
// }
// class _ProfileScreenState extends ConsumerState<ProfileScreen> {
//   var name ="Mahesh";
//   var fname ="";
//   var phone="8270951636";
//   final String recipientEmail = "info@sahajghara.com";
//   final String subject = "Feedback for SahajGhar App";
//   String _version = "";
//   String _buildNumber = "";
//   bool? enableVendor;
//   bool? enableContractor;
//   bool? requestVendor;
//   bool? requestContractor;
//   String vendorId ="";
//   String contractorId ="";
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       // executes after build
//      // await ref.read(homeControllerProvider).getProfileData(context);
//       final homeWatch = ref.read(homeControllerProvider);
//
//       enableContractor = homeWatch.homeResult!.enableContractor;
//       enableVendor = homeWatch.homeResult!.enableVendor;
//       requestVendor = homeWatch.homeResult!.requestVendor;
//       requestContractor = homeWatch.homeResult!.requestContractor;
//       contractorId = homeWatch.homeResult!.contractorCode!;
//       vendorId = homeWatch.homeResult!.vendorCode!.toString();
//     });
//     getData();
//     _loadVersion();
//   }
//   Future<void> _loadVersion() async {
//     final info = await PackageInfo.fromPlatform();
//     setState(() {
//       _version = info.version;       // e.g. 1.0.3
//       _buildNumber = info.buildNumber; // e.g. 12
//     });
//   }
//   void _sendEmail() async {
//     final Uri emailUri = Uri(
//       scheme: 'mailto',
//       path: recipientEmail,
//       queryParameters: {
//         'subject': subject,
//         'body': 'Hello,'
//         //'\n\nI would like to share my feedback:\n\n'
//       },
//     );
//     if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
//       throw 'Could not launch email app';
//     }
//     // if (await canLaunchUrl(emailUri)) {
//     //   await launchUrl(emailUri);
//     // } else {
//     //   debugPrint("Could not launch email app");
//     // }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //var profileWatch = ref.watch(profileControllerProvider);
//     //print("Profile status: ${profileWatch.profileStatus}");
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: AppColors.primary,
//           title: Text('More', style: nunitoItalic16.copyWith(fontSize: 21,color: Colors.white)),
//           leading: IconButton(
//             icon: Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
// actions: [
//             Padding(
//               padding: const EdgeInsets.only(right: 12),
//               child: TextButton.icon(
//                 onPressed: () {
//                   // TODO: navigate to PartnerWithUs page
//                   showPartnerBottomSheet(context);
//                 },
//                 icon: Icon(
//                   Icons.handshake_outlined,
//                   color: Colors.black87,
//                   size: 20,
//                 ),
//                 label: Text(
//                   "Partner with us",
//                   style: nunitoItalic15.copyWith(
//                     color: Colors.black87,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 style: TextButton.styleFrom(
//                   backgroundColor: Colors.grey.shade100,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//
//         ),
//
//       body:
//       SingleChildScrollView(
//         child: RefreshIndicator(
//           onRefresh: () async{
//            // ref.read(profileControllerProvider).getProfileData(context);
//
//           },
//           child: Column(
//             children: [
//
//               // Profile Section
//               Container(
//                 margin: const EdgeInsets.all(16),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: AppColors.btnColor, width: 1),
//                 ),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 24,
//                           backgroundColor: AppColors.primary,
//                           child:  Text(
//                             fname,
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               fontSize: 30,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               name,
//                               style:nunito16,
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   phone,
//                                   style: nunitoItalic14.copyWith(color: Colors.grey),
//                                 ),
//                                 const SizedBox(width: 6),
//                                 // Icon(Icons.edit, size: 16, color: Colors.orange),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//
//                   ],
//                 ),
//               ),
//
//               // List Sections
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       blurRadius: 8,
//                       spreadRadius: 2,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                     children: [
//                       ListTile(
//                         leading: Icon(Icons.shopping_cart_rounded, color: AppColors.primary),
//                         title:  Text("Vendor Enquiry",style: nunitoItalic13),
//                         trailing:   Icon(Icons.chevron_right, color: Colors.grey),
//                         onTap: () {
//                           Navigation.sideNavigation(context, MyActivity());
//                         },
//                       ),
//                       Divider(height: 1, color: Colors.grey.shade200),
//                       ListTile(
//                         leading: Icon(Icons.list_alt, color: AppColors.primary),
//                         title:  Text("Contractor Enquiry",style: nunitoItalic13),
//                         trailing:   Icon(Icons.chevron_right, color: Colors.grey),
//                         onTap: () {
//                           Navigation.sideNavigation(context, ContractorEnquiryList());
//                         },
//                       ),
//                       Divider(height: 1, color: Colors.grey.shade200),
//                     ]
//                 ),
//               ),
//
//               //  const Divider(),
//
//               Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     ListTile(
//                       leading:  Icon(Icons.group_add, color: AppColors.primary),
//                       title:  Text("Refer Sahaj Ghara",style: nunitoItalic13,),
//                       trailing:   Icon(Icons.chevron_right, color: Colors.grey),
//                       onTap: () {
//                         String shareText = "Hey! Check out this amazing app and earn money! 🎉\nDownload here";
//                         Share.share(shareText);
//                       },
//                     ),
//                     Divider(height: 1, color: Colors.grey.shade200),
//
//
//                     // ListTile(
//                     //   leading: const Icon(Icons.favorite, color: Colors.orange),
//                     //   title: const Text("Favourites"),
//                     //   trailing:  const Icon(Icons.chevron_right, color: Colors.grey),
//                     //   onTap: () {},
//                     // ),
//                     // Divider(height: 1, color: Colors.grey.shade200),
//
//                     ListTile(
//                       leading:  Icon(Icons.list_alt, color: AppColors.primary),
//                       title:  Text("FAQ",style: nunitoItalic13,),
//                       trailing:   Icon(Icons.chevron_right, color: Colors.grey),
//                       onTap: () {
//                         //Navigation.sideNavigation(context, FaqScreen());
//                       },
//                     ),
//                     Divider(height: 1, color: Colors.grey.shade200),
//
//                     ListTile(
//                       leading:  Icon(Icons.feedback, color: AppColors.primary),
//                       title:  Text("Send Feedback",style: nunitoItalic13,),
//                       trailing:   Icon(Icons.chevron_right, color: Colors.grey),
//                       onTap: () {
//                         //  Navigation.sideNavigation(context,FeedbackScreen());
//                         _sendEmail();
//                       },
//                     ),
//                     Divider(height: 1, color: Colors.grey.shade200),
//
//                     ListTile(
//                       leading:  Icon(Icons.delete_forever, color:AppColors.primary),
//                       title:  Text("Delete Account",style: nunitoItalic13,),
//                       trailing:   Icon(Icons.chevron_right, color: Colors.grey),
//                       onTap: () {
//                         _showDeleteDialog(context);
//                       },
//                     ),  Divider(height: 1, color: Colors.grey.shade200),
//
//                     ListTile(
//                       leading:  Icon(Icons.exit_to_app, color: AppColors.primary),
//                       title:  Text("Log out",style: nunitoItalic13,),
//                       trailing:   Icon(Icons.chevron_right, color: Colors.grey),
//                       onTap: () {
//                         _showLogoutDialog(context);
//                       },
//                     ),
//
//                     //Text("App Version: $_version ($_buildNumber)",style: nunitoItalic12White.copyWith(color: Colors.grey),),
//                   ],
//                 ),
//               ),
//              SizedBox(height: 8,),
//              Text("App Versions: $_version",style: nunitoItalic12White.copyWith(color: Colors.grey),),
//
//             ],
//           ),
//         ),
//       )
//           //:Center(child: Text("Reload again",style: nunitoItalic15,)),
//
//     );
//   }
//
//   Future<void> getData() async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     setState(() {
//       name = pref.getString(APIConstants.accountName)!;
//       phone = pref.getString(APIConstants.mobile)!;
//       fname = name.isNotEmpty? name.substring(0,1):"";
//     });
//   }
//   void _showLogoutDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Logout",style: nunito16,),
//           content: Text("Are you sure you want to logout?",style: nunitoItalic14,),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text("Cancel",style: nunitoItalic14,),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//                 _logout(context); // Perform logout
//               },
//               child: Text("Logout", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   void _showDeleteDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Delete Account",style: nunito16,),
//           content: Text("Are you sure! you want to delete your account?",style: nunitoItalic14,),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: Text("No",style: nunitoItalic14,),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//
//
//               },
//               child: Text("Yes", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//   Future<void> _logout(BuildContext context) async {
//     // Perform logout actions here
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     // bool isLogin = pref.getBool(APIConstants.authenticated) ?? false;
//     // Utills.customPrint('isLocation isLogin$isLogin');
//     pref.clear();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text("Logged out successfully")),
//     );
//     // Navigate to login screen if needed
//     // Navigator.pushReplacementNamed(context, "/login");
//
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginPage()),
//           (Route<dynamic> route) => false,
//     );
//   }
//
//   void showPartnerBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       backgroundColor: Colors.white,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//
//               Container(
//                 width: 50,
//                 height: 5,
//                 margin: EdgeInsets.only(bottom: 16),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//
//               Text(
//                 "Partner With Us",
//                 style: nunitoItalic16.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: AppColors.primaryDeep,
//                 ),
//               ),
//
//               SizedBox(height: 20),
//
//               _partnerOption(
//                 icon: Icons.store_mall_directory_outlined,
//                 title: "Vendor",
//                 onTap: () {
//                   Navigator.pop(context);
//                   // TODO: open vendor registration screen
//                   showThankYouDialog(context, "Vendor");
//                 },
//               ),
//
//               SizedBox(height: 12),
//
//               _partnerOption(
//                 icon: Icons.handshake_outlined,
//                 title: "Contractor",
//                 onTap: () {
//                   Navigator.pop(context);
//                   showThankYouDialog(context, "Contractor");
//                   //Navigation.sideNavigation(context, ContractorListScreen());
//                 },
//               ),
//
//               SizedBox(height: 42),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _partnerOption(
//       {required IconData icon, required String title, required VoidCallback onTap}) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: AppColors.primaryDeep, size: 26),
//             SizedBox(width: 14),
//             Text(
//               title,
//               style: nunitoItalic16.copyWith(color: AppColors.primaryDeep),
//             ),
//             Spacer(),
//             Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
//           ],
//         ),
//       ),
//     );
//   }
//
//   void showThankYouDialog(BuildContext context, String type) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//
//                 Icon(
//                   Icons.check_circle_outline,
//                   color: AppColors.primaryDeep,
//                   size: 60,
//                 ),
//
//                 SizedBox(height: 16),
//
//                 Text(
//                   "Thank You!",
//                   style: nunitoItalic16.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.primaryDeep,
//                   ),
//                 ),
//
//                 SizedBox(height: 10),
//
//                 Text(
//                   "Thank you for your interest.\nOur team will connect with you shortly.",
//                   textAlign: TextAlign.center,
//                   style: nunitoItalic14.copyWith(
//                     color: Colors.black87,
//                   ),
//                 ),
//
//                 SizedBox(height: 22),
//
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: AppColors.primaryDeep,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     "OK",
//                     style: nunitoItalic14.copyWith(color: Colors.white),
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }





