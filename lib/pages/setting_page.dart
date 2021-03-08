import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:settings_ui/settings_ui.dart';
// import 'package:kiatsu/auth/apple_signin_available.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<UserCredential> signInAnon() async {
    UserCredential user = await firebaseAuth.signInAnonymously();
    return user;
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    String generateNonce([int length = 32]) {
      final charset =
          '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
      final random = Random.secure();
      return List.generate(
          length, (_) => charset[random.nextInt(charset.length)]).join();
    }

    /// Returns the sha256 hash of [input] in hex notation.
    String sha256ofString(String input) {
      final bytes = utf8.encode(input);
      final digest = sha256.convert(bytes);
      return digest.toString();
    }

    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    //  return await signInAnon().then((UserCredential user) => user.user.linkWithCredential(oauthCredential));
    // final appleIdCredential = await SignInWithApple.getAppleIDCredential(
    //   scopes: [
    //     AppleIDAuthorizationScopes.email,
    //     AppleIDAuthorizationScopes.fullName,
    //   ],
    //   );
    // final oAuthProvider = OAuthProvider('apple.com');
    // final credential = oAuthProvider.getCredential(
    //   idToken: appleIdCredential.identityToken,
    //   accessToken: appleIdCredential.authorizationCode,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: SettingsList(
        key: _scaffoldKey,
        sections: [
          SettingsSection(
            title: 'デバッグ用',
            tiles: [
              SettingsTile(
                title: '強制クラッシュ',
                subtitle: '押',
                leading: NeumorphicIcon(Icons.language),
                onTap: () {
                  FirebaseCrashlytics.instance.crash();
                },
              ),
              // SettingsTile.switchTile(
              //   title: 'Use fingerprint',
              //   leading: Icon(Icons.fingerprint),
              //   switchValue: value,
              //   onToggle: (bool value) {},
              // ),
            ],
          ),
          SettingsSection(
            title: 'アカウント管理',
            tiles: [
              SettingsTile(
                  title: 'Apple IDでサインインする',
                  subtitle: '押',
                  leading: NeumorphicIcon(Icons.account_circle_outlined),
                  onPressed: (context) async {
                    await signInWithApple();
                  }),
              SettingsTile(
                title: 'アカウント削除',
                subtitle: '押',
                leading: NeumorphicIcon(Icons.language),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('CAUTION!!!'),
                          content:
                              Text('Do you really want to delete account?'),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel')),
                            FlatButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  var currentUser = firebaseAuth.currentUser;
                                  await currentUser.delete();
                                },
                                child: Text('OK')),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
