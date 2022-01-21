// import 'package:flutter/cupertino.dart';
// import 'package:kiatsu/model/entitlement.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// class RevenueCat extends ChangeNotifier {
//   RevenueCat() {
//     init();
//   }

//   Entitlement _entitlement = Entitlement.free;
//   Entitlement get entitlement => _entitlement;

//   Future init() async {
//     Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
//       updatePurchaseStatus();
//       notifyListeners();
//     });
//   }

//   Future updatePurchaseStatus() async {
//     final purchaserInfo = await Purchases.getPurchaserInfo();
//     print(purchaserInfo);
//     final entitlements = purchaserInfo.entitlements.active.values.toList();
//     _entitlement =
//         entitlements.isEmpty ? Entitlement.free : Entitlement.pro;

//     // notifyListeners();
//   }
// }