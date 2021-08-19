import 'package:flutter/cupertino.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  int coins = 0;

  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;

  Future init() async {
    Purchases.addPurchaserInfoUpdateListener((purchaserInfo) async {
      updatePurchaseStatus();
    });
  }

  Future updatePurchaseStatus() async {
    final purchaserInfo = await Purchases.getPurchaserInfo();

    final entitlements = purchaserInfo.entitlements.active.values.toList();
    _entitlement =
        (entitlements.isEmpty ? Entitlement.free : Entitlement.pro);

    notifyListeners();
  }

  void addCoinsPackage(Package package) {
    switch (package.offeringIdentifier) {
      case Coins.idCoins10:
        coins += 10;
        break;
      default:
        break;
    }

    notifyListeners();
  }

  void spend10Coins() {
    coins -= 10;

    notifyListeners();
  }
}
