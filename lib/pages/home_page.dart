import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocation/geolocation.dart';
import 'package:kiatsu/env/production_secrets.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:kiatsu/pages/chart_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
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
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;


  Future<WeatherClass> weather;

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
    final GeolocationResult result =
        await Geolocation.requestLocationPermission(
      permission: const geo.LocationPermission(
        android: LocationPermissionAndroid.fine,
        ios: LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );

    if (result.isSuccessful) {
      final rr = ProductionSecrets().firebaseApiKey;
      final result = await Geolocation.lastKnownLocation();
      double lat = result.location.latitude;
      double lon = result.location.longitude;
      String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
          lat.toString() +
          '&lon=' +
          lon.toString() +
          '&APPID=$rr';
      final response = await http.get(url);
      return WeatherClass.fromJson(jsonDecode(response.body));
    } else {
      switch (result.error.type) {
        case geo.GeolocationResultErrorType.runtime:
          return showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Runtime Error"),
                );
              });
        case geo.GeolocationResultErrorType.locationNotFound:
          return showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Location Not Found"),
                );
              });
        case geo.GeolocationResultErrorType.serviceDisabled:
          return showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Service are disabled"),
                );
              });
        case geo.GeolocationResultErrorType.permissionNotGranted:
          return showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text("Permission For Location Not Granted"),
                );
              });
        case geo.GeolocationResultErrorType.permissionDenied:
          return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("kiatsuへようこそ！"),
                  content: Text('さぁ、はじめましょう。'),
                  actions: <Widget>[
                    FlatButton(
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
        case geo.GeolocationResultErrorType.playServicesUnavailable:
          switch (
              result.error.additionalInfo as GeolocationAndroidPlayServices) {
            case geo.GeolocationAndroidPlayServices.missing:
              return showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Something went wrong with Play Services"),
                    );
                  });
            case geo.GeolocationAndroidPlayServices.updating:
              return showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Something went wrong with Play Services"),
                    );
                  });
            case geo.GeolocationAndroidPlayServices.versionUpdateRequired:
              return showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Play Services gotta be updated"),
                    );
                  });
            case geo.GeolocationAndroidPlayServices.disabled:
              return showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Play Services are disabled"),
                    );
                  });
            case geo.GeolocationAndroidPlayServices.invalid:
              return showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Text("Something went wrong with Play Services"),
                    );
                  });
          }
          break;
      }
      return showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text("Something went wrong with Play Services"),
            );
          });
    }
  }

  Future<void> _goBack() async {
    Navigator.pop(
      context
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: const Text(
          "",
        ),
        leading: IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share('低気圧しんどいぴえん🥺️ #thekiatsu');
            // Share.share(future.data.main.pressure.toString() +
            //             'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
          },
        ),
        actions: <Widget>[
          /** Builder がないと「Navigatorを含むコンテクストが必要」って怒られる */
          Builder(
            builder: (context) => IconButton(
                icon: NeumorphicIcon(
                  Icons.settings,
                  size: 45,
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
                              snapshot.data.main.pressure.toString(),
                              style: NeumorphicStyle(
                                depth: 20,
                                intensity: 1,
                                color: Colors.black,
                              ),
                              textStyle: NeumorphicTextStyle(
                                  // color: Colors.white,
                                  fontWeight: FontWeight.w400,
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
                                  fontWeight: FontWeight.w400, fontSize: 75.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 1.0),
                      Container(
                        height: 140,
                        alignment: Alignment.center,
                        child: snapshot.data.weather[0].main.toString() ==
                                'Clouds'
                            ? NeumorphicText(
                                'Cloudy',
                                style: NeumorphicStyle(color: Colors.black),
                                textStyle: NeumorphicTextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 56.0),
                              )
                            : snapshot.data.weather[0].main.toString() ==
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
                                : snapshot.data.weather[0].main.toString() ==
                                        'Clear Sky'
                                    ? NeumorphicText(
                                        'Sunny',
                                        style: NeumorphicStyle(
                                            color: Colors.black),
                                        textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 56.0),
                                      )
                                    : snapshot.data.weather[0].main
                                                .toString() ==
                                            'Rain'
                                        ? NeumorphicText('Rainy',
                                            style: NeumorphicStyle(
                                                color: Colors.black),
                                            textStyle: NeumorphicTextStyle(
                                                fontWeight: FontWeight.w200,
                                                fontSize: 56.0))
                                        : NeumorphicText(
                                            snapshot.data.weather[0].main
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
                        child: snapshot.data.main.pressure <= 1000
                            ? Text(
                                'DEADLY',
                                style: TextStyle(
                                    color: Colors.redAccent[700],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 80.0),
                              )
                            : snapshot.data.main.pressure <= 1008
                                ? const Text(
                                    'YABAME',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                : snapshot.data.main.pressure <= 1010
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
                    // Share.share(snapshot.data.main.pressure.toString() +
                    //     'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
                    showBarModalBottomSheet(
                        duration: Duration(milliseconds: 240),
                        context: context,
                        builder: (context, scrollController) => Scaffold(
                              body: getListView(),
                              // body: _buildBody(context),
                            ));
                  else {
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
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
                  Icons.textsms,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/timeline');
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.black,
                ),
                onPressed: () {
                  showBarModalBottomSheet(
                      duration: Duration(milliseconds: 240),
                      context: context,
                      builder: (context, scrollController) => PieChartPage());
                },
              ),
            ],
          ),
        ),
      ),
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
                .doc(firebaseAuth.currentUser.uid)
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
                .doc(firebaseAuth.currentUser.uid)
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
                .doc(firebaseAuth.currentUser.uid)
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
Widget _pienVote() {
  return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('pienn2')
          .doc('超ぴえん')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        var userField = snapshot.data.documents.map;
        // if(snapshot.hasData)
        return Column(
          children: <Widget>[
            Text(
              userField['votes'].toString(),
            ),
            Text(
              'Pien Rate',
              style: TextStyle(fontSize: 18.0, color: Colors.black),
            ),
          ],
        );
      });
}

class Record {
  final String pienDo;
  final int votes;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['pien_do'] != null),
        assert(map['votes'] != null),
        pienDo = map['pien_do'],
        votes = map['votes'];

  Record.fromSnapshot(DocumentSnapshot snaps)
      : this.fromMap(snaps.data(), reference: snaps.reference);

  @override
  String toString() => "Record<$pienDo:$votes>";
}
