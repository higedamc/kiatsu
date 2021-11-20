import 'dart:async';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/providers/revenuecat.dart';
import 'package:kiatsu/utils/providers.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'custom_dialog_box.dart';

/**
 * ! 破壊的変更の追加。
 * 詳細は => https://github.com/Meshkat-Shadik/WeatherApp
 */

// TODO: #107 StoreKitTestCertificate.cerを追加
// TODO: #114 ダッシュボード機能の実装

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final CollectionReference users = firebaseStore.collection('users');
final currentUser = firebaseAuth.currentUser;

class HomePage extends riv.ConsumerWidget {
  late final String? cityName;
  final DateTime updatedAt = DateTime.now();

  final String? _res2 = '';
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  void submitCityName(
      BuildContext context, String cityName, riv.WidgetRef ref) async {
    await ref.read(weatherStateNotifierProvider.notifier).getWeather(cityName);
  }

  @override
  Widget build(BuildContext context, riv.WidgetRef ref) {
    final entitlement = Provider.of<RevenueCat>(context).entitlement;
    final cityName = ref.watch(cityNameProvider);
    return Scaffold(
      // key: _scaffoldKey,
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: const Text(
          "",
        ),
        leading: Consumer(builder: (context, watch, child) {
          final weatherState = ref.watch(weatherStateNotifierProvider);
          return weatherState.maybeWhen(
              initial: () {
                Future.delayed(Duration.zero,
                    () => submitCityName(context, cityName, ref));
                return Container();
              },
              loading: () => Container(),
              success: (data) => IconButton(
                    icon: Icon(Icons.share_outlined),
                    onPressed: () {
                      Share.share(data.main!.pressure.toString() +
                          'hPa is 低気圧しんどいぴえん🥺️ #thekiatsu');
                    },
                  ),
              orElse: () => Container());
        }),
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
      body: Container(
        key: GlobalKey(),
        child: RefreshIndicator(
          color: Colors.black,
          onRefresh: () async {
            return await ref
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
                        final weatherState =
                            ref.watch(weatherStateNotifierProvider);
                        return weatherState.maybeWhen(
                          initial: () {
                            Future.delayed(
                                Duration.zero,
                                () => submitCityName(
                                      context,
                                      cityName.toString(),
                                      ref,
                                    ));
                            return Container();
                          },
                          loading: () => Container(),
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
                            ),
                          ),
                          orElse: () => Container(),
                        );
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
                          fontWeight: FontWeight.w200, fontSize: 75.0),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.0),
              Consumer(
                builder: (context, watch, child) {
                  final weatherState = ref.watch(weatherStateNotifierProvider);
                  return weatherState.maybeWhen(
                    initial: () {
                      Future.delayed(
                        Duration.zero,
                        () => submitCityName(
                          context,
                          cityName.toString(),
                          ref,
                        ),
                      );
                      return Container();
                    },
                    loading: () => Container(
                        // child: Center(
                        //   child: const Text('FETCHING DATA...'),
                        // ),
                        ),
                    success: (data) => Container(
                      height: 140,
                      alignment: Alignment.center,
                      child: data.weather![0].main.toString() == 'Clouds'
                          ? NeumorphicText(
                              'Cloudy',
                              style: NeumorphicStyle(color: Colors.black),
                              textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.w200, fontSize: 56.0),
                            )
                          : data.weather![0].main.toString() == 'Clear'
                              ? NeumorphicText(
                                  'Clear',
                                  style: NeumorphicStyle(
                                    color: Colors.black,
                                  ),
                                  textStyle: NeumorphicTextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 56.0),
                                )
                              : data.weather![0].main.toString() == 'Clear Sky'
                                  ? NeumorphicText(
                                      'Sunny',
                                      style:
                                          NeumorphicStyle(color: Colors.black),
                                      textStyle: NeumorphicTextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 56.0),
                                    )
                                  : data.weather![0].main.toString() == 'Rain'
                                      ? NeumorphicText('Rainy',
                                          style: NeumorphicStyle(
                                              color: Colors.black),
                                          textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 56.0))
                                      : NeumorphicText(
                                          data.weather![0].main.toString(),
                                          style: NeumorphicStyle(
                                            color: Colors.black,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 56.0),
                                        ),
                    ),
                    orElse: () => Container(
                      child: Center(
                        child: const Text('FETCHING DATA...'),
                      ),
                    ),
                  );
                },
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
              Consumer(
                builder: (context, watch, child) {
                  final weatherState = ref.watch(weatherStateNotifierProvider);
                  return weatherState.maybeWhen(
                    initial: () {
                      Future.delayed(
                        Duration.zero,
                        () => submitCityName(context, cityName.toString(), ref),
                      );
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
                    ),
                  );
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
                        color: Colors.black, fontWeight: FontWeight.w100)),
              ),
              Center(
                child: NeumorphicText(
                  "最終更新 - " +
                      timeago.format(updatedAt, locale: 'ja').toString(),
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
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ),
              SizedBox(
                height: 70.0,
              ),
              buildAdmob(entitlement),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Text('＾ｑ＾'),
          onPressed: () async {
            // if (snapshot.hasData)
            await Navigator.of(context).pushNamed('/timeline');
          }),
      bottomNavigationBar: Container(
        child: BottomAppBar(
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
      ),
    );
  }
}

Widget buildAdmob(Entitlement entitlement) {
  //TODO: #125 dispose()を呼び出す処理を書く
  final BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  myBanner.load();
  final AdWidget adWidget = AdWidget(ad: myBanner);
  final Container adContainer = Container(
    alignment: Alignment.center,
    child: adWidget,
    width: myBanner.size.width.toDouble(),
    height: myBanner.size.height.toDouble(),
  );
  switch (entitlement) {
    case Entitlement.pro:
      return Container();
    case Entitlement.free:
      return Center(
        child: adContainer,
      );
  }
}

getTimelineView(BuildContext context) {
  return Navigator.of(context).pushNamed('/timeline');
}
