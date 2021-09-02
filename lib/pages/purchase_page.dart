import 'package:flutter/material.dart';
import 'package:kiatsu/pages/consumables_page.dart';
import 'package:kiatsu/pages/subscriptions_page.dart';

class DevPurchasePage extends StatefulWidget {
  @override
  _DevMainPageState createState() => _DevMainPageState();
}

class _DevMainPageState extends State<DevPurchasePage> {
  int selectedIndex = 0;
  final children = [SubscriptionsPage(), ConsumablesPage()];

  @override
  Widget build(BuildContext context) => Scaffold(
        body: children[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Subscription',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              label: 'Consumable',
            ),
          ],
        ),
      );
}