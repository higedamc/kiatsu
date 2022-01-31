import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/auth/auth_manager.dart';
import 'package:kiatsu/pages/custom_dialog_box.dart';

import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:kiatsu/providers/revenuecat.dart';
import 'package:package_info/package_info.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wiredash/wiredash.dart';

//TODO: #115 サインアップ時に設定ページの表示が更新されるようにする
//TODO: Android版の文字の色を変える
//TODO: #127 #126 アプリバージョン取得方法をFutureBuilder使わずにやる

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final currentUser = firebaseAuth.currentUser;
// test1
// final currentPurchaser = PurchaseApi.getCurrentPurchaser();

final userProvider = StateProvider((ref) {
  return FirebaseAuth.instance.currentUser;
});

// Future<String?> _getAppVersion() async {
//    	final packageInfo = await PackageInfo.fromPlatform();
//    	return packageInfo.version;
//  }

class Coins {
  // Entitlementsの設定
  // static const removeAds = 'kiatsu_120_remove_ads';
  // for iOS
  static const removeAdsIOS = 'kiatsu_250_remove_ads';
  static const tipMe = 'tip_me_490';
  static final _apiKey = dotenv.env['REVENUECAT_SECRET_KEY'].toString();
  // Added some
  static const allIds = [removeAdsIOS, tipMe];
}

// Future<void> waiter(WidgetRef ref) async {
//   // return Future.delayed(Duration.zero, () async {
//   //   // PurchaseApi.init();
//   //   await Purchases.setup(Coins._apiKey,
//   //       appUserId: currentUser?.uid.toString());
//   // });
//   final testt = ref.watch(authManagerProvider);
//   if (testt.isLoggedIn) {
//     await Purchases.setup(Coins._apiKey,
//         appUserId: currentUser?.uid.toString());
//   }
//   // await Purchases.setup(
//   //   Coins._apiKey,
//   //   appUserId: currentUser?.uid.toString(),
//   // );
// }

