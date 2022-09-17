import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/auth/apple_auth.dart';
import 'package:kiatsu/auth/auth_manager.dart';
import 'package:kiatsu/auth/twitter_auth.dart';
import 'package:kiatsu/const/account_deletion_disclaimer.dart';
import 'package:kiatsu/controller/user_controller.dart';
import 'package:kiatsu/pages/timeline.dart';

class AccountDeletionPage extends ConsumerWidget {
  const AccountDeletionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteUserInfo = ref.read(userProvider);
    final isSignedIn = ref.read(authManagerProvider).isLoggedIn;
    final authUser = ref.read(authManagerProvider);
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('アカウント削除'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(shrinkWrap: true, children: <Widget>[
                const Text(accountDeletionPromt),
                const Text(''),
                const Text(
                  'アカウント',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(''),
                const Text(accountDeletion),
                const Text(''),
                RichText(
                  text: TextSpan(
                    text: 'kohei.otani@tutanota.com',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        //TODO: リジェクトされると怖いのでiOS版リリース後に下記の仕様に変える（笑）
                        // if (await canLaunch(params.toString())) {
                        //   await launch(params.toString());
                        // } else {
                        //   throw 'Could not launch ${params.toString()}';
                        // }
                        await Clipboard.setData(
                          const ClipboardData(text: myEmailAddress),
                        ).then(
                          (value) async =>
                              ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('メールアドレスをクリップボードにコピーしました'),
                            ),
                          ),
                        );
                      },
                  ),
                ),
                const Text(''),
                const Text(''),
                const Text(
                  'サブスクリプション',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(''),
                const Text(subscriptionDeletion),
                //TODO: サブスク解除ボタン。Androidで試す。
                // ElevatedButton(
                //   onPressed: () async {
                //     // final test = revenueCatUserInfo
                //     // .purchaserInfo!
                //     // .managementURL;
                //     final purchaserInfo =
                //         revenueCatUserInfo.purchaserInfo!.managementURL;
                //     log(purchaserInfo.toString());
                //     await launch(purchaserInfo.toString());
                //   },
                //   style: ElevatedButton.styleFrom(
                //     // minimumSize: const Size.fromHeight(50),
                //     primary: Colors.redAccent,
                //   ),
                //   child: const Text(
                //     '解除',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                const Text(''),
                const Text(
                  accountDeletionConirmation,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ElevatedButton(
                  onPressed: () async => showDialog<Widget>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(accountDeletionFinalPrompt),
                        content: const Text('本当に削除しますか？'),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel')),
                          TextButton(
                            onPressed: () async {
                              //TODO: あまりにも汚すぎるのでリリース後リファクタリングしようね♡
                              final CollectionReference users =
                                  firebaseStore.collection('users');
                              final test =
                                  await users.doc(currentUser?.uid).get();
                              final dynamic authProvider = test
                                  .get(FieldPath.fromString('authProvider'));
                              final setData = <String, dynamic>{
                                'isDeletedUser': true,
                              };
                              switch (authProvider.toString()) {
                                case 'twitter.com':
                                  final twitterAuthCredential =
                                      await TwitterAuthUtil
                                          .getTwitterAuthCredential(context);
                                  await deleteUserInfo.user!
                                      .reauthenticateWithCredential(
                                          twitterAuthCredential!);
                                  // isDeletedをtrueにして削除フラグを立てる
                                  await users
                                      .doc(currentUser?.uid)
                                      .update(setData);
                                  // 一旦OAuthとunlinkして匿名アカウント化
                                  await deleteUserInfo.user!
                                      .unlink(authProvider.toString());
                                  // ログインしているユーザーの投稿を全削除
                                  await users
                                      .doc(currentUser!.uid)
                                      .collection('comments')
                                      .get()
                                      .then((snapshot) {
                                    //TODO: for each loop使わない方法を後で模索する（）
                                    for (DocumentSnapshot ds in snapshot.docs) {
                                      ds.reference.delete();
                                    }
                                  });
                                  await deleteUserInfo.user!.delete();
                                  await authUser
                                      .signOut()
                                      .then(
                                        (_) async =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                          const SnackBar(
                                            content: Text('アカウントが削除されました！'),
                                          ),
                                        ),
                                      )
                                      .then(
                                        (_) async =>
                                            Navigator.pushReplacementNamed(
                                                context, '/onbo'),
                                      );

                                  break;
                                case 'line':
                                  log('this might be line');
                                  break;
                                case 'apple.com':
                                  final appleOAuthCredential =
                                      await AppleAuthUtil
                                          .getAppleOAuthCredential(context);
                                  await deleteUserInfo.user!
                                      .reauthenticateWithCredential(
                                          appleOAuthCredential!);
                                  // isDeletedをtrueにして削除フラグを立てる
                                  await users
                                      .doc(currentUser?.uid)
                                      .update(setData);
                                  // 一旦OAuthとunlinkして匿名アカウント化
                                  await deleteUserInfo.user!
                                      .unlink(authProvider.toString());
                                  // ログインしているユーザーの投稿を全削除
                                  await users
                                      .doc(currentUser!.uid)
                                      .collection('comments')
                                      .get()
                                      .then((snapshot) {
                                    //TODO: for each loop使わない方法を後で模索する（）
                                    for (DocumentSnapshot ds in snapshot.docs) {
                                      ds.reference.delete();
                                    }
                                  });
                                  await deleteUserInfo.user!.delete();
                                  // await deleteUserInfo.user!.unlink('twitter.com');
                                  await authUser
                                      .signOut()
                                      .then(
                                        (_) async =>
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                          const SnackBar(
                                            content: Text('アカウントが削除されました！'),
                                          ),
                                        ),
                                      )
                                      .then(
                                        (_) async => Navigator.pushNamed(
                                            context, '/onbo'),
                                      );
                                  log('this might be apple');
                                  break;
                                default:
                                  break;
                              }
                            },
                            child: const Text(
                              'OK',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  style: ElevatedButton.styleFrom(
                    // minimumSize: const Size.fromHeight(50),
                    primary: Colors.redAccent,
                  ),
                  //TODO: 同意すると削除ボタンが押せるようにする。
                  child: const Text(
                    '削除',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
