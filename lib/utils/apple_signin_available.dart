

// 参考: https://codewithandrea.com/videos/apple-sign-in-flutter-firebase/

import 'package:the_apple_sign_in/the_apple_sign_in.dart';

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await TheAppleSignIn.isAvailable());
  }
}