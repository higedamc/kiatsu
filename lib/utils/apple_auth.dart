import 'dart:convert';
import 'dart:math';
import 'package:apple_sign_in/apple_id_request.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/scope.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class AppleAuthUtil {
  // static final AppleSignIn _appleSignIn = AppleSignIn(
  //   // clientId: '********',
  //   // clientSecret: '********',
  //   // redirectUrl: 'https://********.firebaseapp.com/__/auth/handler',

  // );

  /// サインイン中か
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User> signIn(BuildContext context) async {
    // final UserCredential credential = await signInWithApple();
    final User user = await signInWithApple();
    // return credential.user;
    return user;
  }

  // ignore: missing_return
  static Future<User> signInWithApple({List<Scope> scopes = const[]}) async {
    // final rawNonce = generateNonce();
    // final nonce = sha256ofString(rawNonce);
    // // Request credential for the currently signed in Apple account.
    // final appleCredential = await SignInWithApple.getAppleIDCredential(
    //   scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
    //   ],
    //   nonce: nonce,
    // );
    //
    final res = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);
    switch (res.status) {
      case AuthorizationStatus.authorized:
        try {
          final AppleIdCredential appleIdCredential = res.credential;
          final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          // return await FirebaseAuth.instance.signInWithCredential(credential);
          final authResult =
              await FirebaseAuth.instance.signInWithCredential(credential);
          final firebaseUser = authResult.user;
          if (scopes.contains(Scope.fullName)) {
            final displayName =
                '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
            await firebaseUser.updateProfile(displayName: displayName);
          }
          return firebaseUser;
        } on PlatformException catch (e) {
          print(e.message);
        }
        print('サインインされました');
        break;
      case AuthorizationStatus.cancelled:
        // TODO: Handle this case.
        print('User cancelled');
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
        break;
      case AuthorizationStatus.error:
        // TODO: Handle this case.
        print("Sign in failed: ${res.error.localizedDescription}");
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DINED',
          message: res.error.toString(),
        );

        break;
      default:
        throw UnimplementedError();
    }
    // final res = await AppleSignIn.performRequests([AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);
    // final OAuthProvider oAuth = OAuthProvider('apple.com');
    // final AppleIdCredential appleIdCredential = res.credential;
    // final credential = oAuth.credential(
    //   idToken: String.fromCharCodes(appleIdCredential.identityToken),
    //   accessToken: String.fromCharCodes(appleIdCredential.authorizationCode),
    // );
    // Create an `OAuthCredential` from the credential returned by Apple.
    // final oauthCredential = OAuthProvider('apple.com').credential(
    //   idToken: appleCredential.identityToken,
    //   rawNonce: rawNonce,
    // );
    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    // return await FirebaseAuth.instance.signInWithCredential(credential);
    //  on FirebaseAuthException catch (e) {
    //   print(e.message);
  }
}
