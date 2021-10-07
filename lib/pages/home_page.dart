import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocation/geolocation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/utils/get_weather.dart';
import 'package:kiatsu/utils/providers.dart';
import 'package:kiatsu/utils/refresher.dart';
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

class HomePage extends HookWidget {
  DateTime updatedAt = DateTime.now();
  late Future<WeatherClass> weather;
  late final List<WeatherClass> weathers;

  String _res2 = '';
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  // @override
  // void initState() {
  //   super.initState();
  //   weather = getWeather();
  // }

  void _hapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  // Future<void> _refresher() async {
  //   setState(() {
  //     weather = getWeather();
  //     updatedAt = new DateTime.now();
  //   });
  // }

  

  // Future<void> _goBack() async {
  //   Navigator.pop();
  // }

  getTimelineView(BuildContext context) {
    return Navigator.of(context).pushNamed('/timeline');
  }

  Widget getListView() {
    return Column(
      children: <Widget>[
        ListTile(
            title: Center(
              child: neu.NeumorphicText(
                "ぴえんなう？",
                duration: Duration(microseconds: 200),
                style: neu.NeumorphicStyle(
                  depth: 20,
                  intensity: 1,
                  color: Colors.black,
                ),
                textStyle: neu.NeumorphicTextStyle(
                    fontWeight: FontWeight.w500, fontSize: 56.0),
              ),
            ),
            onTap: () {
              _hapticFeedback();
            }),
        SizedBox(
          width: 100,
          height: 100,
        ),
        InkWell(
          onTap: () async {
            _hapticFeedback();
            // Navigator.of(context).pushNamed('/timeline');
            DateTime today =
                new DateTime(updatedAt.year, updatedAt.month, updatedAt.day);
            print(firebaseAuth.currentUser);
            CollectionReference users = firebaseStore.collection('users');
            await users
                .doc(firebaseAuth.currentUser!.uid)
                .collection('votes')
                .doc(today.toString())
                .update({'pien_rate.cho_pien': FieldValue.increment(1)});
          },
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  neu.NeumorphicText(
                    '超ぴえん',
                    duration: Duration(microseconds: 200),
                    style: neu.NeumorphicStyle(
                      color: const Color(0xff333333),
                    ),
                    textStyle: neu.NeumorphicTextStyle(
                        fontWeight: FontWeight.w500, fontSize: 40),
                  ),
                ]),
          ),
        ),
        InkWell(
          onTap: () async {
            _hapticFeedback();
            DateTime today =
                new DateTime(updatedAt.year, updatedAt.month, updatedAt.day);
            print(firebaseAuth.currentUser);
            CollectionReference users = firebaseStore.collection('users');
            await users
                .doc(firebaseAuth.currentUser!.uid)
                .collection('votes')
                .doc(today.toString())
                .update({'pien_rate.pien': FieldValue.increment(1)});
          },
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  neu.NeumorphicText(
                    'ぴえん',
                    duration: Duration(microseconds: 200),
                    style: neu.NeumorphicStyle(
                      color: const Color(0xff333333),
                    ),
                    textStyle: neu.NeumorphicTextStyle(
                        fontWeight: FontWeight.w500, fontSize: 40),
                  ),
                ]),
          ),
        ),
        InkWell(
          onTap: () async {
            _hapticFeedback();
            DateTime today =
                new DateTime(updatedAt.year, updatedAt.month, updatedAt.day);
            print(firebaseAuth.currentUser);
            CollectionReference users = firebaseStore.collection('users');
            await users
                .doc(firebaseAuth.currentUser!.uid)
                .collection('votes')
                .doc(today.toString())
                .update({'pien_rate.not_pien': FieldValue.increment(1)});
          },
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  neu.NeumorphicText(
                    'ぴえんじゃない',
                    duration: Duration(microseconds: 200),
                    style: neu.NeumorphicStyle(
                      color: const Color(0xff333333),
                    ),
                    textStyle: neu.NeumorphicTextStyle(
                        fontWeight: FontWeight.w500, fontSize: 40),
                  ),
                ]),
          ),
        ),
      ],
    );
  }

  Future<void> alertDialog(BuildContext context) {
    var alert = AlertDialog(
      title: Text("ぴえん度が無事送信されました!"),
      content: Text("これはテスト機能です＾ｑ＾"),
    );
    return showDialog(
        context: context, builder: (BuildContext context) => alert);
  }

  Widget buildAdmob(Entitlement entitlement) {
    switch (entitlement) {
      case Entitlement.pro:
                        return Container();
      case Entitlement.free:
      return Center(child: Text('＾q＾'));
    }
  }

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      weather = GetWeather() as Future<WeatherClass>;
    });
    Future<bool> isPurchased() async {
    PurchaserInfo purchaseInfo = await Purchases.getPurchaserInfo();
    if(purchaseInfo.entitlements.all["pro"]!.isActive){
      return true;
    } else return false;
  }

