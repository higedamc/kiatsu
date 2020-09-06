import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocation/geolocation.dart' as geo;
import 'package:kiatsu/model/weather_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:package_info/package_info.dart';
// import 'package:package_info/package_info.dart';
// import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:kiatsu/const/constant.dart' as Constant;
import 'package:weather/weather.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String a = Constant.key;
  // int _counter = 0;

  DateTime updatedAt = new DateTime.now();
  // RemoCon _remo;
  // final remoteConfig = RemoteConfig.instance;

  Weather w;

// List<Weather> _data = [];
  // _MyAppState({this.remoteConfig});

  // final RemoteConfig remoteConfig;

  // 以下 2 つ Wiredash 用のストリング
  // String b = Constant.projectId;
  // String c = Constant.secret;

  Future<WeatherClass> weather;
  // String a = "app";

  // WeatherStationクラスが廃止っぽいので停止
  // WeatherStation ws = new WeatherStation(a);
  // WeatherFactory wf = WeatherFactory(a);
  WeatherFactory ws;

  String _res2 = '';
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // final getMo = locator<RemoteConfigService>();
    // a = getMo.getSomething;
    // print(a);
    weather = getWeather();
    super.initState();
    // ws = new WeatherFactory(a, language: Language.JAPANESE);
  }

  Future<void> _refresher() async {
    setState(() {
      weather = getWeather();
      updatedAt = new DateTime.now();
      // 引っ張ったときに5日分の天気データ取得する
      // queryForecast();
    });
  }

// Future<void> _reload() async {
//   weather = getWeather();
//   updatedAt = new DateTime.now();
//   setState(() {

//   });
// }

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
  // Map<dynamic, String> _future() {
  //   _remo.fetch(expiration: Duration(hours: 1));
  //   _remo.activateFetched();
  //   var yeah = _remo.getValue('app').asString();
  //   return yeah;
  // }
//   Future<RemoteConfig> setupRemoteConfig() async {
//   // final RemoteConfig remoteConfig = await RemoteConfig.instance;
//   RemoteConfig remoteConfig;
//   remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
//   remoteConfig.setDefaults(<String, dynamic>{
//     'nyan_nyan': 'F-U',
//   });

