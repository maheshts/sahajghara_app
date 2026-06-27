import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sahajghara/controllers/vendor_controller.dart';
import 'package:sahajghara/helpers/custom_toast.dart';
import 'package:sahajghara/helpers/utillls.dart';
import 'package:sahajghara/screens/contractor/portfolio_list.dart';
import 'package:sahajghara/screens/profile/contractor/contractor_profile.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_enquirys.dart';
import 'package:sahajghara/screens/profile/vendor/vendor_profile.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/home_controller.dart';
import '../../helpers/navigation.dart';
import '../../nwdata/api/api_contants.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_constants.dart';
import '../../presentation/theme/app_images.dart';
import '../auth/login_screen.dart';
import 'contractor/my_contractor_enquirys.dart';
import 'contractor_enquiry_list.dart';
import 'my_activity.dart';

enum ProfileAction {
  refer,
  faq,
  feedback,
  deleteAccount,
  logout,
  vendorenquiry,
  myvendorenquiry,
  contractorenquiry,
  mycontractorenquiry,
  contractorportfolio,
  contractorprofile,
  vendorprofile,
}

class ProfileScreens extends ConsumerStatefulWidget {
  const ProfileScreens({super.key});

  @override
  ConsumerState<ProfileScreens> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreens> {
  var name = "Mahesh";
  var fname = "";
  var phone = "8270951636";
  final String recipientEmail = "info@sahajghara.com";
  final String subject = "Feedback for SahajGhar App";
  String _version = "";
  String _buildNumber = "";
  bool enableVendor = false;
  bool enableContractor = false;
  bool requestVendor = false;
  bool requestContractor = false;
  String vendorId = "";
  String contractorId = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // executes after build
      // await ref.read(homeControllerProvider).getProfileData(context);
      final homeWatch = ref.read(homeControllerProvider);

      enableContractor = homeWatch.homeResult!.enableContractor!;
      enableVendor = homeWatch.homeResult!.enableVendor!;
      requestVendor = homeWatch.homeResult!.requestVendor!;
      requestContractor = homeWatch.homeResult!.requestContractor!;
      contractorId = homeWatch.homeResult!.contractorCode!;
      vendorId = homeWatch.homeResult!.vendorCode!.toString();
    });
    getData();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _version = info.version; // e.g. 1.0.3
      _buildNumber = info.buildNumber; // e.g. 12
    });
  }

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: recipientEmail,
      queryParameters: {
        'subject': subject,
        'body': 'Hello,',
        //'\n\nI would like to share my feedback:\n\n'
      },
    );
    if (!await launchUrl(emailUri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch email app';
    }
    // if (await canLaunchUrl(emailUri)) {
    //   await launchUrl(emailUri);
    // } else {
    //   debugPrint("Could not launch email app");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        // leading: const BackButton(color: Colors.black),
        // title: const Text("My Profile", style: TextStyle(color: Colors.black)),
        title: Text(
          "My Profile",
          style: nunitoItalic16.copyWith(fontSize: 18, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              onPressed: () {
                // TODO: navigate to PartnerWithUs page
                var profileRead = ref.read(vendorControllerProvider);
                showPartnerBottomSheet(context, profileRead);
              },
              icon: Icon(
                Icons.handshake_outlined,
                color: Colors.black87,
                size: 18,
              ),
              label: Text(
                "Partner with us",
                style: nunitoItalic15.copyWith(
                  color: Colors.black87,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: true,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _profileCard(),
              const SizedBox(height: 16),

              if (requestContractor)
                pendingRequestCard(
                  title: "Contractor verification pending",
                  message:
                      "Your contractor request is under verification. This usually takes 24–48 hours.",
                ),

              if (requestVendor)
                pendingRequestCard(
                  title: "Vendor verification pending",
                  message:
                      "Your vendor request is under verification. You will be notified once approved.",
                ),

              if (enableContractor)
                _sectionCard(
                  title: "Contractor : #$contractorId",
                  items: [
                    _item(
                      Icons.question_answer_outlined,
                      "My Enquiry",
                      action: ProfileAction.mycontractorenquiry,
                    ),
                    _item(
                      Icons.person_outline,
                      "Profile",
                      action: ProfileAction.contractorprofile,
                    ),
                    _item(
                      Icons.work_outline,
                      "Portfolio",
                      action: ProfileAction.contractorportfolio,
                    ),
                  ],
                ),

              if (enableVendor)
                _sectionCard(
                  title: "Vendor : #$vendorId",
                  items: [
                    _item(
                      Icons.question_answer_outlined,
                      "My Enquiry",
                      action: ProfileAction.myvendorenquiry,
                    ),
                    _item(
                      Icons.person_outline,
                      "Profile",
                      action: ProfileAction.vendorprofile,
                    ),
                  ],
                ),

              _sectionCard(
                title: "Other Information",
                items: [
                  _item(
                    Icons.shopping_bag_outlined,
                    "Vendor Enquiry",
                    action: ProfileAction.vendorenquiry,
                  ),
                  _item(
                    Icons.engineering_rounded,
                    "Contractor Enquiry",
                    action: ProfileAction.contractorenquiry,
                  ),
                  _item(
                    Icons.group_add_outlined,
                    "Refer SahajGhara",
                    action: ProfileAction.refer,
                  ),
                  _item(Icons.help_outline, "FAQ", action: ProfileAction.faq),
                  _item(
                    Icons.feedback_outlined,
                    "Send Feedback",
                    action: ProfileAction.feedback,
                  ),
                  _item(
                    Icons.delete_outline,
                    "Delete Account",
                    isDelete: true,
                    action: ProfileAction.deleteAccount,
                  ),
                  _item(
                    Icons.logout,
                    "Logout",
                    isLogout: true,
                    action: ProfileAction.logout,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                "App Versions: $_version",
                style: nunitoItalic12White.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Widgets ----------------

  Widget _profileCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$name",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 4),
                Text("$phone", style: TextStyle(color: Colors.grey)),
                // SizedBox(height: 2),
                // Text("+91 7735625005",
                //     style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),

          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(AppImages.logo_circle),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> items}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
          const Divider(height: 1),
          ...items,
        ],
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title, {
    bool isLogout = false,
    bool isDelete = false,
    ProfileAction? action,
  }) {
    return ListTile(
      dense: true,
      leading: Icon(
        icon,
        size: 20,
        color: isLogout || isDelete ? Colors.red : AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout || isDelete ? Colors.red : Colors.black87,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, size: 18, color: Colors.grey),
      onTap: () => _onItemTap(action),
    );
  }

  void _onItemTap(ProfileAction? action) {
    Utills.customPrint('Profile action: $action');

    switch (action) {
      case ProfileAction.refer:
        String shareText = '''
🏠 Build Smarter with Sahaj Ghara!

Download Sahaj Ghara today and access the best building material supply platform for all your construction needs.

✅ Order construction materials online
✅ Compare prices from trusted suppliers
✅ Connect directly with suppliers
✅ Save time and reduce construction costs
✅ Get quality materials delivered to your doorstep

📲 Download Now:
https://play.google.com/store/apps/details?id=com.app.sahajghara

🚀 Start building with confidence using Sahaj Ghara!
''';

        Share.share(shareText);

        Share.share(shareText);
        // Navigator.push(...);
        break;

      case ProfileAction.faq:
        debugPrint("Navigate to FAQ");
        break;

      case ProfileAction.feedback:
        _sendEmail();
        break;
      case ProfileAction.contractorportfolio:
        Navigation.sideNavigation(context, PortfolioScreen());

        break;

      case ProfileAction.deleteAccount:
        _showDeleteDialog(context);
        break;
      case ProfileAction.logout:
        _onLogout();
        break;
      case ProfileAction.contractorenquiry:
        Navigation.sideNavigation(context, ContractorEnquiryList());
      case ProfileAction.vendorenquiry:
        Navigation.sideNavigation(context, MyActivity());
      case ProfileAction.mycontractorenquiry:
        Navigation.sideNavigation(context, MyContractorEnquirys());
      case ProfileAction.myvendorenquiry:
        Navigation.sideNavigation(context, VendorEnquirys(itemStatus: 0,));
      case ProfileAction.contractorprofile:
        Navigation.sideNavigation(context, ContractorProfileScreen());
      case ProfileAction.vendorprofile:
       Navigation.sideNavigation(context, VendorProfileScreen());
      default:
        break;
    }
  }

  // ---------------- Logic ----------------

  void _onLogout() {
    // TODO: implement logout logic using Riverpod
    _showLogoutDialog(context);
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    );
  }

  Future<void> getData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString(APIConstants.accountName)!;
      phone = pref.getString(APIConstants.mobile)!;
      fname = name.isNotEmpty ? name.substring(0, 1) : "";
    });
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Logout", style: nunito16),
        content: Text(
          "Are you sure you want to logout?",
          style: nunitoItalic14,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Cancel", style: nunitoItalic14),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _logout(context); // Perform logout
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

void _showDeleteDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete Account", style: nunito16),
        content: Text(
          "Are you sure! you want to delete your account?",
          style: nunitoItalic14,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("No", style: nunitoItalic14),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      );
    },
  );
}