class SettingPage extends ConsumerWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
    // final loggedIn = ref.watch(authProvider);
    final user = ref.watch(authStateChangesProvider).asData?.value;
    String? pass = dotenv.env['TWITTER_PASSWORD'];
    return Scaffold(
      // key: scaffoldMessengerKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  return SettingsList(
                    backgroundColor: Colors.white,
                    sections: [
                      SettingsSection(
                        titleTextStyle: const TextStyle(
                            // fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
                              onPressed: (_) async {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        // key: scaffoldMessengerKey,
                                        // key: UniqueKey(),
                                        content:
                                            Text('クリップボードにアカウント名がコピーされました')));
                                await Clipboard.setData(
                                  ClipboardData(
                                    text: user != null
                                        ? user.uid.toString()
                                        : pass,
                                  ),
                                );
                              },
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
                                            onPressed: () async {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel')),
                                        TextButton(
                                            onPressed: () async {
                                              // await FirebaseAuth.instance.signOut();
                                              (!Platform.isIOS)
                                                  ? await FirebaseAuth.instance
                                                      .signOut()
                                                  // .then((_)
                                                  //  => exit(0))
                                                  : FirebaseAuth.instance
                                                      .signOut()
                                                      .then((_) async {
                                                      try {
                                                        await Purchases
                                                            .logOut();
                                                      } catch (e) {
                                                        if (e == 22) {
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      }
                                                      // final purchaserInfo = await Purchases.getPurchaserInfo();
                                                      // print(purchaserInfo);
                                                      // (purchaserInfo.entitlements.active.containsKey(Coins.removeAdsIOS)) ?

                                                      // // if (purchaserInfo != null) {
                                                      //    null : await Purchases.logOut();
                                                      // // }

                                                      Navigator.pop(context);
                                                    });
                                            },
                                            child: const Text('OK')),
                                      ],
                                    );
                                  })),
                          SettingsTile(
                              title: 'パーミッション取得',
                              onPressed: (context) async {
                                // await showDialog(
                                //     context: context,
                                //     builder: (context) {
                                //       return AlertDialog(
                                //         title: const Text('Oops!！'),
                                //         content:
                                //             const Text('このアプリには位置情報の取得が必要です'),
                                //         actions: <Widget>[
                                //           TextButton(
                                //               onPressed: () =>
                                //                   Navigator.pop(context),
                                //               child: const Text('Cancel')),
                                //           TextButton(
                                //               onPressed: () async {
                                //                 await Geolocator
                                //                     .openAppSettings();
                                //               },
                                //               child: const Text('OK')),
                                //         ],
                                //       );
                                //     });
                                Map<Permission, PermissionStatus> statuses =
                                    await [
                                  Permission.location,
                                  Permission.locationAlways,
                                  Permission.locationWhenInUse,
                                ].request();
                                print(statuses);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(statuses.toString())));
                                        //TODO: この辺汚すぎるので後でどうにかする
                                // final result1 =
                                //     await Permission.location.isDenied;
                                // final result2 =
                                //     await Permission.locationAlways.isDenied;
                                // final result3 = await Permission
                                //     .locationWhenInUse.isDenied;
                                // final result4 =
                                //     await Permission.location.isLimited;
                                // final result5 =
                                //     await Permission.location.isRestricted;
                                // final result6 = await Permission
                                //     .location.isPermanentlyDenied;
                                // final result7 =
                                //     await Permission.locationAlways.isLimited;
                                // final result8 = await Permission
                                //     .locationAlways.isRestricted;
                                // final result9 = await Permission
                                //     .locationAlways.isPermanentlyDenied;
                                // final result10 = await Permission
                                //     .locationWhenInUse.isLimited;
                                // final result11 = await Permission
                                //     .locationWhenInUse.isRestricted;
                                // final result12 = await Permission
                                //     .locationWhenInUse.isPermanentlyDenied;

                                // (result1 == true ||
                                //         result4 == true ||
                                //         result5 == true ||
                                //         result6 == true)
                                //     ? await Permission.location.request()
                                //     : await Permission.location.isGranted;
                                // (result2 == true ||
                                //         result7 == true ||
                                //         result8 == true ||
                                //         result9 == true)
                                //     ? await Permission.locationAlways
                                //         .request()
                                //     : await Permission
                                //         .locationAlways.isGranted;
                                // (result3 == true ||
                                //         result10 == true ||
                                //         result11 == true ||
                                //         result12 == true)
                                //     ? await Permission.locationWhenInUse
                                //         .request()
                                //     : await Permission
                                //         .locationWhenInUse.isGranted;
                              }),
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
                        titleTextStyle: const TextStyle(
                            // fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        title: '開発者を応援する🥺',
                        tiles: [
                          SettingsTile(
                              title: 'フィードバック送信',
                              subtitle: '押',
                              // leading: neu.NeumorphicIcon(Icons.bug_report),
                              onPressed: (context) async {
                                Wiredash.of(context)?.show();
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
                          //TODO: stagingと本番環境で課金機能の表示を分ける
                          // SettingsTile(
                          //     title: '有料機能',
                          //     subtitle: '押',
                          //     onPressed: (context) async {
                          //       if (user == null) {
                          //         showDialog(
                          //             context: context,
                          //             builder: (BuildContext context) {
                          //               return CustomDialogBox(
                          //                 title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                          //                 descriptions: 'この機能を使うにはログインが必要です♡',
                          //                 text: 'りょ',
                          //                 key: UniqueKey(),
                          //               );
                          //             });
                          //       } else if (user != null) {
                          //         // await waiter(ref);
                          //         Navigator.pushNamed(context, '/sub');
                          //       }
                          //       // ?

                          //       // :
                          //       // showDialog(
                          //       // context: context,
                          //       // builder: (BuildContext context) {
                          //       //   return CustomDialogBox(
                          //       //     title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                          //       //     descriptions: 'この機能はベータ版のため使用できません♡',
                          //       //     text: 'りょ',
                          //       //     key: UniqueKey(),
                          //       //   );
                          //       //     // });
                          //     }),
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
                        titleTextStyle: const TextStyle(
                            // fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        //TODO: #129 端末のサイズに合わせてバージョンの表示する位置を固定する処理を書く
                        titlePadding: const EdgeInsets.fromLTRB(175, 0, 0, 0),
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
