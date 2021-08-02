import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RestoreButton extends StatefulWidget {
  const RestoreButton({required Key key}) : super(key: key);

  @override
  _RestoreButtonState createState() => _RestoreButtonState();
}

class _RestoreButtonState extends State<RestoreButton> {
  late bool _restoring;

  @override
  void initState() {
    super.initState();
    setState(() {
      _restoring = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.all(10),
      color: Colors.grey,
      onPressed: () async {
        try {
          setState(() {
            _restoring = true;
          });
          
          // 過去の購入情報を取得
          final restoredInfo = await Purchases.restoreTransactions();

          if (restoredInfo.entitlements.all['kiatsu_pro'] != null &&
              restoredInfo.entitlements.all['kiatsu_pro']!.isActive) {
            
            // 復元完了時の処理を記載
            

            // 復元完了のポップアップ
          } else {
            // 購入情報が見つからない場合
            var result = await showDialog<int>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('確認'),
                  content: Text('過去の購入情報が見つかりませんでした。アカウント情報をご確認ください。'),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(context).pop(1),
                    ),
                  ],
                );
              },
            );
          }
          setState(() {
            _restoring = false;
          });
        } on PlatformException catch (e) {
          setState(() {
            _restoring = false;
          });
          final errorCode = PurchasesErrorHelper.getErrorCode(e);
          print('errorCode: $errorCode');
        }
      },
      child: Container(
        width: 200,
        child: Center(
          child: Text(_restoring
              ? '復元中'
              : '復元',
        ),
      ),
    ));
  }
}