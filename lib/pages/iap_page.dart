import 'package:flutter/material.dart';
import 'package:kiatsu/pages/upsell_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class Coins {
  // Entitlementsの設定
  static const removeAds = 'kiatsu_120_remove_ads';
  // for iOS
  static const removeAdsIOS = 'kiatsu_250_remove_ads';
  static const tipMe = 'tip_me';
  static final _apiKey = dotenv.dotenv.env['REVENUECAT_SECRET_KEY'].toString();
  // Added some
  static const allIds = [removeAds, tipMe, removeAdsIOS];
}

class IAPScreen extends StatefulWidget {
  const IAPScreen({required Key key}) : super(key: key);

  @override
  _IAPScreenState createState() => _IAPScreenState();
}

class _IAPScreenState extends State<IAPScreen> {
  PurchaserInfo? _purchaserInfo;
  late Offerings _offerings;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // 初期化処理
  // 購入情報・Offeringsの取得を行う
  Future<void> initPlatformState() async {
    await Purchases.setDebugLogsEnabled(true);

    // SDK Keyは RevenueCatの各アプリのAPI Keysから取得できます。
    // アプリで使用しているユーザーIDと紐づける場合は、
    // await Purchases.setup("public_sdk_key", appUserId: "my_app_user_id");
    // await Purchases.setup('public_sdk_key'); 
    await dotenv.dotenv.load(fileName: ".env");
    await Purchases.setup(Coins._apiKey);

    final purchaserInfo = await Purchases.getPurchaserInfo();
    final offerings = await Purchases.getOfferings();

    if (!mounted) return;

    setState(() {
      _purchaserInfo = purchaserInfo;
      _offerings = offerings;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_purchaserInfo == null) {
      return Scaffold(
        appBar: AppBar(title: Text('課金画面')),
        body: const Center(
          child: Text('Loading...'),
        ),
      );
    }

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('課金画面'),
        ),
        body: UpsellPage(
          offerings: _offerings, key: UniqueKey(),
        ),
      ),
    );
  }
}