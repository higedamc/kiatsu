import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocation/geolocation.dart';
import 'package:kiatsu/Provider/revenuecat.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/utils/get_weather.dart';
import 'package:kiatsu/utils/weather_request.dart';
import 'package:kiatsu/wrapper/stateful_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'custom_dialog_box.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final CollectionReference users = firebaseStore.collection('users');
final currentUser = firebaseAuth.currentUser;

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

class HomePage extends ConsumerWidget {
  DateTime updatedAt = DateTime.now();
  late Future<WeatherClass> weather;

  String _res2 = '';
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();
  //   weather = fetchWeather();
  // }

  void _hapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  // Future<void> _refresher() async {
  //   setState(() {
  //     weather = fetchWeather();
  //     updatedAt = new DateTime.now();
  //   });
  // }

  Future _getThingsOnStartup() async {
    weather = fetchWeather();
    await Future.delayed(Duration(seconds: 2));
  }

  // Future<void> _goBack() async {
  //   Navigator.pop(context);
  // }

  getTimelineView(BuildContext context) {
    return Navigator.of(context).pushNamed('/timeline');
  }

  // Widget buildAdmob(Entitlement entitlement) {
  //   switch (entitlement) {
  //     case Entitlement.pro:
  //       return Container();
  //     case Entitlement.free:
  //       return Center(child: Text('＾q＾'));
  //   }
  // }

  // Future<bool> isPurchased() async {
  //     PurchaserInfo purchaseInfo = await Purchases.getPurchaserInfo();
  //     if (purchaseInfo.entitlements.all["pro"].isActive) {
  //       return true;
  //     } else
  //       return false;
  //   }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final weatherProvider = FutureProvider<WeatherClass>((ref) async {
      final content = await fetchWeather();
      return content;
    });
    final config = watch(weatherProvider);
    

