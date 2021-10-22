import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kiatsu/auth/apple_auth.dart';
import 'package:kiatsu/auth/github_auth.dart';
import 'package:kiatsu/auth/google_auth.dart';
import 'package:kiatsu/auth/twitter_auth.dart';
import 'package:kiatsu/utils/apple_signin_available.dart';
import 'package:provider/provider.dart';
import 'package:social_auth_buttons/res/buttons/apple_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/github_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/google_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/twitter_auth_button.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';



class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final now = _auth.currentUser;
    // ToDO: AppleAuthのboolが起動するか初期化して確認
    // ToDo: 上記確認後GitHubのIssueを閉じる
    return Scaffold(
      appBar: neu.NeumorphicAppBar(
        title: Text('アカウントページ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          (Platform.isIOS && now!.isAnonymous)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppleAuthButton(
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
                  ),
                )
              : Column(
                  children: [
                    (Platform.isAndroid)
                        ? Text('')
                        : Center(child: Text('認証済')),
                  ],
                ),
          (now!.isAnonymous)
              ? Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GithubAuthButton(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TwitterAuthButton(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GoogleAuthButton(
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
                                }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                        width: 280,
                        height: 50,
                          child: 
                          // ElevatedButton(
                          //   child: const Text('Sign in with LINE',
                          //   style: TextStyle(fontSize: 18)),
                          //   style: ElevatedButton.styleFrom(
                          //     // maximumSize: ,
                          //     primary: Colors.green[600],
                          //     onPrimary: Colors.white,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   onPressed: () async {
                          //     final result = LineSDK.instance.login();
                          //     print(result.toString());
                          //   },
                          // ),
                          ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                          primary: Colors.green[600],
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.fromLTRB(1, 10, 50, 10),
                          ),
                          onPressed: () async {
                          final result = LineSDK.instance.login();
                          },
                           icon: Image.asset('assets/images/line.png'),
                           label: Padding(
                             padding: const EdgeInsets.fromLTRB(11, 1, 1, 1),
                             child: Text('Sign in with LINE',
                              style: TextStyle(fontSize: 18),),
                           ),),
                        ),
                      ),
                    ],
                  ),
                )
              : Platform.isIOS
                  ? Text("")
                  : Center(child: Text('認証済')),
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
