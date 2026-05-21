import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';
import 'package:sahajghara/screens/home/home_screen.dart';
import 'package:sahajghara/screens/intro_screen.dart';
import 'package:sahajghara/screens/auth/login_screen.dart';
import 'package:sahajghara/screens/splash_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'helpers/no_scroll.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

final currentRouteProvider = StateProvider<String>((ref) => '');
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

/// Navigator observer that publishes current route identifier (name or runtimeType).
class NavObserver extends NavigatorObserver {
  final Ref ref;

  NavObserver(this.ref);

  String _routeIdentifier(Route<dynamic>? route) {
    if (route == null) return '';
    final name = route.settings.name;
    if (name != null && name.isNotEmpty) return name;
    return route.runtimeType.toString();
  }

  void _update(Route<dynamic>? route) {
    final id = _routeIdentifier(route);

    // Post frame to avoid build errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentRouteProvider.notifier).state = id;
    });
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    _update(route);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    _update(previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _update(newRoute);
  }
}

class MyApp extends ConsumerWidget {
  MyApp({super.key});

  final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  final List<String> hideIdentifiers = [
    '/splash',
    '/login',
    '/intro',
    'Splashscreen',
    'LoginPage',
  ];

  Future<void> _openWhatsApp(BuildContext context) async {
    const phone = "918977667106";
    final message = Uri.encodeComponent(
      "Hi! I want to know more. Please assist me.",
    );
    final uri = Uri.parse("whatsapp://send?phone=$phone&text=$message");

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("WhatsApp not installed or invalid number."),
          ),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unable to open WhatsApp.")),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRoute = ref.watch(currentRouteProvider);

    final shouldHide = hideIdentifiers.contains(currentRoute);

    return ScreenUtilInit(
      designSize: const Size(360, 690),
      builder: (context, _) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'SahajGhara',
          scrollBehavior: NoScrollBehaviour(),
          theme: ThemeData(
            colorScheme:
            ColorScheme.fromSeed(seedColor: AppColors.primary),
          ),

          // 👇 Inject observer with ref
          navigatorObservers: [
            //NavObserver(ref),
          ],

          initialRoute: '/splash',

          routes: {
            '/splash': (_) => Splashscreen(),
            '/login': (_) => const LoginPage(),
            '/intro': (_) => const IntroScreen(),
            '/home': (_) => HomeScreen(
              address: "address",
              latitude: 1.1,
              longitude: 0.0,
            ),
          },

          // builder: (context, child) {
          //   return Stack(
          //     children: [
          //       child ?? const SizedBox(),
          //
          //       // ✅ Correct condition
          //       if (!shouldHide)
          //         Positioned(
          //           right: 10,
          //           bottom: 40,
          //           child: FloatingActionButton.extended(
          //             heroTag: "wa",
          //             backgroundColor: Colors.white,
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(20),
          //             ),
          //             onPressed: () => _openWhatsApp(context),
          //             icon: Image.asset(
          //               "assets/images/wapp.png",
          //               width: 22,
          //               height: 22,
          //             ),
          //             label: const Text(
          //               "Connect",
          //               style: TextStyle(
          //                 color: Colors.green,
          //                 fontSize: 14,
          //                 fontWeight: FontWeight.w600,
          //               ),
          //             ),
          //           ),
          //         ),
          //     ],
          //   );
          // },
        );
      },
    );
  }
}
