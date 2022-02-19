import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
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

Future<bool> checkFirstRun() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool _firstRun = prefs.getBool('firstRun') ?? true;
  if (_firstRun) {
    prefs.setBool('firstRun', false);
    return true;
  } else {
    return false;
  }
}

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

    Size size = MediaQuery.of(context).size;
    print(size);
    var devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    final width = size.width;
    final height = size.height;
    final currentWidth = width / 100;
    final currentHeight = height / 100;
    final user = ref.watch(authStateChangesProvider).asData?.value;
    String? pass = dotenv.env['TWITTER_PASSWORD'];
    return Scaffold(
      // key: scaffoldMessengerKey,
      appBar: NeumorphicAppBar(
        title: const Text('設定'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            //TODO: Riverpod化する
            child: FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  return Stack(
                    children: [
                      SettingsList(
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
                                  title: 'アカウント',
                                  subtitle: (user != null ? user.uid.toString() : '未登録'),
                                  leading: const Icon(CupertinoIcons.person_solid),
                                  onPressed: (context) async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignInPage()));
                                  }),
                              // SettingsTile(
                              //     title: 'アカウント',
                              //     // leading: const Icon(Icons.account_circle_outlined),
                              //     onPressed: (_) async {
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //           const SnackBar(
                              //               // key: scaffoldMessengerKey,
                              //               // key: UniqueKey(),
                              //               content:
                              //                   Text('クリップボードにアカウント名がコピーされました')));
                              //       await Clipboard.setData(
                              //         ClipboardData(
                              //           text: user != null
                              //               ? user.uid.toString()
                              //               : pass,
                              //         ),
                              //       );
                              //     },
                              //     subtitle:
                              //         user != null ? user.uid.toString() : '未登録'),
                              // TODO: サインアウトの挙動の実装が微妙なので本チャンで実装するか迷う
                              user != null ? 
                              SettingsTile(
                                  title: 'サインアウト',
                                  leading: const Icon(CupertinoIcons.eject),
                                  onPressed: (context) async => showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text('サインアウトすると特定の機能にアクセスできなくなります'),
                                          content: const Text('本当にサインアウトしますか？'),
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
                                      })) : const SettingsTile(
                                        enabled: false,
                                  // title: '',
                                  // leading: null,
                                  // trailing: null,
                                  // onPressed: (_) async {

                                  // }
                                      ),
                              
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
                                  leading: Icon(CupertinoIcons.smiley),
                                  subtitle: '',
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
                              SettingsTile(
                                  title: '有料機能',
                                  leading: Icon(CupertinoIcons.money_yen),
                                  subtitle: '',
                                  onPressed: (context) async {
                                    if (user == null) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return CustomDialogBox(
                                              title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                                              descriptions: 'この機能を使うにはログインが必要です♡',
                                              text: 'りょ',
                                              key: UniqueKey(),
                                            );
                                          });
                                    } else if (user != null) {
                                      // await waiter(ref);
                                      Navigator.pushNamed(context, '/sub');
                                    }
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
                                  }),
                            ],
                          ),
                          SettingsSection(
                            // titlePadding: EdgeInsets.fromLTRB(0, 0, 0, currentWidth),
                            title: '',
                            tiles: [
                              // SettingsTile(
                              //     title: '初回起動確認',
                              //     trailing: null,
                              //     // subtitle: '押',
                              //     onPressed: (context) async {
                              //       final checkResult = await checkFirstRun();
                              //       ScaffoldMessenger.of(context).showSnackBar(
                              //           SnackBar(
                              //               content: Text(checkResult.toString())));
                              //     }),
                              SettingsTile(
                                  title: 'プライバシーポリシー',
                                  trailing: null,
                                  // subtitle: '押',
                                  onPressed: (context) async {
                                    final checkResult = await checkFirstRun();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(checkResult.toString())));
                                  }),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Positioned(
                          // top: currentHeight * 80,
                          // left: currentWidth * 48,
                          child: Text('v' + (snapshot.data?.version ?? '0.0.0'),),
                        ),
                      )],
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
