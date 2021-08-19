import 'package:flutter/material.dart';
import 'package:kiatsu/Provider/revenuecat.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/utils/utils.dart';
import 'package:kiatsu/widget/paywall_widget.dart';
import 'package:provider/provider.dart';

class ConsumablesPage extends StatefulWidget {
  @override
  _ConsumablesPageState createState() => _ConsumablesPageState();
}

class _ConsumablesPageState extends State<ConsumablesPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final coins = Provider.of<RevenueCatProvider>(context).coins;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCoins(coins),
            SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
              ),
              child: Text(
                'Get More Coins',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: isLoading ? null : fetchOffers,
            ),
            // SizedBox(height: 20),
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //     minimumSize: Size.fromHeight(50),
            //   ),
            //   child: Text(
            //     'Spend 10 Coins',
            //     style: TextStyle(fontSize: 20),
            //   ),
            //   onPressed: isLoading ? null : spendCoins,
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildCoins(int coins) => Column(
        children: [
          Icon(
            Icons.monetization_on,
            color: Colors.yellow.shade800,
            size: 100,
          ),
          SizedBox(height: 8),
          Text(
            'You have $coins Coins',
            style: TextStyle(fontSize: 24),
          ),
        ],
      );

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);

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
            final isSuccess = await PurchaseApi.purchasePackage(package);

            if (isSuccess) {
              final provider =
                  Provider.of<RevenueCatProvider>(context, listen: false);
              // provider.addCoinsPackage(package);
            }

            Navigator.pop(context);
          },
        ),
      );
    }
  }

  void spendCoins() {
    final provider = Provider.of<RevenueCatProvider>(context, listen: false);

    provider.spend10Coins();
  }
}