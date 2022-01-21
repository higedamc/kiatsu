// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kiatsu/api/purchase_api.dart';
// import 'package:kiatsu/model/entitlement.dart';
// import 'package:kiatsu/providers/providers.dart';
// import 'package:kiatsu/utils/utils.dart';
// import 'package:kiatsu/widget/paywall_widget.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// //TODO: https://gpalma.pt/blog/riverpod-feature-switcher/

// class FeatureSwitcher extends ConsumerWidget {
//   final Entitlement? entitlement;
//   final Widget child;

//   const FeatureSwitcher({
//     required this.entitlement,
//     required this.child,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final result = PurchaseApi.getCurrentPurchaser();
//     // if (result == null) {
//     //   PurchaseApi.init();
//     // }
//     // final features = ref.watch<List<Entitlement>>(entitlementProvider);
//     final entitlements = ref.watch(revenueCatProvider).entitlement;
//     if (entitlements != null && entitlement != null) {
//       return child;
//     }
//     return const SizedBox(height: 32);
//   }
// }

// class FeatureBuilder extends ConsumerWidget {
//   final Widget Function(BuildContext, Entitlement) builder;

//   const FeatureBuilder({required this.builder, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final features = ref.watch<List<Entitlement>>(entitlementProvider);
//     // final entitlement = ref.watch(revenueCatProvider).entitlement;
//     return builder.call(context, entitlement);
//   }
// }

// class PurchasePage extends ConsumerWidget {
//   final bool isLoading = false;
//   const PurchasePage({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     Entitlement? entitlement = ref.watch(revenueCatProvider).entitlement;
//     // final isPurhcased = entitlement != null;
//     // final rev = ref.watch(revenueCatProvider);
//     Future fetchOffers() async {
//       final offerings = await PurchaseApi.fetchOffers(all: true);

//       if (offerings.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text('該当するプランが見つかりませんでした'),
//         ));
//       } else {
//         final packages = offerings
//             .map((offer) => offer.availablePackages)
//             .expand((pair) => pair)
//             .toList();

//         Utils.showSheet(
//           context,
//           (context) => PaywallWidget(
//             packages: packages,
//             title: 'プランをアップグレードする＾q＾',
//             description: 'プランをアップグレードして特典を得る',
//             onClickedPackage: (package) async {
//               await PurchaseApi.purchasePackage(package);

//               Navigator.pop(context);
//             },
//           ),
//         );
//       }
//     }

//     return Scaffold(
//       body: Container(
//         alignment: Alignment.center,
//         padding: const EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             FeatureSwitcher(
//               entitlement: entitlement == Entitlement.free
//                   ? Entitlement.free
//                   : Entitlement.pro,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: const Size.fromHeight(50),
//                 ),
//                 onPressed: entitlement == Entitlement.pro
//                     ? null
//                     : isLoading
//                         ? null
//                         : fetchOffers,
//                 child: entitlement == Entitlement.free
//                     ? const Text(
//                         'プランを見る',
//                         style: TextStyle(fontSize: 20),
//                       )
//                     : const Text(
//                         '広告削除済みです',
//                         style: TextStyle(fontSize: 20),
//                       ),
//               ),
//             ),
//             FeatureSwitcher(
//               entitlement: entitlement == Entitlement.free
//                   ? Entitlement.free
//                   : Entitlement.pro,
//               child: entitlement == Entitlement.pro ? Container() : ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size.fromHeight(50),
//                   ),
//                   child: const Text(
//                     '購入を復元',
//                     style: TextStyle(fontSize: 20),
//                     //The receipt is missing
//                   ),
//                   onPressed: () async {
//                     final PurchaserInfo restoredInfo =
//                         await Purchases.restoreTransactions();
//                     print(restoredInfo);
//                     if (restoredInfo.entitlements.all['pro'] != null &&
//                         restoredInfo.entitlements.all['pro']!.isActive) {
//                       // 復元完了のポップアップ
//                       final result = await showDialog<int>(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text('確認'),
//                             content: const Text('復元が完了しました。'),
//                             actions: <Widget>[
//                               ElevatedButton(
//                                   child: const Text('OK'),
//                                   onPressed: () async {
//                                     Navigator.of(context).pop(1);
//                                   }),
//                             ],
//                           );
//                         },
//                       );
//                       print(result);
//                     } else {
//                       // 購入情報が見つからない場合
//                       final result = await showDialog<int>(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return AlertDialog(
//                             title: const Text('確認'),
//                             content:
//                                 const Text('過去の購入情報が見つかりませんでした。アカウント情報をご確認ください。'),
//                             actions: <Widget>[
//                               ElevatedButton(
//                                 child: const Text('OK'),
//                                 onPressed: () => Navigator.of(context).pop(1),
//                               ),
//                             ],
//                           );
//                         },
//                       );
//                       print(result);
//                     }
//                   }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