// final entitlement = Provider.of<RevenueCatProvider>(context).entitlement;
    return FutureBuilder<WeatherClass>(
        future: weather,
        builder: (context, snapshot) {
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
                  // Share.share('低気圧しんどいぴえん🥺️ #thekiatsu');
                  Share.share(snapshot.data!.main.pressure.toString() +
                      'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
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
                      }),
                )
              ],
            ),
            body: Consumer(
                builder: (context, watch, child) {
                  final Refresher refresher = context.read(refresherProvider.notifier);
                  if (snapshot.hasError) print(snapshot.error);
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      key: GlobalKey(),
                      child: RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () => refresher.refresher(),
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 85,
                                width: double.maxFinite,
                                child: Center(
                                  child: neu.NeumorphicText(
                                    snapshot.data!.main.pressure.toString(),
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
                                        fontWeight: FontWeight.w200,
                                        fontSize: 75.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.0),
                            Container(
                              height: 140,
                              alignment: Alignment.center,
                              child: snapshot.data!.weather[0].main
                                          .toString() ==
                                      'Clouds'
                                  ? neu.NeumorphicText(
                                      'Cloudy',
                                      style:
                                          neu.NeumorphicStyle(color: Colors.black),
                                      textStyle: neu.NeumorphicTextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 56.0),
                                    )
                                  : snapshot.data!.weather[0].main
                                              .toString() ==
                                          'Clear'
                                      ? neu.NeumorphicText(
                                          'Clear',
                                          style: neu.NeumorphicStyle(
                                            color: Colors.black,
                                          ),
                                          textStyle: neu.NeumorphicTextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 56.0),
                                        )
                                      : snapshot.data!.weather[0].main
                                                  .toString() ==
                                              'Clear Sky'
                                          ? neu.NeumorphicText(
                                              'Sunny',
                                              style: neu.NeumorphicStyle(
                                                  color: Colors.black),
                                              textStyle: neu.NeumorphicTextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 56.0),
                                            )
                                          : snapshot
                                                      .data!.weather[0].main
                                                      .toString() ==
                                                  'Rain'
                                              ? neu.NeumorphicText(
                                                  'Rainy',
                                                  style:
                                                      neu.NeumorphicStyle(
                                                          color: Colors.black),
                                                  textStyle:
                                                      neu.NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 56.0))
                                              : neu.NeumorphicText(
                                                  snapshot.data!.weather[0].main
                                                      .toString(),
                                                  style: neu.NeumorphicStyle(
                                                    color: Colors.black,
                                                  ),
                                                  textStyle:
                                                      neu.NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 56.0),
                                                ),
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Center(
                              child: snapshot.data!.main.pressure <= 1000
                                  ? Text(
                                      'DEADLY',
                                      style: TextStyle(
                                          color: Colors.redAccent[700],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 80.0),
                                    )
                                  : snapshot.data!.main.pressure <= 1008
                                      ? const Text(
                                          'YABAME',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                      : snapshot.data!.main.pressure <= 1010
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
                                    timeago
                                        .format(updatedAt, locale: 'ja')
                                        .toString(),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: const Text('FETCHING DATA...'),
                      ),
                    );
                  }
                }),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FutureBuilder<WeatherClass>(
                future: weather,
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
                              onPressed: () => null,
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
                        FutureBuilder<bool>(
                          future: isPurchased(),
                          builder: (context, snapshot) {
                            return (snapshot.hasData) ?   Container() : Container(child: Center(child: Text('＾q＾'),),);
                          }
                        ), 
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
              ],
            ),
          );
        });
  }
}

class Record {
  Record.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['pien_do'] != null),
        assert(map['votes'] != null),
        pienDo = map['pien_do'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snaps)
      : this.fromMap(snaps.data()!, reference: snaps.reference);

  final String pienDo;
  final DocumentReference reference;
  final int votes;

  @override
  String toString() => "Record<$pienDo:$votes>";
}
