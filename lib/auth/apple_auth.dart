import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/providers/scaffold_messanger_provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

//TODO: #120 null安全にする

String? generateNonce([int length = 32]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(length, (_) => charset[random.nextInt(charset.length)])
      .join();
}

/// Returns the sha256 hash of [input] in hex notation.
String? sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

class AppleAuthUtil {
  /// サインイン中か
  static bool? isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;
  // emailが認証済みかどうか
  static bool? isEmailVerified() => getCurrentUser()!.emailVerified == true;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User?> signIn(BuildContext context, WidgetRef ref) async {
    final UserCredential? credential = await signInWithApple(context, ref);
    return credential!.user;
  }

  static Future<void> forceLink(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    final _user = _auth.currentUser;
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce!);

    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
            clientId: dotenv.env['FIREBASE_AUTH_CLIENT_ID']!,
            redirectUri: Uri.parse(
                'https://us-central1-apple-auth-server.cloudfunctions.net/hige')),
        nonce: nonce,
      );

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );
      await _user?.linkWithCredential(oAuthCredential);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'account-exists-with-different-credential' ||
          e.code == 'credential-already-in-use') {
        // User canceled the sign-in flow.
        String? email = e.email;
        AuthCredential? pendingCredential = e.credential;
        List<String?> userSignInMethods =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email!);
        if (userSignInMethods.contains('apple.com')) {
          // User has a different sign-in method.
          await _user!.linkWithCredential(pendingCredential!);
        }
      } else {
        print(e.code);
      }
    }
  }

  // TODO: サインインがうまくいくか (Firebaseに反映されるか) 実機で検証する
  static Future<UserCredential?> signInWithApple(
      BuildContext context, WidgetRef ref) async {
    
    final _auth = FirebaseAuth.instance;
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce!);

    // Request credential for the currently signed in Apple account.
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
            clientId: dotenv.env['FIREBASE_AUTH_CLIENT_ID']!,
            redirectUri: Uri.parse(
                'https://us-central1-apple-auth-server.cloudfunctions.net/hige')),
        nonce: nonce,
      );

      final oAuthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
        rawNonce: rawNonce,
      );

      return _auth
          .signInWithCredential(oAuthCredential)
          .then((authResult) async {
        final displayName = authResult.user?.displayName;
        final email = authResult.user?.email;
        final photoUrl = authResult.user?.photoURL;
        final uid = authResult.user?.uid;
        final providerData = authResult.user?.providerData;
        final firebaseUser = authResult.user;
        await firebaseUser?.updateDisplayName(displayName);
        await firebaseUser?.updateEmail(email.toString());
        await firebaseUser?.updatePhotoURL(photoUrl);
        print(
            'サインインされました: uid: $uid displayName: $displayName, email: $email, photoUrl: $photoUrl, uid: $uid, providerData: $providerData, firebaseUser: $firebaseUser');

        // return _auth.signInWithCredential(oAuthCredential);
      });
    } on SignInWithAppleAuthorizationException catch (e) {
      (e.code == AuthorizationErrorCode.canceled)
          ? 
          // ref
          //     .read(scaffoldMessengerProvider)
          //     .currentState
          //     ?.showAfterRemoveSnackBar(
          //         message: Text('ログインがキャンセルされました').toString())
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('ログインがキャンセルされました。')))
          : print(e.code);
    }
    
  }
}
