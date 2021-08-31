import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kiatsu/Provider/revenuecat.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:kiatsu/utils/utils.dart';
import 'package:kiatsu/widget/paywall_widget.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wiredash/wiredash.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final currentUser = firebaseAuth.currentUser;
// test1
final currentPurchaser = PurchaseApi.getCurrentPurchaser();

// class SettingPage extends StatefulWidget {
//   @override
//   _SettingPageState createState() => _SettingPageState();
// }

class SettingPage extends StatelessWidget {
  // bool isSignedInWithApple =

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // 購入済みbool
  Future<bool> isPurchased() async {
    PurchaserInfo purchaseInfo = await Purchases.getPurchaserInfo();
    if(purchaseInfo.entitlements.all["pro"]!.isActive){
      return true;
    } else return false;
  }
  

  Future fetchOffers2(BuildContext context) async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('プランが見つかりませんでした🥺'),
      ));
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      Utils.showSheet(
        context,
        (context) => PaywallWidget(
          packages: packages,
          title: 'プランをアップグレードする',
          description: 'プランをアップグレードして特典を得る＾q＾',
          onClickedPackage: (package) async {
            final isSuccess = await PurchaseApi.purchasePackage(package);

            if (isSuccess) {
              final provider =
                  Provider.of<RevenueCatProvider>(context, listen: false);
              provider.addCoinsPackage(package);
            }

            Navigator.pop(context);
          },
        ),
      );
    }
  }

  // Future<UserCredential> signInAnon() async {
  //   UserCredential user = await firebaseAuth.signInAnonymously();
  //   return user;
  // }

  // Future<UserCredential> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   String generateNonce([int length = 32]) {
  //     final charset =
  //         '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //     final random = Random.secure();
  //     return List.generate(
  //         length, (_) => charset[random.nextInt(charset.length)]).join();
  //   }
  //   /// Returns the sha256 hash of [input] in hex notation.
  //   String sha256ofString(String input) {
  //     final bytes = utf8.encode(input);
  //     final digest = sha256.convert(bytes);
  //     return digest.toString();
  //   }
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider('apple.com').credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await firebaseAuth.signInWithCredential(oauthCredential);
  // }

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: FutureBuilder<bool>(
        future: isPurchased(),
        builder: (context, snapshot) {
          return SettingsList(
            key: _scaffoldKey,
            sections: [
              // SettingsSection(
              //   title: 'デバッグ用',
              //   tiles: [
              //     SettingsTile(
              //       title: '強制クラッシュ',
              //       subtitle: '押',
              //       leading: NeumorphicIcon(Icons.language),
              //       onPressed: (_) {
              //         FirebaseCrashlytics.instance.crash();
              //       },
              //     ),
              //     // SettingsTile.switchTile(
              //     //   title: 'Use fingerprint',
              //     //   leading: Icon(Icons.fingerprint),
              //     //   switchValue: value,
              //     //   onToggle: (bool value) {},
              //     // ),
              //   ],
              // ),
              SettingsSection(
                title: 'アカウント管理',
                tiles: [
                  SettingsTile(
                      title: 'SNSログイン',
                      subtitle: '押',
                      leading: NeumorphicIcon(Icons.account_circle_outlined),
                      onPressed: (context) async {
                        // print(AppleAuthUtil.isSignedIn().toString());
                        // User user2 = AppleAuthUtil.getCurrentUser();
                        // print(user2.toString());
                        // await AppleAuthUtil.signIn(context).then((_) => Navigator.of(context).pop());
                        // await GithubAuthUtil.signIn(context)
                        //     .then((user) => setState(() => user2 = user));
                        await Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignInPage()));
                      }),
                  // SettingsTile(
                  //   title: 'アカウント削除',
                  //   subtitle: '押',
                  //   leading: NeumorphicIcon(Icons.language),
                  //   onPressed: (_) async {
                  //     showDialog(
                  //         context: context,
                  //         builder: (context) {
                  //           return AlertDialog(
                  //             title: Text('危険です！'),
                  //             content: Text('本当にアカウントを削除しますか？'),
                  //             actions: <Widget>[
                  //               TextButton(
                  //                   onPressed: () => Navigator.pop(context),
                  //                   child: Text('Cancel')),
                  //               TextButton(
                  //                   onPressed: () async {
                  //                     await currentUser!.delete();
                  //                     Navigator.of(context).pop();
                  //                   },
                  //                   child: Text('OK')),
                  //             ],
                  //           );
                  //         });
                  //   },
                  // ),
                  SettingsTile(
                      title: 'アカウント名',
                      onPressed: (context) => Clipboard.setData(
                            ClipboardData(
                              text: currentUser!.uid.toString(),
                            ),
                          ).then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  key: _scaffoldKey,
                                  content: const Text('アカウント名がコピーされました！')),
                            );
                          }),
                      subtitle: currentUser!.uid),
                ],
              ),
              SettingsSection(
                title: '開発者を応援する＾q＾',
                tiles: [
                  SettingsTile(
                      title: 'フィードバック送信',
                      subtitle: '押',
                      leading: NeumorphicIcon(Icons.bug_report),
                      onPressed: (context) async {
                        // print(AppleAuthUtil.isSignedIn().toString());
                        // User user2 = AppleAuthUtil.getCurrentUser();
                        // print(user2.toString());
                        // await AppleAuthUtil.signIn(context).then((_) => Navigator.of(context).pop());
                        // await GithubAuthUtil.signIn(context)
                        //     .then((user) => setState(() => user2 = user));
                        Wiredash.of(context)!.show();
                      }),
                  snapshot.hasData ? SettingsTile(
                      title: '広告解除済み',
                      subtitle: '',
                      leading: NeumorphicIcon(Icons.attach_money_rounded),
                      onPressed: (_) async {
                        // // Navigator.pushNamed(_, '/buy');
                        // fetchOffers2(context);
                      }) :
                       SettingsTile(
                      title: '有料機能',
                      subtitle: '押',
                      leading: NeumorphicIcon(Icons.attach_money_rounded),
                      onPressed: (_) async {
                        // Navigator.pushNamed(_, '/buy');
                        //  Navigator.pushNamed(context, '/subsc');
                        fetchOffers2(context);
                        // Navigator.pushNamed(context, '/iap');
                      }),
                ],
              ),
            ],
          );
        }
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
