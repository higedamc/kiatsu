import 'dart:async';
import 'dart:convert';
import 'package:android_intent/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:geocoder/geocoder.dart' as coder;
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocation/geolocation.dart';
import 'package:geolocator/geolocator.dart' as locator;
import 'package:geolocator/geolocator.dart';
import 'package:kiatsu/env/production_secrets.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:kiatsu/pages/chart_page.dart';
import 'package:kiatsu/pages/generate_page.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
// import 'package:kiatsu/const/constant.dart' as Constant;
import 'package:weather/weather.dart';

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

  // 以下 2 つ Wiredash 用のストリング
  // String b = Constant.projectId;
  // String c = Constant.secret;

  Future<WeatherClass> weather;

  String _res2 = '';
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // requestLocationPermission();
    // _gpsService();
    weather = getWeather();
  }

  // Future<bool> _requestPermission(PermissionGroup permission) async {
  //   final PermissionHandler _permissionHandler = PermissionHandler();
  //   var result = await _permissionHandler.requestPermissions([permission]);
  //   if (result[permission] == PermissionStatus.granted) {
  //     return true;
  //   }
  //   return false;
  // }

  // Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
  //   var granted = await _requestPermission(PermissionGroup.location);
  //   if (granted != true) {
  //     requestLocationPermission();
  //   }
  //   debugPrint('requestContactsPermission $granted');
  //   return granted;
  // }

  // Future _checkGps() async {
  //   if (!(await Geolocator.isLocationServiceEnabled())) {
  //     if (Theme.of(context).platform == TargetPlatform.android) {
  //       showDialog(
  //           context: context,
  //           builder: (BuildContext context) {
  //             return AlertDialog(
  //               title: Text("Can't get gurrent location"),
  //               content:
  //                   const Text('Please make sure you enable GPS and try again'),
  //               actions: <Widget>[
  //                 FlatButton(
  //                     child: Text('Ok'),
  //                     onPressed: () {
  //                       final AndroidIntent intent = AndroidIntent(
  //                           action:
  //                               'android.settings.LOCATION_SOURCE_SETTINGS');
  //                       intent.launch();
  //                       Navigator.of(context, rootNavigator: true).pop();
  //                       _gpsService();
  //                     })
  //               ],
  //             );
  //           });
  //     }
  //   }
  // }

  // Future _gpsService() async {
  //   if (!(await Geolocator.isLocationServiceEnabled())) {
  //     _checkGps();
  //     return null;
  //   } else
  //     return true;
  // }

  void _hapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  Future<void> _refresher() async {
    setState(() {
      weather = getWeather();
      updatedAt = new DateTime.now();
      // 引っ張ったときに5日分の天気データ取得する
      // queryForecast();
    });
  }

// Future<void> queryForecast() async {
//    // 位置情報取得
//   Position position = await Geolocator()
//         .getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
//         // Weather クラスに 5日分の天気情報格納
//    List<Weather> f = (await wf.currentWeatherByLocation(position.latitude.toDouble(), position.longitude.toDouble())) as List<Weather>;
//    setState(() {
//      // "_res2" の Text を List "f" にぶっこむ
//      _res2 = f.toString();
//    });
//  }

  Future<WeatherClass> getWeather() async {
    // final test =
    // locator.Geolocator.getCurrentPosition(desiredAccuracy: locator.LocationAccuracy.best);
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
      // var encoded = jsonEncode(w);
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
                    // FlatButton(
                    //   child: Text("Cancel"),
                    //   onPressed: () => Navigator.pop(context),
                    // ),
                    FlatButton(
                        child: Text("OK"),
                        onPressed: () async {
                          await _refresher();
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
    Navigator.pop(context);
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
                child: const Text('QR'),
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
                              body: qrView(),
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
                  // Wiredash.of(context).show();
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

  // Widget _pienRate(BuildContext context) {
  //   CollectionReference _ref = FirebaseFirestore.instance.collection('pienn2');
  //   return FutureBuilder<DocumentSnapshot>(
  //       future: _ref.doc('超ぴえん').get(),
  //       builder:
  //           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
  //         if (snapshot.hasError) return CircularProgressIndicator();
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           Map<String, dynamic> data = snapshot.data.data();
  //           return Column(
  //             children: <Widget>[
  //               Text(
  //                 '${data['votes']}',
  //                 style: TextStyle(fontSize: 30.0, color: Colors.black),
  //               ),
  //               SizedBox(
  //                 width: 10,
  //                 height: 10,
  //               ),
  //               const Text(
  //                 "PIEN",
  //                 style: TextStyle(fontSize: 18.0, color: Colors.black),
  //               ),
  //             ],
  //           );
  //         }
  //         return const Text('FETCHING DATA...');
  //       });
  // }

  // Widget _buildBody(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection('pienn2').snapshots(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData)
  //         return Container(
  //           child: Center(
  //             child: Text('FETCHING DATA...'),
  //           ),
  //         );
  //       return _buildList(context, snapshot.data.docs);
  //       // return getListView(context, snapshot.data);
  //     },
  //   );
  // }

  // Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
  //   return Container(
  //     child: ListView(
  //       padding: const EdgeInsets.only(top: 20.0),
  //       children:
  //           snapshot.map((data) => _buildListItem(context, data)).toList(),
  //       // children: snapshot.map((data) => getListView(context, data)).toList(),
  //     ),
  //   );
  // }

  // Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
  //   final record = Record.fromSnapshot(data);

  //   return Padding(
  //     key: ValueKey(record.pienDo),
  //     padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey),
  //         borderRadius: BorderRadius.circular(5.0),
  //       ),
  //       child: Center(
  //         child: ListTile(
  //           title: Text(record.pienDo),
  //           trailing: Text(record.votes.toString()),
  //           onTap: () =>
  //               record.reference.update({'votes': FieldValue.increment(1)}),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Widget testTile() {
  //   return Center(
  //     child: NeumorphicText(
  //       "ぴえんなう？",
  //       style: NeumorphicStyle(
  //         depth: 20,
  //         intensity: 1,
  //         color: Colors.black,
  //       ),
  //       textStyle:
  //           NeumorphicTextStyle(fontWeight: FontWeight.w500, fontSize: 56.0),
  //     ),
  //   );
  // }

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
        // _buildBody(context),
        InkWell(
          onTap: () async {
            _hapticFeedback();
            DateTime today =
                new DateTime(updatedAt.year, updatedAt.month, updatedAt.day);
            // var tomorrow = updatedAt.add(Duration(days: 1));
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
            // var tomorrow = updatedAt.add(Duration(days: 1));
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
            // var tomorrow = updatedAt.add(Duration(days: 1));
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

  Widget qrView () {
    return ListView(
      children: <Widget> [
        // Card(
        //   child: ListTile(
        //     title: Text('コードをスキャン'),
        //     leading: Icon(MaterialCommunityIcons.qrcode_scan),
        //     onTap: () {
        //       Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (context) => ));
        //     },
        //   ),
        // ),
        Card(
          child: ListTile(
            title: Text('QRコード生成'),
            leading: Icon(MaterialCommunityIcons.qrcode_edit),
            onTap: () {
              Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => GeneratePage()));
            },
          )
        )
      ]
    );
  }
}

Future<void> alertDialog(BuildContext context) {
  var alert = AlertDialog(
    title: Text("ぴえん度が無事送信されました!"),
    content: Text("これはテスト機能です＾ｑ＾"),
  );
  return showDialog(context: context, builder: (BuildContext context) => alert);
}

String dummyData;