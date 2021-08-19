import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;


class Coins {
  static const idCoins10 = '10_coins';
  static const idCoins100 = '100_coins';
  static final _apiKey = dotenv.dotenv.env['REVENUECAT_SECRET_KEY'].toString();

  static const allIds = [idCoins10, idCoins100];
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