Future<void> _logout(BuildContext context) async {
  // Perform logout actions here
  SharedPreferences pref = await SharedPreferences.getInstance();
  // bool isLogin = pref.getBool(APIConstants.authenticated) ?? false;
  // Utills.customPrint('isLocation isLogin$isLogin');
  pref.clear();
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(SnackBar(content: Text("Logged out successfully")));
  // Navigate to login screen if needed
  // Navigator.pushReplacementNamed(context, "/login");

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPage()),
    (Route<dynamic> route) => false,
  );
}

void showPartnerBottomSheet(
  BuildContext context,
  VendorController profileRead,
) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              margin: EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Text(
              "Partner With Us",
              style: nunitoItalic16.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDeep,
              ),
            ),

            SizedBox(height: 20),

            _partnerOption(
              icon: Icons.store_mall_directory_outlined,
              title: "Vendor",
              onTap: () {
                profileRead.submitRequest(1).then((response) {
                  if (response.isSuccess) {
                    Navigator.pop(context);
                    // TODO: open vendor registration screen
                    showThankYouDialog(context, "Vendor");
                  } else {
                    CustomToast.displayErrorToast(content: response.message);
                  }
                });
              },
            ),

            SizedBox(height: 12),

            _partnerOption(
              icon: Icons.handshake_outlined,
              title: "Contractor",
              onTap: () {
                profileRead.submitRequest(2).then((response) {
                  if (response.isSuccess) {
                    Navigator.pop(context);
                    showThankYouDialog(context, "Contractor");
                  } else {
                    CustomToast.displayErrorToast(content: response.message);
                  }
                });

                //Navigation.sideNavigation(context, ContractorListScreen());
              },
            ),

            SizedBox(height: 42),
          ],
        ),
      );
    },
  );
}

Widget _partnerOption({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryDeep, size: 26),
          SizedBox(width: 14),
          Text(
            title,
            style: nunitoItalic16.copyWith(color: AppColors.primaryDeep),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    ),
  );
}

void showThankYouDialog(BuildContext context, String type) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: AppColors.primaryDeep,
                size: 60,
              ),

              SizedBox(height: 16),

              Text(
                "Thank You!",
                style: nunitoItalic16.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDeep,
                ),
              ),

              SizedBox(height: 10),

              Text(
                "Thank you for your interest.\nOur team will connect with you shortly.",
                textAlign: TextAlign.center,
                style: nunitoItalic14.copyWith(color: Colors.black87),
              ),

              SizedBox(height: 22),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDeep,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "OK",
                  style: nunitoItalic14.copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget pendingRequestCard({
  required String title,
  required String message,
  IconData icon = Icons.hourglass_top_rounded,
}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF7E6),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: const Color(0xFFFFD59A)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFFFE2B8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.orange.shade800, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  // optional support navigation
                },
                child: const Text(
                  "Contact support",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
