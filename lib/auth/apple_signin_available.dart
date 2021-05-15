import 'package:apple_sign_in/apple_sign_in.dart';

// 参考: https://codewithandrea.com/videos/apple-sign-in-flutter-firebase/

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await AppleSignIn.isAvailable());
  }
}