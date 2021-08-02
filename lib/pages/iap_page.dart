import 'package:flutter/material.dart';
import 'package:kiatsu/pages/upsell_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class IAPPage extends StatefulWidget {
  const IAPPage({required Key key}) : super(key: key);

  @override
  _IAPScreenState createState() => _IAPScreenState();
}

class _IAPScreenState extends State<IAPPage> {
  late PurchaserInfo _purchaserInfo;
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
    await Purchases.setup('hEGjqaMrDIyByWbYGXSlPRcswbreVkgj'); 

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
    // ignore: unnecessary_null_comparison
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