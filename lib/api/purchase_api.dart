import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;



class Coins {
  // Entitlementsの設定
  // static const removeAds = 'kiatsu_120_remove_ads';
  // for iOS
  static const removeAdsIOS = 'kiatsu_250_remove_ads';
  static const tipMe = 'tip_me_490';
  static const subsc = 'kiatsu_pro_1m';
  static final _apiKey = dotenv.dotenv.env['REVENUECAT_SECRET_KEY'].toString();
  // Added some
  static const allIds = [removeAdsIOS, tipMe, subsc];
}

class PurchaseApi {
  
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  static final current = getCurrentUser();

  static Future<void> init() async {

    await Purchases.setDebugLogsEnabled(true);
    await dotenv.dotenv.load(fileName: '.env');
    await Purchases.setup(Coins._apiKey, appUserId: current?.uid.toString());
  }

  static Future<List<Offering>> fetchOffersByIds(List<String> ids) async {
    final offers = await fetchOffers();

    return offers.where((offer) => ids.contains(offer.identifier)).toList();
  }

  static Future fetchSingleOffer(String? id) async {
    final offers = await fetchOffers();
    return offers.where((offer) => offer.identifier == id);
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
      print(e.code);
      print(e.message);
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);

      return true;
    } on PlatformException catch (e) {
      print(e.code);
      print(e.message);
      return false;
    }
  }

  static Future<PurchaserInfo> getCurrentPurchaser() async => await Purchases.getPurchaserInfo();

  // static bool isPurchased => purchasePac
  
}