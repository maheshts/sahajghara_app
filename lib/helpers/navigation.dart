import 'package:flutter/material.dart';

class Navigation {
  static void sideNavigation(BuildContext context, Widget child) {
    Navigator.of(context).push(SlideTransitionPage(
      child: child,
    ));
  }

  static void replace(BuildContext context, Widget child) {
    Navigator.of(context).pushReplacement(SlideTransitionPage(
      child: child,
    ));
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static removeAll(BuildContext context, Widget child) {
    Navigator.pushAndRemoveUntil(
      context,
      SlideTransitionPage(
        child: child,
      ),
      (route) => false,
    );
  }
}

class SlideTransitionPage extends PageRouteBuilder {
  final Widget child;
  SlideTransitionPage({required this.child})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return child;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              transformHitTests: false,
              position:
                  Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.ease))
                      .animate(animation),
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset.zero,
                  end: const Offset(-1.0, 0.0),
                )
                    .chain(CurveTween(curve: Curves.ease))
                    .animate(secondaryAnimation),
                child: child,
              ),
            );
          },
        );
}
