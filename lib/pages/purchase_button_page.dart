import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseButton extends StatelessWidget {
  const PurchaseButton({required Key key, required this.package, required this.label})
      : super(key: key);

  final Package package;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.all(10),
      color: Colors.grey,
      onPressed: () async {
        try {
          // 購入処理
          final purchaserInfo = await Purchases.purchasePackage(package);
          final isNoAds = purchaserInfo.entitlements.all['pro']!.isActive;
          if (isNoAds) {
            // 購入完了時の処理

          }
        } on PlatformException catch (e) {
          final errorCode = PurchasesErrorHelper.getErrorCode(e);
          if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
            print('User cancelled');
          } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
            print('User not allowed to purchase');
          }
        }
      },
      child: Container(
          width: 200,
          child:
              Center(child: Text('$label   (${package.product.priceString})'))),
    );
  }
}