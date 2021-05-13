import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocation/geolocation.dart';
import 'package:kiatsu/env/production_secrets.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

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
  // final PermissionHandler permissionHandler = PermissionHandler();
  // Map<PermissionGroup, PermissionStatus> permissions;

  late Future<WeatherClass> weather;

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
      final rr = ProductionSecrets().firebaseApiKey;
      final result = await Geolocation.lastKnownLocation();
      double lat = result.location.latitude;
      double lon = result.location.longitude;
      // var url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
      //     lat.toString() +
      //     '&lon=' +
      //     lon.toString() +
      //     '&APPID=$rr';
      // var endpointUrl = 'https://api.openweathermap.org/data/2.5/weather';
      Map<String, String> queryParams = {
        'lat': lat.toString(),
        'lon': lon.toString(),
        'APPID': rr.toString(),
      };
      // var queryString = Uri(queryParameters: queryParams).query;
      // var requestUrl = endpointUrl + '?' + queryString;
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
    } return test;
  }

  Future<void> _goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WeatherClass>(
      future: weather,
      builder: (context, snapshot) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: NeumorphicAppBar(
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
                    icon: NeumorphicIcon(
                      Icons.settings_outlined,
                      size: 25,
                      style: NeumorphicStyle(
                        color: Colors.black87),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/a');
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
                                child: NeumorphicText(
                                  snapshot.data!.main.pressure.toString(),
                                  style: NeumorphicStyle(
                                    depth: 20,
                                    intensity: 1,
                                    color: Colors.black,
                                  ),
                                  textStyle: NeumorphicTextStyle(
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
                                child: NeumorphicText(
                                  'hPa',
                                  style: NeumorphicStyle(
                                    depth: 20,
                                    intensity: 1,
                                    color: Colors.black,
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.w200, fontSize: 75.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 1.0),
                          Container(
                            height: 140,
                            alignment: Alignment.center,
                            child: snapshot.data!.weather[0].main.toString() ==
                                    'Clouds'
                                ? NeumorphicText(
                                    'Cloudy',
                                    style: NeumorphicStyle(color: Colors.black),
                                    textStyle: NeumorphicTextStyle(
                                        fontWeight: FontWeight.w200,
                                        fontSize: 56.0),
                                  )
                                : snapshot.data!.weather[0].main.toString() ==
                                        'Clear'
                                    ? NeumorphicText(
                                        'Clear',
                                        style: NeumorphicStyle(
                                          color: Colors.black,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 56.0),
                                      )
                                    : snapshot.data!.weather[0].main.toString() ==
                                            'Clear Sky'
                                        ? NeumorphicText(
                                            'Sunny',
                                            style: NeumorphicStyle(
                                                color: Colors.black),
                                            textStyle: NeumorphicTextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 56.0),
                                          )
                                        : snapshot.data!.weather[0].main
                                                    .toString() ==
                                                'Rain'
                                            ? NeumorphicText('Rainy',
                                                style: NeumorphicStyle(
                                                    color: Colors.black),
                                                textStyle: NeumorphicTextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 56.0))
                                            : NeumorphicText(
                                                snapshot.data!.weather[0].main
                                                    .toString(),
                                                style: NeumorphicStyle(
                                                  color: Colors.black,
                                                ),
                                                textStyle: NeumorphicTextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 56.0),
                                              ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                // _pienRate(context),
                              ],
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
                            child: NeumorphicText(
                              "最終更新 - " +
                                  timeago
                                      .format(updatedAt, locale: 'ja')
                                      .toString(),
                              style: NeumorphicStyle(
                                // height: 1, // 10だとちょうど下すれすれで良い感じ
                                color: Colors.black,
                              ),
                              textStyle: NeumorphicTextStyle(),
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
                } else {
                  return Container(
                    child: Center(
                      child: const Text('FETCHING DATA...'),
                    ),
                  );
                }
              }),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FutureBuilder<WeatherClass>(
              future: getWeather(),
              builder: (context, snapshot) {
                return FloatingActionButton(
                    backgroundColor: Colors.white,
                    child: const Text('＾ｑ＾'),
                    onPressed: () {
                      // sns share button
                      // https://qiita.com/shimopata/items/142b39bab6176b6a5da9
                      if (snapshot.hasData)
                      //   Share.share(snapshot.data!.main.pressure.toString() +
                      //       'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
                      showBarModalBottomSheet(
                          duration: Duration(milliseconds: 240),
                          context: context,
                          builder: (context) => Scaffold(
                                body: getListView(),
                                // body: _buildBody(context),
                              ));
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
          bottomNavigationBar: BottomAppBar(
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
                      Icons.textsms_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/timeline');
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.map_outlined,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/a');
                      // showBarModalBottomSheet(
                      //     duration: Duration(milliseconds: 240),
                      //     context: context,
                      //     builder: (context, scrollController) => PieChartPage(),
                      //     );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }

  Widget getListView() {
    return Column(
      children: <Widget>[
        ListTile(
            title: Center(
              child: NeumorphicText(
                "ぴえんなう？",
                duration: Duration(microseconds: 200),
                style: NeumorphicStyle(
                  depth: 20,
                  intensity: 1,
                  color: Colors.black,
                ),
                textStyle: NeumorphicTextStyle(
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
                  NeumorphicText(
                    '超ぴえん',
                    duration: Duration(microseconds: 200),
                    style: NeumorphicStyle(
                      color: const Color(0xff333333),
                    ),
                    textStyle: NeumorphicTextStyle(
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
                  NeumorphicText(
                    'ぴえん',
                    duration: Duration(microseconds: 200),
                    style: NeumorphicStyle(
                      color: const Color(0xff333333),
                    ),
                    textStyle: NeumorphicTextStyle(
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
                  NeumorphicText(
                    'ぴえんじゃない',
                    duration: Duration(microseconds: 200),
                    style: NeumorphicStyle(
                      color: const Color(0xff333333),
                    ),
                    textStyle: NeumorphicTextStyle(
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
}

class Record {
  final String pienDo;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {required this.reference})
      : assert(map['pien_do'] != null),
        assert(map['votes'] != null),
        pienDo = map['pien_do'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snaps)
      : this.fromMap(snaps.data()!, reference: snaps.reference);

  @override
  String toString() => "Record<$pienDo:$votes>";
}
