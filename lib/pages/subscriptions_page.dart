import 'package:flutter/material.dart';
import 'package:kiatsu/Provider/revenuecat.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/pages/consumables_page.dart';
import 'package:kiatsu/utils/navigation_service.dart';
import 'package:kiatsu/utils/utils.dart';
import 'package:kiatsu/widget/paywall_widget.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/package_wrapper.dart';
import 'package:purchases_flutter/purchaser_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionsPage extends StatefulWidget {
  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  bool isLoading = false;
  
  Widget build(BuildContext context) {
    final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;

    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildEntitlement(entitlement),
            SizedBox(height: 32),
            buildEntitlementText(entitlement),
          ],
        ),
      ),
    );
  }

  Widget buildEntitlementText(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.pro:

        return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              child: Text(
                '詳しく見る',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: isLoading ? null : fetchOffers,
            );
      case Entitlement.free:

        return ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              child: Text(
                'プランを見る',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: isLoading ? null : fetchOffers,
            );
    }
  }

  Widget buildEntitlement(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.pro:
        return buildEntitlementIcon(
          text: '有料プラン利用中',
          icon: Icons.paid,
        );
      case Entitlement.free:
      default:
        return buildEntitlementIcon(
          text: '無料プラン利用中',
          icon: Icons.lock,
        );
    }
  }

  Widget buildEntitlementIcon({
    required String text,
    required IconData icon,
  }) =>
      Column(
        children: [
          Icon(icon, size: 100),
          SizedBox(height: 8),
          Text(text, style: TextStyle(fontSize: 24)),
        ],
      );

  Future moveToConsumablesPage() async {
    NavigationService().navigateTo(
                MaterialPageRoute(builder:(context) => ConsumablesPage()));
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers(all: false);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('該当するプランが見つかりませんでした'),
      ));
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      Utils.showSheet(
        context,
        (context) => PaywallWidget(
          packages: packages,
          title: 'プランをアップグレードする＾q＾',
          description: 'プランをアップグレードして特典を得る',
          onClickedPackage: (package) async {
            await PurchaseApi.purchasePackage(package);

            Navigator.pop(context);
          },
        ),
      );
    }
  }
}