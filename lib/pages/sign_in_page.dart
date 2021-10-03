import 'dart:io';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:kiatsu/auth/apple_auth.dart';
import 'package:kiatsu/auth/github_auth.dart';
import 'package:kiatsu/auth/google_auth.dart';
import 'package:kiatsu/auth/twitter_auth.dart';
import 'package:kiatsu/utils/apple_signin_available.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:provider/provider.dart';
import 'package:social_auth_buttons/res/buttons/apple_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/github_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/google_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/twitter_auth_button.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final now = _auth.currentUser;
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    return Scaffold(
      appBar: neu.NeumorphicAppBar(
        title: Text('アカウントページ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (appleSignInAvailable.isAvailable && now!.isAnonymous)
              ? AppleAuthButton(
                  width: 280.0,
                  height: 50.0,
                  borderWidth: 1.0,
                  padding: EdgeInsets.all(8.0),
                  elevation: 2.0,
                  borderRadius: 8.0,
                  separator: 15.0,
                  borderColor: Colors.black,
                  onPressed: () async {
                    if (now.isAnonymous) {
                      await AppleAuthUtil.forceLink(context);
                      print(now.uid);
                    } else {
                      print('Apple IDでサイン済み');
                    }
                  },
                )
              : Column(
                  children: [
                    (Platform.isAndroid) ? Text('') : Center(child: Text('認証済')),
                  ],
                ),
          (now!.isAnonymous)
              ? Center(
                child: Column(
                    children: [
                      GithubAuthButton(
                          width: 280.0,
                          height: 50.0,
                          borderWidth: 1.0,
                          padding: EdgeInsets.all(8.0),
                          elevation: 2.0,
                          borderRadius: 8.0,
                          separator: 15.0,
                          borderColor: Colors.black,
                          text: 'Sign in with GitHub',
                          onPressed: () => {
                                GithubAuthUtil.signInWithGithub(context),
                              }),
                      TwitterAuthButton(
                          width: 280.0,
                          height: 50.0,
                          borderWidth: 1.0,
                          padding: EdgeInsets.all(8.0),
                          elevation: 2.0,
                          borderRadius: 8.0,
                          separator: 15.0,
                          borderColor: Colors.black,
                          onPressed: () => {
                            TwitterAuthUtil.signInWithTwitter(context),
                          }),
                      GoogleAuthButton(
                        width: 280.0,
                          height: 50.0,
                          borderWidth: 1.0,
                          padding: EdgeInsets.all(8.0),
                          elevation: 2.0,
                          borderRadius: 8.0,
                          separator: 15.0,
                          borderColor: Colors.black,
                        onPressed: () async => {
                          GoogleAuthUtil.signInWithGoogle(context),
                          Navigator.pop(context),
                        }
                        ),

                    ],
                  ),
              )
              : appleSignInAvailable.isAvailable ? Text("") : Center(child: Text('認証済')),
          // サインアウトボタン
          // (AppleAuthUtil.isSignedIn()) ?
          // NeumorphicButton(
          //   tooltip: 'サインアウトする',
          //   style: NeumorphicStyle(
          //     color: Colors.black,
          //   ),
          //   onPressed: () => {
          //     AppleAuthUtil.signOut(),
          //   },
          // ) : Center(),
        ],
      ),
    );
  }
}
