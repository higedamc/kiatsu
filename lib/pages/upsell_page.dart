import 'package:flutter/material.dart';
import 'package:kiatsu/pages/purchase_button_page.dart';
import 'package:kiatsu/pages/restore_button_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class UpsellPage extends StatelessWidget {
  const UpsellPage({required Key key, required this.offerings}) : super(key: key);

  final Offerings offerings;

  @override
  Widget build(BuildContext context) {
    final offering = offerings.current;
    if (offering != null) {
      
      // Offeringに紐づいたPackageを取得します。
      // 今回はCustomタイプのPackageを作成したので、Package名を指定しています。
      // Monthlyなど、デフォルトで用意されているPackageを使う場合は
      // offering.monthlyで取得できます。
      final noAdsPackage = offering.getPackage('kiatsu_pro_1m');
      if (noAdsPackage != null) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                
                // 課金アイテムの説明
                Text('アプリ内の広告が非表示になります'),
                const SizedBox(height: 10),
                
                // 購入ボタン
                PurchaseButton(
                  package: noAdsPackage,
                  label: '広告を削除', key: UniqueKey(),
                ),
                const SizedBox(height: 30),

                // 復元ボタンのガイド
                Text('すでにご購入いただいている場合は、下記の復元ボタンをタップしてください'),
                const SizedBox(height: 10),

                // 復元ボタン
                RestoreButton(key: UniqueKey(),),
              ],
            ),
          ),
        );
      }
    }
    return Center(
      child: Text('Loading...'),
    );
  }

  
}