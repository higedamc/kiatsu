import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:kiatsu/api/purchase_api.dart';

import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:package_info/package_info.dart';
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

// Future<String?> _getAppVersion() async {
//    	final packageInfo = await PackageInfo.fromPlatform();
//    	return packageInfo.version;
  //  }



class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return neu.Neumorphic(
      child: Column(
        children: <Widget> [
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
                              await Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => SignInPage()));
                            }),
                        SettingsTile(
                            title: 'アカウント',
                            onPressed: (context) => Clipboard.setData(
                                  ClipboardData(
                                    text: currentUser?.uid.toString(),
                                  ),
                                ),
                            subtitle: currentUser != null
                                ? currentUser?.uid.toString()
                                : '未登録'),
                                // TODO: サインアウトの挙動の実装が微妙なので本チャンで実装するか迷う
                        SettingsTile(
                            title: 'サインアウト',
                            onPressed: (context) async => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('自動的にアプリが終了します (iOSを除く)'),
                                    content: Text('サインアウトしますか？'),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            await FirebaseAuth.instance.signOut();
                                            (!Platform.isIOS)
                                                ? await SystemNavigator.pop()
                                                : AlertDialog(
                                                    title: Text('iPhoneユーザーの方へ'),
                                                    content: Text('上にスワイプして手動でアプリを終了させてください'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                          onPressed: () =>
                                                              Navigator.pop(context),
                                                          child: Text('OK'))
                                                    ],
                                                  );
                                          },
                                          child: Text('OK')),
                                    ],
                                  );
                                })),
                        SettingsTile(
                            title: '退会',
                            onPressed: (context) async => showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('危険です！'),
                                    content: Text('本当にアカウントを削除しますか？'),
                                    actions: <Widget>[
                                      TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('Cancel')),
                                      TextButton(
                                          onPressed: () async {
                                            await currentUser!.delete();
                                            await SystemNavigator.pop();
                                          },
                                          child: Text('OK')),
                                    ],
                                  );
                                })),
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
                              // Navigator.pushNamed(context, '/con');
                              Navigator.pushNamed(context, '/sub');
                              //  Navigator.pushNamed(context, '/dev');
                              // Navigator.pop(context);
                              // showDialog(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return CustomDialogBox(
                              //         title: "てへぺろ☆(ゝω･)vｷｬﾋﾟ",
                              //         descriptions: "この機能はまだ未実装です♡",
                              //         text: "おけまる",
                              //         key: UniqueKey(),
                              //       );
                              //     });
                            }),
                      ],
                    ),
                    SettingsSection(
                      titlePadding: EdgeInsets.fromLTRB(150, 300, 0, 0),
                      title: '',
                      tiles: [
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
                      
                      
                      titlePadding: EdgeInsets.fromLTRB(168, 0, 0, 0),
                      title: 'v ' + (snapshot.data?.version ?? '0.0.0'),
                      tiles: [
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
              }
            ),
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
