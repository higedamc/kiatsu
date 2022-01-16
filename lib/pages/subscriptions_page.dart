import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_flutter/models/adapty_paywall.dart';
import 'package:adapty_flutter/models/adapty_product.dart';
import 'package:adapty_flutter/results/get_paywalls_result.dart';
import 'package:adapty_flutter/results/make_purchase_result.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:kiatsu/providers/revenuecat.dart';
import 'package:kiatsu/utils/navigation_service.dart';
import 'package:kiatsu/utils/utils.dart';
import 'package:kiatsu/widget/paywall_widget.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

//TODO: #117 iOS版のサブスク機能が動くようにする
//TODO: #116 課金後課金情報が消えてしまうので課金情報を更新する

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

// class SubscriptionsPage extends StatefulWidget {
//   const SubscriptionsPage({Key? key}) : super(key: key);

//   @override
//   _SubscriptionsPageState createState() => _SubscriptionsPageState();
// }

class SubscriptionsPage extends ConsumerWidget {
  final bool isLoading = false;

  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final entitlement = Provider.of<RevenueCat>(context).entitlement;

    // RevenueCat().updatePurchaseStatus();
    // final current = PurchaseApi.getCurrentPurchaser();

    // print(current.toString());
    final entitlement = ref.watch(revenueCatProvider).entitlement;
    Future<void> waiter () async {
    return Future.delayed(Duration.zero, () async {
      // PurchaseApi.init();
      await Purchases.setup(Coins._apiKey, appUserId: currentUser?.uid.toString());

    });
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers(all: true);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('該当するプランが見つかりませんでした'),
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
          title: 'プランをアップグレードする＾q＾',
          description: 'プランをアップグレードして特典を得る',
          onClickedPackage: (package) async {
            await PurchaseApi.purchasePackage(package);

            Navigator.pop(context);
          },
        ),
      );
    }
  }


  Widget buildEntitlementText(Entitlement entitlement) {
    // waiter();
    switch (entitlement) {
      case Entitlement.pro:
        return 
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text(
            '広告削除済みです',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: null,
        );
      case Entitlement.free:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text(
            'プランを見る',
            style: TextStyle(fontSize: 20),
          ),
          onPressed: isLoading ? null : fetchOffers,
        );
    }
  }

  Widget buildRestoreButton(Entitlement entitlement) {
    // waiter();
    switch (entitlement) {
      case Entitlement.pro:
        return const Center();
      case Entitlement.free:
        return ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text(
              '購入を復元',
              style: TextStyle(fontSize: 20),
              //The receipt is missing
            ),
            onPressed: () async {
              final PurchaserInfo restoredInfo =
                  await Purchases.restoreTransactions();
              print(restoredInfo);
              if (restoredInfo.entitlements.all['pro'] != null &&
                  restoredInfo.entitlements.all['pro']!.isActive) {
                // 復元完了のポップアップ
                final result = await showDialog<int>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('確認'),
                      content: Text('復元が完了しました。'),
                      actions: <Widget>[
                        ElevatedButton(
                            child: const Text('OK'),
                            onPressed: () async {
                              Navigator.of(context).pop(1);
                            }),
                      ],
                    );
                  },
                );
              } else {
                // 購入情報が見つからない場合
                final result = await showDialog<int>(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('確認'),
                      content: Text('過去の購入情報が見つかりませんでした。アカウント情報をご確認ください。'),
                      actions: <Widget>[
                        ElevatedButton(
                          child: const Text('OK'),
                          onPressed: () => Navigator.of(context).pop(1),
                        ),
                      ],
                    );
                  },
                );
              }
            });
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

  Widget buildEntitlement(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.pro:
        return buildEntitlementIcon(
          text: '有料プラン利用中',
          icon: Icons.done, // ex. paid
        );
      case Entitlement.free:
      default:
        return buildEntitlementIcon(
          text: '無料プラン利用中',
          icon: Icons.lock,
        );
    }
  }

  

  Future fetchOffers2() async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);
    // final offering = await PurchaseApi.fetchSingleOffer(Coins.removeAdsIOS);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
          title: 'プランの選択',
          description: 'プランをアップグレードして特典を得る',
          onClickedPackage: (package) async {
            await PurchaseApi.purchasePackage(package);
            Navigator.pop(context);
          },
        ),
      );
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => PaywallWidget(
      //       packages: offerings.map((offer) => offer.availablePackages).expand((pair) => pair).toList(),
      //       title: 'プランの選択',
      //       description: 'プランをアップグレードして特典を得る',
      //       onClickedPackage: (package) async {
      //         await PurchaseApi.purchasePackage(package);
      //         Navigator.pop(context);
      //       },
      //     ),
      //   ),
      // );
    }
  }

  

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildEntitlement(entitlement),
            const SizedBox(height: 32),
            buildEntitlementText(entitlement),
            const SizedBox(height: 32),
            buildRestoreButton(entitlement),
            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                '他の機能を見てみる',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: isLoading ? null : fetchOffers2,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text(
                  'Get UserInfo',
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () async {
                  // await RevenueCat().updatePurchaseStatus();
                  // final current = await Purchases.getPurchaserInfo();
                  // print(current.toString());
                  // await waiter();
                }),
          ],
        ),
      ),
    );
  }

  
}