// final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;

    // return StatefulWrapper(
    //   onInit: (){
    //     _getThingsOnStartup();
    //   },
      return Scaffold(
        key: _scaffoldKey,
        appBar: neu.NeumorphicAppBar(
          centerTitle: true,
          title: const Text(
            "",
          ),
          leading: IconButton(
            icon: Icon(Icons.share_outlined),
            onPressed: () {
              // // Share.share('低気圧しんどいぴえん🥺️ #thekiatsu');
              // Share.share(snapshot.data!.main.pressure.toString() +
              //     'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
            },
          ),
          actions: <Widget>[
            /** Builder がないと「Navigatorを含むコンテクストが必要」って怒られる */
            Builder(
              builder: (context) => IconButton(
                  icon: neu.NeumorphicIcon(
                    Icons.notifications_outlined,
                    size: 25,
                    style: neu.NeumorphicStyle(color: Colors.black87),
                  ),
                  onPressed: () async {
                    // 未実装ダイアログ
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return CustomDialogBox(
                    //         title: "てへぺろ☆(ゝω･)vｷｬﾋﾟ",
                    //         descriptions: "この機能はまだ未実装です♡",
                    //         text: "おけまる",
                    //         key: UniqueKey(),
                    //       );
                    //     });
                    fetchWeather();
                  }),
            )
          ],
        ),
        body: config.when(
            data: (config) {
              return Container(
                key: GlobalKey(),
                child: RefreshIndicator(
                  color: Colors.black,
                  onRefresh: () => fetchWeather(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 85,
                          width: double.maxFinite,
                          child: Center(
                            child: neu.NeumorphicText(
                              // snapshot.data!.main.pressure.toString(),
                              config.main.pressure.toString(),
                              // '999',
                              style: neu.NeumorphicStyle(
                                depth: 20,
                                intensity: 1,
                                color: Colors.black,
                              ),
                              textStyle: neu.NeumorphicTextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.w200,
                                  fontSize: 75.0),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          height: 70,
                          width: double.maxFinite,
                          child: Center(
                            child: neu.NeumorphicText(
                              'hPa',
                              style: neu.NeumorphicStyle(
                                depth: 20,
                                intensity: 1,
                                color: Colors.black,
                              ),
                              textStyle: neu.NeumorphicTextStyle(
                                  fontWeight: FontWeight.w200, fontSize: 75.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.0),
                      Container(
                        height: 140,
                        alignment: Alignment.center,
                        child: config.weather[0].main.toString() == 'Clouds'
                            ? neu.NeumorphicText(
                                'Cloudy',
                                style: neu.NeumorphicStyle(color: Colors.black),
                                textStyle: neu.NeumorphicTextStyle(
                                    fontWeight: FontWeight.w200, fontSize: 56.0),
                              )
                            : config.weather[0].main.toString() == 'Clear'
                                ? neu.NeumorphicText(
                                    'Clear',
                                    style: neu.NeumorphicStyle(
                                      color: Colors.black,
                                    ),
                                    textStyle: neu.NeumorphicTextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 56.0),
                                  )
                                : config.weather[0].main.toString() == 'Clear Sky'
                                    ? neu.NeumorphicText(
                                        'Sunny',
                                        style: neu.NeumorphicStyle(
                                            color: Colors.black),
                                        textStyle: neu.NeumorphicTextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 56.0),
                                      )
                                    : config.weather[0].main.toString() == 'Rain'
                                        ? neu.NeumorphicText('Rainy',
                                            style: neu.NeumorphicStyle(
                                                color: Colors.black),
                                            textStyle: neu.NeumorphicTextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 56.0))
                                        : neu.NeumorphicText(
                                            config.weather[0].main.toString(),
                                            style: neu.NeumorphicStyle(
                                              color: Colors.black,
                                            ),
                                            textStyle: neu.NeumorphicTextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 56.0),
                                          ),
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[],
                        ),
                      ),
                      SizedBox(height: 40.0),
                      Center(
                        child: int.parse(config.main.pressure.toString()) <= 1000
                            ? Text(
                                'DEADLY',
                                style: TextStyle(
                                    color: Colors.redAccent[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 80.0),
                              )
                            : int.parse(config.main.pressure.toString()) <= 1008
                                ? const Text(
                                    'YABAME',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                : int.parse(config.main.pressure.toString()) <= 1010
                                    ? const Text(
                                        "CHOI-YABAME",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    : Center(
                                        child: const Text(
                                        '',
                                        style: TextStyle(
                                          fontSize: 28.5,
                                          color: Colors.black,
                                        ),
                                      )),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Center(
                        // 5日分の天気データ
                        child: Text(_res2,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100)),
                      ),
                      Center(
                        child: neu.NeumorphicText(
                          "最終更新 - " +
                              timeago.format(updatedAt, locale: 'ja').toString(),
                          style: neu.NeumorphicStyle(
                            // height: 1, // 10だとちょうど下すれすれで良い感じ
                            color: Colors.black,
                          ),
                          textStyle: neu.NeumorphicTextStyle(),
                        ),
                      ),
                      Center(
                        child: Text(
                          _res2,
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w100),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            loading: () => Container(
                  child: Center(
                    child: const Text('FETCHING DATA...'),
                  ),
                ),
            error: (error, stack) {
              Text('Error: $error');
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FutureBuilder<WeatherClass>(
            future: GetWeather().getWeather(),
            builder: (context, snapshot) {
              return FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: const Text('＾ｑ＾'),
                  onPressed: () async {
                    // sns share button
                    // https://qiita.com/shimopata/items/142b39bab6176b6a5da9
                    if (snapshot.hasData)
                      await Navigator.of(context).pushNamed('/timeline');

                    //   Share.share(snapshot.data!.main.pressure.toString() +
                    //       'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
                    // showBarModalBottomSheet(
                    //     duration: Duration(milliseconds: 240),
                    //     context: context,
                    //     builder: (context) =>
                    //     Scaffold(
                    //           body:
                    //           // getTimelineView(context),
                    //           getListView(),
                    //         ));
                    else {
                      _scaffoldKey.currentState!.showSnackBar(SnackBar(
                        content: const Text("先に情報を読み込んでね＾ｑ＾"),
                        action: SnackBarAction(
                          label: '読込',
                          onPressed: () => fetchWeather(),
                        ),
                      ));
                    }
                  });
            }),
        bottomNavigationBar: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 課金状況に応じて広告表示がトグルされる
            // buildAdmob(entitlement),
            BottomAppBar(
              color: Colors.white,
              notchMargin: 6.0,
              shape: AutomaticNotchedShape(
                  RoundedRectangleBorder(),
                  StadiumBorder(
                    side: BorderSide(),
                  )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.search_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // Navigator.of(context).pushNamed('/timeline');
                        // 未実装ダイアログ
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CustomDialogBox(
                                title: "てへぺろ☆(ゝω･)vｷｬﾋﾟ",
                                descriptions: "この機能はまだ未実装です♡",
                                text: "おけまる",
                                key: UniqueKey(),
                              );
                            });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.home_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        await Navigator.of(context).pushNamed('/a');
                        // await Navigator.of(context).pushNamed('/iap');
                      },
                    ),
                  ],
                ),
              ),
            ),
            // FutureBuilder<bool>(
            //     future: ,
            //     builder: (context, snapshot) {
            //       return (snapshot.hasData)
            //           ? Container()
            //           : Container(
            //               child: Center(
            //                 child: Text('＾q＾'),
            //               ),
            //             );
            //     }),
          ],
        ),
      );
    // );
  }
}