//   try {
//     // Using default duration to force fetching from remote server.
//     await remoteConfig.fetch();
//     await remoteConfig.activateFetched();
//   } on FetchThrottledException catch (exception) {
//     // Fetch throttled.
//     print(exception);
//   } catch (exception) {
//     print(exception);
//   }
//   return remoteConfig;
// }

  Future<WeatherClass> getWeather() async {
    // PackageInfo info = await PackageInfo.fromPlatform();
    // List<String> items = info.packageName.split(".");
    // var t = _remoteConfig.instance.getValue('app');
    // print(t);
    // RemoteConfig _remoteConfig;
    // await _remoteConfig.init();
    // await _remoteConfig.instance.fetch();
    // await _remoteConfig.instance.activateFetched();
    // String two = await _remoteConfig.getStringed(items[2]);
    // _remo = await RemoteConfig.instance;
    // await _remo.fetch(expiration: Duration(hours: 1));
    // await _remo.activateFetched();
    // var yeah = _remo.getValue('app').asString();
    // var ahe = await setupRemoteConfig();
    // var ahe2 = ahe.getValue('app').toString();
    // var nya2 = jsonDecode(nya);
    // await RemoteConfigService().initialize();
    // var a = RemoteConfigService().getSomething;
    // if(a.isEmpty){
    //   a = "app";
    // }
    // final storage = new FlutterSecureStorage();
    // var value = storage.read(key: a);
    final geo.GeolocationResult result =
        await geo.Geolocation.requestLocationPermission(
      permission: const geo.LocationPermission(
        android: geo.LocationPermissionAndroid.fine,
        ios: geo.LocationPermissionIOS.always,
      ),
      openSettingsIfDenied: true,
    );

    if (result.isSuccessful) {
      // location permission is granted (or was already granted before making the request)
      var test =
          geo.Geolocation.currentLocation(accuracy: geo.LocationAccuracy.block);
      print(test);

      geo.LocationResult result = await geo.Geolocation.lastKnownLocation();
      double lat = result.location.latitude;
      double lon = result.location.longitude;
      String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
          lat.toString() +
          '&lon=' +
          lon.toString() +
          '&APPID=$a';
      final response = await http.get(url);
      // var encoded = jsonEncode(w);
      return WeatherClass.fromJson(jsonDecode(response.body));
    } else {
      // location permission is not granted
      // user might have denied, but it's also possible that location service is not enabled, restricted, and user never saw the permission request dialog. Check the result.error.type for details.
      return null;
    }
    // String url = 'http://api.openweathermap.org/data/2.5/weather?lat=' +
    //     _locationData.latitude.toString() +
    //     '&lon=' +
    //     _locationData.longitude.toString() +
    //     '&APPID=$a';
    // final response = await http.get(url);
    // // var encoded = jsonEncode(w);
    // return WeatherClass.fromJson(jsonDecode(response.body));
  }

  // @override

  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: NeumorphicAppBar(
        // elevation: 0.0,
        // Gradient化
        // gradient: LinearGradient(
        //     begin: Alignment.topLeft,
        //     end: Alignment.bottomRight,
        //     colors: [const Color(0xFFb43a8b), const Color(0xFFfc45bf)],
        //     tileMode: TileMode.repeated),
        centerTitle: true,
        title: const Text(
          "",
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
                  Navigator.of(context).pushNamed('/a');
                }),
          )
        ],
      ),
      body: FutureBuilder<WeatherClass>(
          future: weather,
          builder: (context, snapshot) {
            // if (snapshot.connectionState != ConnectionState.done) {
            //   return Center(
            //     child: CircularProgressIndicator(),
            //   );
            // }
            if (snapshot.hasError) print(snapshot.error);
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Container(
                // Gradiention化
                // decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //         begin: Alignment.topLeft,
                //         end: Alignment.bottomRight,
                //         colors: [
                //           const Color(0xFFb43a8b),
                //           const Color(0xFFfc45bf)
                //         ],
                //         tileMode: TileMode.repeated)),
                // color: Colors.black,
                key: GlobalKey(),
                child: RefreshIndicator(
                  color: Colors.black,
                  onRefresh: () => _refresher(),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: <Widget>[
                      // Container(
                      //   child: Center(
                      //     child: Container(
                      //       padding: EdgeInsets.all(10.0),
                      //       margin: EdgeInsets.all(10.0),
                      //       child: Text(
                      //         snapshot.,
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontWeight: FontWeight.w100,
                      //             fontSize: 18.0),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 24.0,
                      // ),
                      Center(
                        child: Container(
                          // color: Colors.amber,
                          // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                          // color: Colors.amber,
                          // padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                      // Container(
                      //   height: 100,
                      //   alignment: Alignment.center,
                      //   child: Text('test'),
                      // ),
                      SizedBox(height: 1.0),
                      Container(
                        // constraints: BoxConstraints.expand(),
                        height: 140,
                        // width: 50,
                        alignment: Alignment.center,
                        child: snapshot.data.weather[0].main.toString() ==
                                'Clouds'
                            ? Text(
                                'Cloudy',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 70.0),
                              )
                            : snapshot.data.weather[0].main.toString() ==
                                    'Clear Sky'
                                ? Text(
                                    'Sunny',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w100,
                                        fontSize: 70.0),
                                  )
                                : snapshot.data.weather[0].main.toString() ==
                                        'Rain'
                                    ? Text(
                                        'Rainy',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w100,
                                            fontSize: 70.0),
                                      )
                                    : Text(
                                        snapshot.data.weather[0].main
                                            .toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w200,
                                          fontSize: 30,
                                        ),
                                      ),
                      ),
                      SizedBox(height: 56.0),
                      Center(
                        child: snapshot.data.main.pressure <= 1000
                            ? Text(
                                'DEADLY',
                                style: TextStyle(
                                    color: Colors.redAccent[700],
                                    // fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 80.0),
                              )
                            : snapshot.data.main.pressure <= 1008
                                ? Text(
                                    'YABAME',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                : snapshot.data.main.pressure <= 1010
                                    ? Text(
                                        "CHOI-YABAME",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                        'KAITEKI',
                                        style: TextStyle(
                                          fontSize: 28.5,
                                          color: Colors.black,
                                        ),
                                      )),
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
                        child: Text(
                          "Last Update - " +
                              timeago
                                  .format(updatedAt, locale: 'ja')
                                  .toString(),
                          style: TextStyle(
                              height: 1, // 10だとちょうど下すれすれで良い感じ
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
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
              // return Container(
              //   child: Center(
              //     // child: Text('NO DATA'),
              //     child: CircularProgressIndicator(),
              //   ),
              // );
              return Container(
                child: Center(
                  child: Text('FETCHING DATA...'),
                ),
              );
              // return Container();

            }
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FutureBuilder<WeatherClass>(
          future: getWeather(),
          builder: (context, snapshot) {
            return FloatingActionButton(
                backgroundColor: Colors.white,
                // child: Icon(
                //   Icons.share,
                //   color: Colors.black,
                //   ),
                child: Text('＾ｑ＾'),
                onPressed: () {
                  // sns share button
                  // https://qiita.com/shimopata/items/142b39bab6176b6a5da9
                  if (snapshot.hasData)
                    // Share.share(snapshot.data.main.pressure.toString() +
                    //     'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
                    showBarModalBottomSheet(
                        context: context,
                        builder: (context, scrollController) => Scaffold(
                              body: getListView(),
                              // body: _buildBody(context),
                            ));
                  else {
                    _scaffoldKey.currentState.showSnackBar(
                        SnackBar(content: const Text("先に情報を読み込んでね＾ｑ＾")));
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
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.black,
                ),
                onPressed: () {
                  showBarModalBottomSheet(
                      context: context,
                      builder: (context, scrollController) => Container(
                            child: Text('TEST'),
                          ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('pienn2').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Container(
            child: Center(
              child: Text('FETCHING DATA...'),
            ),
          );
        return _buildList(context, snapshot.data.docs);
        // return getListView(context, snapshot.data);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Container(
      child: ListView(
        padding: const EdgeInsets.only(top: 20.0),
        children:
            snapshot.map((data) => _buildListItem(context, data)).toList(),
        // children: snapshot.map((data) => getListView(context, data)).toList(),
      ),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);

    return Padding(
      key: ValueKey(record.pienDo),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Center(
          child: ListTile(
            title: Text(record.pienDo),
            trailing: Text(record.votes.toString()),
            onTap: () =>
                record.reference.update({'votes': FieldValue.increment(1)}),
          ),
        ),
      ),
    );
  }

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
                style: NeumorphicStyle(
                  depth: 20,
                  intensity: 1,
                  color: Colors.black,
                ),
                textStyle: NeumorphicTextStyle(
                    fontWeight: FontWeight.w500, fontSize: 56.0),
              ),
            ),
            // trailing: Text(data.get('votes').toString()),
            onTap: () {
              // FirebaseFirestore.instance.runTransaction((transaction) async {
              //   DocumentSnapshot freshData =
              //       await transaction.get(data.reference);
              //   transaction.update(
              //       freshData.reference, {'votes': freshData.get('votes') + 1});
              // });
            }),
        SizedBox(
          width: 100,
          height: 100,
        ),
        // _buildBody(context),
        InkWell(
          onTap: () async {
            await FirebaseFirestore.instance
                .collection('pienn2')
                .doc("超ぴえん")
                .update({"votes": FieldValue.increment(1)});
            await alertDialog(context);
          },
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  NeumorphicText(
                    '超ぴえん',
                    style: NeumorphicStyle(
                      // fontSize: 26,
                      // fontWeight: FontWeight.bold,
                      color: const Color(0xff333333),
                    ),
                    textStyle: NeumorphicTextStyle(
                        fontWeight: FontWeight.w500, fontSize: 40),
                  ),
                ]),
          ),
        ),
        Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                NeumorphicText(
                  'ぴえん',
                  style: NeumorphicStyle(
                    // fontSize: 26,
                    // fontWeight: FontWeight.bold,
                    color: const Color(0xff333333),
                  ),
                  textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.w500, fontSize: 40),
                ),
                // Text(
                //   'Test description!',
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.normal,
                //     color: const Color(0xff333333),
                //   ),
                // ),
              ]),
        ),
        // GestureDetector(
        //   onTap: () async {
        //     await FirebaseFirestore.instance
        //     .collection('pienn2')
        //     .doc("ぴえんじゃない")
        //     .update(
        //       {
        //         "votes": FieldValue.increment(1)
        //       }
        //     );
        //   },
        // ),
        Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10),
                NeumorphicText(
                  'ぴえんじゃない',
                  style: NeumorphicStyle(
                    // fontSize: 26,
                    // fontWeight: FontWeight.bold,
                    color: const Color(0xff333333),
                  ),
                  textStyle: NeumorphicTextStyle(
                      fontWeight: FontWeight.w500, fontSize: 40),
                ),
                // Text(
                //   'Test description!',
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.normal,
                //     color: const Color(0xff333333),
                //   ),
                // ),
              ]),
        ),
        // あとで見る用
        // ListTile(
        //   leading: Icon(Icons.airline_seat_individual_suite),
        //   title: Text('Wake Up!'),
        //   subtitle: Text('Dont Sleep!'),
        //   trailing: Icon(Icons.airline_seat_flat_angled),
        // )
      ],
    );
    // return listview;
  }

  Future<void> alertDialog(BuildContext context) {
    var alert = AlertDialog(
      title: Text("なんで押したｗｗｗｗｗ"),
      content: Text("なんもないよ？？？？ｗｗｗｗｗ"),
    );
    return showDialog(
        context: context, builder: (BuildContext context) => alert);
  }

  void alertDialog2(BuildContext context) {
    var alert = AlertDialog(
      title: Text("Wake Up!"),
      content: Text("It's Time To Get Up!"),
    );
    showDialog(context: context, builder: (BuildContext context) => alert);
  }
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