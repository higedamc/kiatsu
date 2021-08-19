import 'package:flutter/material.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/pages/upsell_page.dart';
import 'package:purchases_flutter/purchases_flutter.dart';




class IAPScreen extends StatefulWidget {

  // https://stackoverflow.com/questions/67401385/lateinitializationerror-field-data-has-not-been-initialized-got-error
  @override
  _IAPScreenState createState() => _IAPScreenState();
}

class _IAPScreenState extends State<IAPScreen> {
  PurchaserInfo? _purchaserInfo;
  late Offerings _offerings;

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