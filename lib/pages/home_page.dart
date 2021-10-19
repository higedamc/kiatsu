import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocation/geolocation.dart' as geo;
import 'package:geolocation/geolocation.dart';
import 'package:kiatsu/model/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:kiatsu/utils/providers.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:wiredash/wiredash.dart';

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
  late final String? cityName;
  final DateTime updatedAt = DateTime.now();

  final String? _res2 = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

   void getInitLocation(BuildContext context) async {
    await context.read(locationStateNotifierProvider.notifier).getMyLocation();
  }

   void submitCityName(BuildContext context, String cityName) async {
    await context
        .read(weatherStateNotifierProvider.notifier)
        .getWeather(cityName);
  }

  void _hapticFeedback() {
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final cityName = watch(cityNameProvider).state;
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
                  // Share.share(snapshot.data!.main.pressure.toString() +
                  //     'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
                },
              ),
              actions: <Widget>[
                /** Builder がないと「Navigatorを含むコンテクストが必要」って怒られる */
                Builder(
                  builder: (context) => IconButton(
                      icon: NeumorphicIcon(
                        Icons.notifications_outlined,
                        size: 25,
                        style: NeumorphicStyle(color: Colors.black87),
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
            body: 
            
                    Container(
                      key: GlobalKey(),
                      child: RefreshIndicator(
                        color: Colors.black,
                        onRefresh: () async {
                  //         await 
                  //         context
                  // .refresh(locationStateNotifierProvider.notifier)
                  // .getMyLocation();
                          
                         return await context
                .refresh(weatherStateNotifierProvider.notifier)
                .getWeather(cityName.toString());
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: <Widget>[
                            Center(
                              child: Container(
                                height: 85,
                                width: double.maxFinite,
                                child: Center(
                                  child: Consumer(
                                    builder: (context, watch, child) {
                                      final weatherState = watch(weatherStateNotifierProvider);
                                      return weatherState.maybeWhen(
                                        initial: (){
                                         Future.delayed(
                                            Duration.zero,
                                            () => submitCityName(
                                              context,
                                              cityName.toString(),
                                            ));
                                            return Container(); 
                                        },
                                        loading: () => Container(
                      child: Center(
                        child: const Text('FETCHING DATA...'),
                      ),
                    ),

                    success: (data) => NeumorphicText(
                      data.main!.pressure.toString(),
                      style: NeumorphicStyle(
                        depth: 20,
                        intensity: 1,
                        color: Colors.black,
                      ),
                      textStyle: NeumorphicTextStyle(
                        fontWeight: FontWeight.w200,
                        fontSize: 75.0,
                      ),),

                                         orElse: () => Container(
                      child: Center(
                        child: const Text('FETCHING DATA...'),
                      ),
                    ),);
                                    },
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
                                        fontWeight: FontWeight.w200,
                                        fontSize: 75.0),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 1.0),
                            Consumer(
                              builder: (context, watch, child){
                                final weatherState = watch(weatherStateNotifierProvider);
                                return weatherState.maybeWhen(
                                  initial: () {
                                    Future.delayed(Duration.zero,
                                    () => submitCityName(
                                      context, cityName.toString(),
                                      ),
                                      );
                                      return Container();

                                  },
                                  loading:() => Container(
                      child: Center(
                        child: const Text('FETCHING DATA...'),
                      ),
                    ),
                    success: (data) => Container(
                              height: 140,
                              alignment: Alignment.center,
                              child: data.weather![0].main
                                          .toString() ==
                                      'Clouds'
                                  ? NeumorphicText(
                                      'Cloudy',
                                      style:
                                          NeumorphicStyle(color: Colors.black),
                                      textStyle: NeumorphicTextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 56.0),
                                    )
                                  : data.weather![0].main
                                              .toString() ==
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
                                      : data.weather![0].main
                                                  .toString() ==
                                              'Clear Sky'
                                          ? NeumorphicText(
                                              'Sunny',
                                              style: NeumorphicStyle(
                                                  color: Colors.black),
                                              textStyle: NeumorphicTextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 56.0),
                                            )
                                          : 
                                                      data.weather![0].main
                                                      .toString() ==
                                                  'Rain'
                                              ? NeumorphicText(
                                                  'Rainy',
                                                  style:
                                                      NeumorphicStyle(
                                                          color: Colors.black),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 56.0))
                                              : NeumorphicText(
                                                  data.weather![0].main
                                                      .toString(),
                                                  style: NeumorphicStyle(
                                                    color: Colors.black,
                                                  ),
                                                  textStyle:
                                                      NeumorphicTextStyle(
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          fontSize: 56.0),
                                                ),
                            ),
                                   orElse: () => Container(
                      child: Center(
                        child: const Text('FETCHING DATA...'),
                      ),
                    ),);
                              },
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  // _pienRate(context),
                                ],
                              ),
                            ),
                            SizedBox(height: 40.0),
                            Consumer(
                              builder: (context, watch, child) {
                                final weatherState = watch(weatherStateNotifierProvider);
                                return weatherState.maybeWhen(initial: () {
                                  Future.delayed(Duration.zero,
                                  () => submitCityName(context, cityName.toString()),);
                                  return Container();
                                },
                                loading: () => Container(
                      child: Center(
                        child: const Text('FETCHING DATA...'),
                      ),
                    ),
                    success: (data) => Center(
                              child: data.main!.pressure! <= 1000
                                  ? Text(
                                      'DEADLY',
                                      style: TextStyle(
                                          color: Colors.redAccent[700],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 80.0),
                                    )
                                  : data.main!.pressure! <= 1008
                                      ? const Text(
                                          'YABAME',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                      : data.main!.pressure! <= 1010
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
                                 orElse: () => Container(
                      child: Center(
                        child: const Text('FETCHING DATA...'),
                      ),
                    ),);
                              },
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              height: 24.0,
                            ),
                            Center(
                              // 5日分の天気データ
                              child: Text(_res2!,
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
                                _res2!,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w100),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),




            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: 
                  FloatingActionButton(
                      backgroundColor: Colors.white,
                      child: const Text('＾ｑ＾'),
                      onPressed: () async {
                        // if (snapshot.hasData)
                          await Navigator.of(context).pushNamed('/timeline');

                        // else {
                        //   _scaffoldKey.currentState!.showSnackBar(SnackBar(
                        //     content: const Text("先に情報を読み込んでね＾ｑ＾"),
                        //     action: SnackBarAction(
                        //       label: '読込',
                        //       onPressed: () => _refresher(),
                        //     ),
                        //   ));
                        // }
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
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
}

  getTimelineView(BuildContext context) {
    return Navigator.of(context).pushNamed('/timeline');
  }

  