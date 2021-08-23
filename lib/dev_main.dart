import 'package:flutter/material.dart';
import 'package:kiatsu/pages/consumables_page.dart';
import 'package:kiatsu/pages/subscriptions_page.dart';
import 'package:provider/provider.dart';

import 'Provider/revenuecat.dart';
import 'api/purchase_api.dart';

Future <void> devStartApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PurchaseApi.init();

  runApp(DevMyApp());
}

class DevMyApp extends StatelessWidget {
  static final String title = 'Purchases';

  @override
  Widget build(BuildContext context) {
    const denimBlue = Color.fromRGBO(21, 30, 61, 1);
    const accentColor = Colors.amber;

    return ChangeNotifierProvider(
      create: (context) => RevenueCatProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData.dark().copyWith(
          primaryColor: denimBlue,
          scaffoldBackgroundColor: denimBlue,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: denimBlue,
            selectedItemColor: accentColor,
          ),
          accentColor: accentColor,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: accentColor,
              onPrimary: Colors.black,
            ),
          ),
          accentIconTheme: IconThemeData(color: accentColor),
        ),
        home: DevMainPage(),
      ),
    );
  }
}

class DevMainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<DevMainPage> {
  int selectedIndex = 0;
  final children = [SubscriptionsPage(), ConsumablesPage()];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(DevMyApp.title),
          centerTitle: true,
        ),
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