import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';


class BioMetricAuthService {
  static Future<bool> authenticateUser() async {
    final LocalAuthentication _localAuthentication = LocalAuthentication();
    bool isAuthenticated = false;

    try {
      bool isBiometricSupported = await _localAuthentication.isDeviceSupported();
      bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
      if (isBiometricSupported && canCheckBiometrics) {
        isAuthenticated = await _localAuthentication.authenticate(
          localizedReason: 'Scan your fingerprint or face to authenticate',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );
      }
    } on PlatformException catch (e) {
      print("Error: $e");
    }
    return isAuthenticated;
  }
}