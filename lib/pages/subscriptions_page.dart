import 'package:flutter/material.dart';
import 'package:kiatsu/Provider/revenuecat.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/pages/consumables_page.dart';
import 'package:kiatsu/utils/utils.dart';
import 'package:kiatsu/widget/paywall_widget.dart';
import 'package:provider/provider.dart';

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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    child: Text(
                      'See Plans',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: isLoading ? null : fetchOffers,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    child: Text(
                      'Upgrade',
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () => {
                      Navigator.of(context).pushNamed('/con'),
                    },
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildEntitlement(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.pro:
        return buildEntitlementIcon(
          text: 'You are on Paid plan',
          icon: Icons.paid,
        );
      default:
        return buildEntitlementIcon(
          text: 'You are on Free plan',
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

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers(all: false);
    print(offerings);
    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('No Plans Found'),
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
          title: '⭐  Upgrade Your Plan',
          description: 'Upgrade to a new plan to enjoy more benefits',
          onClickedPackage: (package) async {
            await PurchaseApi.purchasePackage(package);

            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
