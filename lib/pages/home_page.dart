import 'dart:async';
import 'dart:io';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kiatsu/model/entitlement.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:kiatsu/providers/revenuecat.dart';
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

//TODO: #130 コンストラクターにkeyを渡す
class HomePage extends riv.ConsumerWidget { 
  final String? cityName;
  final DateTime updatedAt = DateTime.now();

  final String? _res2 = '';

  HomePage({this.cityName, Key? key}) : super(key: key);
  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  void submitCityName(
      BuildContext context, String? cityName, riv.WidgetRef ref) async {
    await ref.read(weatherStateNotifierProvider.notifier).getWeather(cityName!);
  }

  @override
  Widget build(BuildContext context, riv.WidgetRef ref) {
    final entitlement = Provider.of<RevenueCat>(context).entitlement;
    final double deviceHeight = MediaQuery.of(context).size.height;
    // final entitlement = ref.watch(revenueCatProvider).entitlement;
    final cityName = ref.watch(cityNameProvider);
    return Scaffold(
      // key: _scaffoldKey,
      appBar: NeumorphicAppBar(
        centerTitle: true,
        title: const Text(
          '',
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
                    icon: const Icon(Icons.share_outlined),
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
                  style: const NeumorphicStyle(color: Colors.black87),
                ),
                onPressed: () async {
                  // 未実装ダイアログ
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                          descriptions: 'この機能はまだ未実装です♡',
                          text: '押',
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
                child: SizedBox(
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
                            style: const NeumorphicStyle(
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
                child: SizedBox(
                  height: 70,
                  width: double.maxFinite,
                  child: Center(
                    child: NeumorphicText(
                      'hPa',
                      style: const NeumorphicStyle(
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
              const SizedBox(height: 1.0),
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
                              style: const NeumorphicStyle(color: Colors.black),
                              textStyle: NeumorphicTextStyle(
                                  fontWeight: FontWeight.w200, fontSize: 56.0),
                            )
                          : data.weather![0].main.toString() == 'Clear'
                              ? NeumorphicText(
                                  'Clear',
                                  style: const NeumorphicStyle(
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
                                          const NeumorphicStyle(color: Colors.black),
                                      textStyle: NeumorphicTextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 56.0),
                                    )
                                  : data.weather![0].main.toString() == 'Rain'
                                      ? NeumorphicText('Rainy',
                                          style: const NeumorphicStyle(
                                              color: Colors.black),
                                          textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 56.0))
                                      : NeumorphicText(
                                          data.weather![0].main.toString(),
                                          style: const NeumorphicStyle(
                                            color: Colors.black,
                                          ),
                                          textStyle: NeumorphicTextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 56.0),
                                        ),
                    ),
                    orElse: () => const Center(
                      child: Text('FETCHING DATA...'),
                    ),
                  );
                },
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const <Widget>[
                    // _pienRate(context),
                  ],
                ),
              ),
              const SizedBox(height: 40.0),
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
                    loading: () => const Center(
                      child: Text('FETCHING DATA...'),
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
                                      'CHOI-YABAME',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Center(
                                      child: Text(
                                      '',
                                      style: TextStyle(
                                        fontSize: 28.5,
                                        color: Colors.black,
                                      ),
                                    )),
                    ),
                    orElse: () => const Center(
                      child: Text('FETCHING DATA...'),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              const SizedBox(
                height: 24.0,
              ),
              Center(
                // 5日分の天気データ
                child: Text(_res2!,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w100)),
              ),
              Center(
                child: NeumorphicText(
                  '最終更新 - ' +
                      timeago.format(updatedAt, locale: 'ja').toString(),
                  style: const NeumorphicStyle(
                    // height: 1, // 10だとちょうど下すれすれで良い感じ
                    color: Colors.black,
                  ),
                  textStyle: NeumorphicTextStyle(),
                ),
              ),
              Center(
                child: Text(
                  _res2!,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w100),
                ),
              ),
              const SizedBox(
                height: 70.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        height: deviceHeight * 0.34,
                        child: buildAdmob(entitlement)),
                    ],
                  ),
                ),
              ),
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        notchMargin: 6.0,
        shape: const AutomaticNotchedShape(
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
                icon: const Icon(
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
                          title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                          descriptions: 'この機能はまだ未実装です♡',
                          text: '押',
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

Widget buildAdmob(Entitlement entitlement) {
  //TODO: #125 dispose()を呼び出す処理を書く
  // 参考URL: https://uedive.net/2021/5410/flutter2-gad/
  //TODO: #128 端末のサイズに合わせて自動で広告のサイズを変更する処理を書く
  String getTestBannerUnitID() {
    String testBannerUnitId = '';
    if (Platform.isIOS) {
      testBannerUnitId = 'ca-app-pub-3940256099942544/2934735716';
    } else if (Platform.isAndroid) {
      testBannerUnitId = 'ca-app-pub-3940256099942544/6300978111';
    }
    return testBannerUnitId;
  }
  final BannerAd myBanner = BannerAd(
    adUnitId: getTestBannerUnitID(),
    size: AdSize.banner,
    request: const AdRequest(),
    listener: 
    // BannerAdListener(),
    BannerAdListener(
    // 広告が正常にロードされたときに呼ばれます。
    onAdLoaded: (Ad ad) => print('バナー広告がロードされました。'),
    // 広告のロードが失敗した際に呼ばれます。
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      print('バナー広告のロードに失敗しました。: $error');
    },
    // 広告が開かれたときに呼ばれます。
    onAdOpened: (Ad ad) => print('バナー広告が開かれました。'),
    // 広告が閉じられたときに呼ばれます。
    onAdClosed: (Ad ad) => print('バナー広告が閉じられました。'),
    // ユーザーがアプリを閉じるときに呼ばれます。
    // onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
  ),
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
