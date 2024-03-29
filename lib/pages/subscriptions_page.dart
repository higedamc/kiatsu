import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/controller/purchase_controller.dart';
import 'package:kiatsu/controller/user_controller.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:kiatsu/providers/scaffold_messanger_provider.dart';
import 'package:kiatsu/utils/utils.dart';
import 'package:kiatsu/widget/paywall_widget.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final currentUser = firebaseAuth.currentUser;
final CollectionReference users = firebaseStore.collection('users');

class SubscriptionsPage extends ConsumerWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);
  static const flavor = String.fromEnvironment('flavor');
  bool get isLoading => false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateChangesProvider).asData?.value;
    final isNoAds = ref.watch(userProvider.select((s) => s.isNoAdsUser));
    final products = ref.watch(purchaseProvider.select((s) => s.products));
    Future<void> fetchOffers() async {
      final offerings = await PurchaseApi.fetchOffers(all: true);

      if (offerings.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('該当するプランが見つかりませんでした'),
          ),
        );
      } else {
        //TODO: 従来のRevenueCat
        final packages = offerings
            .map((offer) => offer.availablePackages)
            .expand((pair) => pair)
            .toList();

        await Utils().showSheet(
          context,
          (context) => PaywallWidget(
            packages: packages,
            termsOfUse: '利用規約',
            privacyPolicy: 'プライバシーポリシー',
            description: '広告削除及びお気持ち投稿の場での追加機能（未リリース、ベータ版を含む）がアンロックできるようになります。',
            onClickedPackage: (package) async {
              final succeeded = await PurchaseApi.purchasePackage(package);
              if (succeeded == true) {
                ref
                    .read(scaffoldMessengerProvider)
                    .currentState
                    ?.showAfterRemoveSnackBar(
                      message: succeeded ? '購入が完了しました。' : '購入に失敗しました。',
                    );
                final setData = <String, dynamic>{
                  'isPaidUser': 'true',
                };
                await users
                    .doc(currentUser?.uid)
                    .set(setData, SetOptions(merge: true));
              }

              Navigator.pop(context);
            },
          ),
        );
      }
    }

    Widget buildEntitlementIcon({
      required String text,
      required IconData icon,
    }) =>
        Column(
          children: [
            Icon(icon, size: 100),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(fontSize: 24)),
          ],
        );
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('サブスクリプション'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // buildEntitlement(_purchaser.entitlement),
            isNoAds
                ? buildEntitlementIcon(text: '有料プラン利用中', icon: Icons.done)
                : buildEntitlementIcon(
                    text: '無料プラン利用中',
                    icon: Icons.lock,
                  ),
            const SizedBox(height: 32),
            isNoAds
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: Colors.black,
                    ),
                    onPressed: null,
                    child: const Text(
                      '広告削除済みです',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: Colors.black,
                    ),
                    child: const Text(
                      'プランを見る',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      await fetchOffers();
                    },
                  ),
            const SizedBox(height: 32),
            isNoAds
                ? ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: Colors.black,
                    ),
                    onPressed: () async =>
                        Navigator.pushNamed(context, '/icon'),
                    child: const Text(
                      '他の機能を見る',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                : const Center(),
            const SizedBox(height: 32),
            isNoAds
                ? const Center()
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      primary: Colors.black,
                    ),
                    child: const Text(
                      '購入を復元',
                      style: TextStyle(fontSize: 20),
                      //The receipt is missing
                    ),
                    onPressed: () async {
                      final purchaser = ref.read(purchaseProvider.notifier);
                      final restoredResult = await purchaser.restore();
                      // final restoredInfo =
                          // await PurchaseApi.getCurrentPurchaser();
                      if (kDebugMode) {
                        print(restoredResult);
                      }
                      if (restoredResult != null) {
                        // 復元完了のポップアップ
                        await showDialog<int>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('確認'),
                              content: const Text('購入情報がありません。'),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop(1);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        // ref
                        //     .read(scaffoldMessengerProvider)
                        //     .currentState
                        //     ?.showAfterRemoveSnackBar(
                        //       message: '過去の購入情報が見つかりませんでした。アカウント情報をご確認ください。',
                        //     );
                      } else {
                        // 購入情報が見つからない場合
                        await showDialog<int>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('確認'),
                              content: const Text(
                                '過去の購入情報の復元が完了しました',
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('OK'),
                                  onPressed: () =>
                                      Navigator.of(context).pop(1),
                                ),
                              ],
                            );
                          },
                        );
                        // ref
                        //     .read(scaffoldMessengerProvider)
                        //     .currentState
                        //     ?.showAfterRemoveSnackBar(
                        //       message: '過去の購入情報の復元が完了しました。',
                        //     );
                      }
                    },
                  ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
