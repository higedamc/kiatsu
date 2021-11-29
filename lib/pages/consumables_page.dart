import 'package:flutter/material.dart';
import 'package:kiatsu/api/purchase_api.dart';
import 'package:kiatsu/providers/revenuecat.dart';
import 'package:kiatsu/utils/utils.dart';
import 'package:kiatsu/widget/paywall_widget.dart';
import 'package:provider/provider.dart';



class ConsumablesPage extends StatefulWidget {
  const ConsumablesPage({Key? key}) : super(key: key);

  @override
  _ConsumablesPageState createState() => _ConsumablesPageState();
}

class _ConsumablesPageState extends State<ConsumablesPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final coins = Provider.of<RevenueCat>(context).coins;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildCoins(coins),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                'コインをもっとゲットする',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: isLoading ? null : fetchOffers,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text(
                '10 コイン使う',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: isLoading ? null : spendCoins,
            ),
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
          const SizedBox(height: 8),
          Text(
            '所有コイン: $coins 枚',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      );

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('プランが見つかりませんでした🥺'),
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
          description: 'プランをアップグレードして特典を得る＾q＾',
          onClickedPackage: (package) async {
            final isSuccess = await PurchaseApi.purchasePackage(package);

            if (isSuccess) {
              final provider =
                  Provider.of<RevenueCat>(context, listen: false);
              provider.addCoinsPackage(package);
            }

            Navigator.pop(context);
          },
        ),
      );
    }
  }

  void spendCoins() {
    final provider = Provider.of<RevenueCat>(context, listen: false);

    provider.spend10Coins();
  }
}