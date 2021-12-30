import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/pages/custom_dialog_box.dart';

import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wiredash/wiredash.dart';

//TODO: #115 サインアップ時に設定ページの表示が更新されるようにする
//TODO: Android版の文字の色を変える
//TODO: #127 #126 アプリバージョン取得方法をFutureBuilder使わずにやる

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final currentUser = firebaseAuth.currentUser;
// test1
final currentPurchaser = PurchaseApi.getCurrentPurchaser();

final userProvider = StateProvider((ref) {
  return FirebaseAuth.instance.currentUser;
});

// Future<String?> _getAppVersion() async {
//    	final packageInfo = await PackageInfo.fromPlatform();
//    	return packageInfo.version;
//  }

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final loggedIn = ref.watch(authProvider);
    final user = ref.watch(authStateChangesProvider).asData?.value;
    String? pass = dotenv.env['TWITTER_PASSWORD'];
    return neu.Neumorphic(
      child: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  return SettingsList(
                    sections: [
                      SettingsSection(
                        title: 'アカウント管理',
                        tiles: [
                          SettingsTile(
                              title: 'SNSログイン',
                              subtitle: '押',
                              // leading: neu.NeumorphicIcon(Icons.account_circle_outlined),
                              onPressed: (context) async {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignInPage()));
                              }),
                          SettingsTile(
                              title: 'アカウント',
                              onPressed: (context) => Clipboard.setData(
                                    ClipboardData(
                                      text: user != null
                                          ? user.uid.toString()
                                          : pass,
                                    ),
                                  ),
                              subtitle:
                                  user != null ? user.uid.toString() : '未登録'),
                          // TODO: サインアウトの挙動の実装が微妙なので本チャンで実装するか迷う
                          SettingsTile(
                              title: 'サインアウト',
                              onPressed: (context) async => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title:
                                          const Text('自動的にアプリが終了します (iOSを除く)'),
                                      content: const Text('サインアウトしますか？'),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () async {
                                              // await FirebaseAuth.instance.signOut();
                                              (!Platform.isIOS)
                                                  ? await FirebaseAuth.instance
                                                      .signOut()
                                                      .then((_) => exit(0))
                                                  : FirebaseAuth.instance
                                                      .signOut()
                                                      .then((_) =>
                                                          SystemNavigator
                                                              .pop());
                                            },
                                            child: const Text('OK')),
                                      ],
                                    );
                                  })),
                          SettingsTile(
                              title: '退会',
                              onPressed: (context) async => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('危険です！'),
                                      content: const Text('本当にアカウントを削除しますか？'),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () async {
                                              await currentUser!.delete();
                                              await SystemNavigator.pop();
                                            },
                                            child: const Text('OK')),
                                      ],
                                    );
                                  })),
                          //         SettingsTile(
                          //           title: '権限許可',
                          //   onPressed: (context) async {
                          //     var status = await Permission.location.request();
                          //     if (status != PermissionStatus.granted) {
                          //       // 一度もリクエストしてないので権限のリクエスト.
                          //       status = await Permission.location.request();
                          //     }
                          //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('権限が許可されました')));
                          //   },
                          // ),
                        ],
                      ),
                      SettingsSection(
                        title: '開発者を応援する＾q＾',
                        tiles: [
                          SettingsTile(
                              title: 'フィードバック送信',
                              subtitle: '押',
                              // leading: neu.NeumorphicIcon(Icons.bug_report),
                              onPressed: (context) async {
                                Wiredash.of(context)!.show();
                              }),
                          // snapshot.hasData
                          //     ? SettingsTile(
                          //         title: '広告解除済み',
                          //         subtitle: '',
                          //         leading: neu.NeumorphicIcon(Icons.attach_money_rounded),
                          //         onPressed: (_) async {
                          //           // // Navigator.pushNamed(_, '/buy');
                          //           // fetchOffers2(context);
                          //         })
                          // :
                          SettingsTile(
                              title: '有料機能',
                              subtitle: '押',
                              onPressed: (context) async {
                                // user == null
                                //     ?
                                //     showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return CustomDialogBox(
                                //         title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                                //         descriptions: 'この機能を使うにはログインが必要です♡',
                                //         text: 'りょ',
                                //         key: UniqueKey(),
                                //       );
                                //     })
                                // :
                                    showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return CustomDialogBox(
                                        title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                                        descriptions: 'この機能はベータ版のため使用できません♡',
                                        text: 'りょ',
                                        key: UniqueKey(),
                                      );
                                    });
                                // Navigator.pushNamed(context, '/sub');
                                // Navigator.pushNamed(context, '/test');
                              }),
                        ],
                      ),
                      SettingsSection(
                        titlePadding: const EdgeInsets.fromLTRB(150, 300, 0, 0),
                        title: '',
                        tiles: const [
                          // SettingsTile(
                          //     title: 'フィードバック送信',
                          //     trailing: null,
                          //     // subtitle: '押',
                          //     onPressed: (context) async {
                          //       Wiredash.of(context)!.show();
                          //     }),
                        ],
                      ),
                      SettingsSection(
                        //TODO: #129 端末のサイズに合わせてバージョンの表示する位置を固定する処理を書く
                        titlePadding: const EdgeInsets.fromLTRB(168, 0, 0, 0),
                        title: 'v ' + (snapshot.data?.version ?? '0.0.0'),
                        tiles: const [
                          // SettingsTile(
                          //     title: 'フィードバック送信',
                          //     trailing: null,
                          //     // subtitle: '押',
                          //     onPressed: (context) async {
                          //       Wiredash.of(context)!.show();
                          //     }),
                        ],
                      ),
                    ],
                  );
                }),
          ),
          // Center(child: Text('＾q＾')),
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
