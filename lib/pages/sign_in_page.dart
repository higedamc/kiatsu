import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/auth/apple_auth.dart';
import 'package:kiatsu/auth/google_auth.dart';
import 'package:kiatsu/auth/line_auth.dart';
import 'package:kiatsu/auth/twitter_auth.dart';
import 'package:kiatsu/controller/user_controller.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';
import 'package:url_launcher/url_launcher.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var count = 0;
    final auth = FirebaseAuth.instance;
    final now = auth.currentUser;
    final isNoAds = ref.watch(userProvider.select((s) => s.isNoAdsUser));
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
                          buttonColor: Colors.white,
                          splashColor: Colors.white,
                          width: 280,
                          height: 50,
                          borderWidth: 1,
                          padding: const EdgeInsets.all(8),
                          elevation: 2,
                          borderRadius: 8,
                          separator: 15,
                          borderColor: Colors.black,
                          onPressed: () async {
                            await AppleAuthUtil.signInWithApple(context, ref)
                                .then<dynamic>(
                              (_) => Navigator.pop(context),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TwitterAuthButton(
                          buttonColor: Colors.white,
                          splashColor: Colors.white,
                          width: 280,
                          height: 50,
                          borderWidth: 1,
                          padding: const EdgeInsets.all(8),
                          elevation: 2,
                          borderRadius: 8,
                          separator: 15,
                          borderColor: Colors.black,
                          onPressed: () async => {
                            await TwitterAuthUtil.signInWithTwitter(context),

                            //TODO(Kohei): きちんとホーム画面に戻るかどうか確認
                            Navigator.popUntil(context, (_) => count++ >= 2),
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('ログインされました。'),
                              ),
                            ),
                          },
                        ),
                      ),
                      Platform.isAndroid
                          ? Padding(
                              padding: const EdgeInsets.all(8),
                              child: GoogleAuthButton(
                                  width: 280,
                                  height: 50,
                                  borderWidth: 1,
                                  padding: const EdgeInsets.all(8),
                                  elevation: 2,
                                  borderRadius: 8,
                                  separator: 15,
                                  borderColor: Colors.black,
                                  onPressed: () async => {
                                        GoogleAuthUtil.signInWithGoogle(
                                            context),
                                        Navigator.pop(context),
                                      }),
                            )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: 280,
                          height: 50,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              disabledForegroundColor:
                                  Colors.transparent.withOpacity(0.38),
                              disabledBackgroundColor:
                                  Colors.transparent.withOpacity(0.12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.fromLTRB(1, 10, 50, 10),
                            ),
                            onPressed: () async {
                              await LineAuthUtil.signIn(context)
                                  .then((_) => Navigator.pop(context));
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
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: 280,
                          height: 70,
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  const TextSpan(
                                      text: 'kiatsu の利用を開始することで、',
                                      style: TextStyle(color: Colors.black)),
                                  TextSpan(
                                    text: '利用規約',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await launch(
                                            'https://little-gourd-a5f.notion.site/a499f7c4ea1f473da3a00a2837c04be3');
                                      },
                                  ),
                                  const TextSpan(
                                    text: '及び、',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  TextSpan(
                                    text: 'プライバシーポリシー',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () async {
                                        await launch(
                                          'https://little-gourd-a5f.notion.site/3ed747b5a53440c9b05ae3528e7667b3',
                                        );
                                      },
                                  ),
                                  const TextSpan(
                                    text: 'に同意したものとみなします。',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    children: const [
                      Text('認証済'),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
