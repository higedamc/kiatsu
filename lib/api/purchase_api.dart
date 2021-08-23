import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;


class Coins {
  // Entitlementsの設定
  static const removeAds = 'kiatsu_120_remove_ads';
  static const tipMe = 'tip_me';
  static final _apiKey = dotenv.dotenv.env['REVENUECAT_SECRET_KEY'].toString();

  static const allIds = [removeAds, tipMe];
}

class PurchaseApi {
  
  static Future init() async {

    await Purchases.setDebugLogsEnabled(true);
    await dotenv.dotenv.load(fileName: ".env");
    await Purchases.setup(Coins._apiKey, appUserId: 'testUser1');
  }

  static Future<List<Offering>> fetchOffersByIds(List<String> ids) async {
    final offers = await fetchOffers();

    return offers.where((offer) => ids.contains(offer.identifier)).toList();
  }

  static Future<List<Offering>> fetchOffers({bool all = true}) async {
    try {
      final offerings = await Purchases.getOfferings();

      if (!all) {
        final current = offerings.current;

        return current == null ? [] : [current];
      } else {
        return offerings.all.values.toList();
      }
    } on PlatformException catch (e) {
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);

      return true;
    } catch (e) {
      return false;
    }
  }
}
