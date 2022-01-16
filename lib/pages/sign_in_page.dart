import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/auth/apple_auth.dart';
import 'package:kiatsu/auth/google_auth.dart';
import 'package:kiatsu/auth/line/auth_manager.dart';
import 'package:kiatsu/auth/line_auth.dart';
import 'package:kiatsu/auth/twitter_auth.dart';
import 'package:kiatsu/pages/custom_dialog_box.dart';
import 'package:social_auth_buttons/res/buttons/apple_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/github_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/google_auth_button.dart';
import 'package:social_auth_buttons/res/buttons/twitter_auth_button.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _auth = FirebaseAuth.instance;
    final now = _auth.currentUser;
    // ToDO: AppleAuthのboolが起動するか初期化して確認
    // ToDo: 上記確認後GitHubのIssueを閉じる
    return Scaffold(
      appBar: neu.NeumorphicAppBar(
        title: const Text('アカウントページ'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //TODO: #131 Androidでのログイン時の処理をどうするか決める
          (now == null)
              ? Center(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AppleAuthButton(
                          width: 280.0,
                          height: 50.0,
                          borderWidth: 1.0,
                          padding: const EdgeInsets.all(8.0),
                          elevation: 2.0,
                          borderRadius: 8.0,
                          separator: 15.0,
                          borderColor: Colors.black,
                          onPressed: () async {
                            if (now == null) {
                              // await AppleAuthUtil.forceLink(context);
                              await AppleAuthUtil.signInWithApple(context);
                              Navigator.pop(context);
                              print(now?.uid);
                            } else {
                              print('Apple IDでサイン済み');
                            }
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: GithubAuthButton(
                      //       width: 280.0,
                      //       height: 50.0,
                      //       borderWidth: 1.0,
                      //       padding: const EdgeInsets.all(8.0),
                      //       elevation: 2.0,
                      //       borderRadius: 8.0,
                      //       separator: 15.0,
                      //       borderColor: Colors.black,
                      //       text: 'Sign in with GitHub',
                      //       onPressed: () async => {
                      //             GithubAuthUtil.signInWithGithub(context),
                      //             Navigator.pop(context),
                      //           }),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TwitterAuthButton(
                            width: 280.0,
                            height: 50.0,
                            borderWidth: 1.0,
                            padding: const EdgeInsets.all(8.0),
                            elevation: 2.0,
                            borderRadius: 8.0,
                            separator: 15.0,
                            borderColor: Colors.black,
                            onPressed: () => {
                                  TwitterAuthUtil.signInWithTwitter(context),
                                }),
                      ),
                      Platform.isAndroid
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GoogleAuthButton(
                                  width: 280.0,
                                  height: 50.0,
                                  borderWidth: 1.0,
                                  padding: const EdgeInsets.all(8.0),
                                  elevation: 2.0,
                                  borderRadius: 8.0,
                                  separator: 15.0,
                                  borderColor: Colors.black,
                                  onPressed: () async => {
                                        GoogleAuthUtil.signInWithGoogle(
                                            context),
                                        Navigator.pop(context),
                                      }),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 280,
                          height: 50,
                          child:
                              ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green[600],
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.fromLTRB(1, 10, 50, 10),
                            ),
                            onPressed: () async {
                              await LineAuthUtil.signIn(context);
                              // await ref.read(authManagerProvider).signInWithLine();
                              Navigator.pop(context);
                              // showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return CustomDialogBox(
                              //         title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                              //         descriptions: 'この機能はまだ未実装です♡',
                              //         text: 'りょ',
                              //         key: UniqueKey(),
                              //       );
                              //     });
                            },
                            icon: Image.asset('assets/images/line.png'),
                            label: const Padding(
                              padding: EdgeInsets.fromLTRB(11, 1, 1, 1),
                              child: Text(
                                'Sign in with LINE',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text('認証済')),
        ],
      ),
    );
  }
}
