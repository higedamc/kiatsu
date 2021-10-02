import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocation/geolocation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kiatsu/Provider/revenuecat.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/pages/timeline.dart';
import 'package:kiatsu/utils/weather_request.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wiredash/wiredash.dart';

import 'custom_dialog_box.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final CollectionReference users = firebaseStore.collection('users');
final currentUser = firebaseAuth.currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime updatedAt = DateTime.now();
  late Future<WeatherClass> weather;
  late final List<WeatherClass> weathers;

  String _res2 = '';
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    weather = getWeather();
  }

  void _hapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  Future<void> _refresher() async {
    setState(() {
      weather = getWeather();
      updatedAt = new DateTime.now();
    });
  }

  Future<WeatherClass> getWeather() async {
    var test;
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(
      permission: const geo.LocationPermission(
        android: LocationPermissionAndroid.coarse,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );

    if (result.isSuccessful) {
      final rr = dotenv.dotenv.env['FIREBASE_API_KEY'];
      final result = await Geolocation.lastKnownLocation();
      double lat = result.location.latitude;
      double lon = result.location.longitude;
      Map<String, String> queryParams = {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'APPID': rr.toString(),
      };
      var uri = Uri(
        scheme: 'https',
        host: 'api.openweathermap.org',
        path: '/data/2.5/weather',
        queryParameters: queryParams,
      );
      final response = await http.get(uri);
      return WeatherClass.fromJson(jsonDecode(response.body));
    } else {
      switch (result.error.type) {
        case geo.GeolocationResultErrorType.runtime:
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Runtime Error"),
                );
              });
          break;
        case geo.GeolocationResultErrorType.locationNotFound:
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Location Not Found"),
                );
              });
          break;
        case geo.GeolocationResultErrorType.serviceDisabled:
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Service are disabled"),
                );
              });
          break;
        case geo.GeolocationResultErrorType.permissionNotGranted:
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Permission For Location Not Granted"),
                );
              });
          break;
        case geo.GeolocationResultErrorType.permissionDenied:
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("kiatsuへようこそ！"),
                  content: Text('さぁ、はじめましょう。'),
                  actions: <Widget>[
                    TextButton(
                        child: Text("OK"),
                        onPressed: () async {
                          await _refresher();
                          // 1回の実行じゃ何故か戻らないのでawaitで2回実行させるというクソ仕様なので誰か直して＾q＾
                          await _goBack();
                          await _goBack();
                        }),
                  ],
                );
              });
          break;
        case geo.GeolocationResultErrorType.playServicesUnavailable:
          switch (
              result.error.additionalInfo as GeolocationAndroidPlayServices) {
            case geo.GeolocationAndroidPlayServices.missing:
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Something went wrong with Play Services"),
                    );
                  });
              break;
            case geo.GeolocationAndroidPlayServices.updating:
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Something went wrong with Play Services"),
                    );
                  });
              break;
            case geo.GeolocationAndroidPlayServices.versionUpdateRequired:
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Play Services gotta be updated"),
                    );
                  });
              break;
            case geo.GeolocationAndroidPlayServices.disabled:
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Play Services are disabled"),
                    );
                  });
              break;
            case geo.GeolocationAndroidPlayServices.invalid:
              showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Something went wrong with Play Services"),
                    );
                  });
              break;
          }
          break;
      }
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("Something went wrong with Play Services"),
            );
          });
    }
    return test;
  }

  Future<void> _goBack() async {
    Navigator.pop(context);
  }

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
            Navigator.of(context).pushNamed('/timeline');
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
            body: FutureBuilder<WeatherClass>(
                future: weather,
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      key: GlobalKey(),
                      child: RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () => _refresher(),
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
                future: getWeather(),
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
                              onPressed: () => _refresher(),
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
