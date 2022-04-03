import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kiatsu/controller/user_controller.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:kiatsu/widget/ad_widget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riv;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:onboarding_overlay/onboarding_overlay.dart';

import 'custom_dialog_box.dart';

/**
 * ! 破壊的変更の追加。
 * 詳細は => https://github.com/Meshkat-Shadik/WeatherApp
 */

// TODO: #114 ダッシュボード機能の実装

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final currentUser = firebaseAuth.currentUser;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final CollectionReference users = firebaseStore.collection('users');

//TODO: #130 コンストラクターにkeyを渡す
class HomePage extends riv.ConsumerWidget {
  const HomePage({required this.cityName, required this.res2, required Key key})
      : super(key: key);

  final String cityName;

  final String res2;

  // final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> submitCityName(
      BuildContext context, String? cityName, riv.WidgetRef ref) async {
    await ref.read(weatherStateNotifierProvider.notifier).getWeather(cityName!);
  }

  // void refreshPurchaser(
  //     BuildContext context, riv.WidgetRef ref) async {
  //   await ref.read(purchaseManagerProvider).purchaseManager();
  // }

  // final List<FocusNode> overlayKeys = <FocusNode>[
  //   FocusNode(),
  //   FocusNode(),
  //   FocusNode(),
  // ];

  // final List<OnboardingSteps> steps = [OnboardingStep(
  //   focusNode: _focusNodes != null ? _focusNodes[0] : null,
  //   title: "Hi",
  //   titleTextStyle: Theme.of(context).textTheme.headline5.copyWith(
  //       color: Theme.of(context).canvasColor,
  //       ),
  //   bodyText:
  //       '''Check this out''',
  //   bodyTextStyle: Theme.of(context).textTheme.subtitle1.copyWith(
  //       color: Theme.of(context).canvasColor,
  //       ),
  //   hasLabelBox: false,
  //   fullscreen: true,
  //   overlayColor: Theme.of(context).primaryColorDark.withOpacity(0.8),
  //   hasArrow: false,
  //   ),];

  Future<String> fromAtNow(DateTime date) async {
    // final DateTime currentTime = ref.watch(clockProvider);
    final difference = DateTime.now().difference(date);
    // final Duration difference =
    //     DateTime.now().difference(currentTime);
    final sec = difference.inSeconds;

    if (sec >= 60 * 60 * 24) {
      return '最終更新 - ${difference.inDays.toString()}日前';
    } else if (sec >= 60 * 60) {
      return '最終更新 - ${difference.inHours.toString()}時間前';
    } else if (sec >= 60) {
      return '最終更新 - ${difference.inMinutes.toString()}分前';
    } else {
      return '最終更新 - $sec秒前';
    }
  }

  //TODO: Riverpod + Freezed化する
  Future<bool> handlePermission() async {
    final statuses = await [
      Permission.location,
      // Permission.locationAlways,
      Permission.locationWhenInUse,
    ].request();
    if (kDebugMode) {
      print(statuses);
    }
    if (statuses[Permission.location] == PermissionStatus.granted &&
        // statuses[Permission.locationAlways] == PermissionStatus.granted &&
        statuses[Permission.locationWhenInUse] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }

  //TODO: Riverpod + Freezed化する
  Future<void> getLocationPermissions() async {
    // final result = handlePermission();
    final result1 = await Permission.location.isDenied;
    final result2 = await Permission.locationAlways.isDenied;
    final result3 = await Permission.locationWhenInUse.isDenied;
    final result4 = await Permission.location.isLimited;
    final result5 = await Permission.location.isRestricted;
    final result6 = await Permission.location.isPermanentlyDenied;
    final result7 = await Permission.locationAlways.isLimited;
    final result8 = await Permission.locationAlways.isRestricted;
    final result9 = await Permission.locationAlways.isPermanentlyDenied;
    final result10 = await Permission.locationWhenInUse.isLimited;
    final result11 = await Permission.locationWhenInUse.isRestricted;
    final result12 = await Permission.locationWhenInUse.isPermanentlyDenied;

    await (result1 == true ||
            result4 == true ||
            result5 == true ||
            result6 == true)
        ? Permission.location.request()
        : Permission.location.isGranted;
    await (result2 == true ||
            result7 == true ||
            result8 == true ||
            result9 == true)
        ? Permission.locationAlways.request()
        : Permission.locationAlways.isGranted;
    await (result3 == true ||
            result10 == true ||
            result11 == true ||
            result12 == true)
        ? Permission.locationWhenInUse.request()
        : Permission.locationWhenInUse.isGranted;
  }

  @override
  Widget build(BuildContext context, riv.WidgetRef ref) {
    // final currentTime = ref.watch(clockProvider);
    final size = MediaQuery.of(context).size;
    // print(size);
    // final width = size.width;
    final height = size.height;
    // final currentWidth = width * 1 / 2;
    final currentHeight = height * 1 / 2;
    // final permission = ref.read(permissionGetter);
    // Future<void> waiter(ref) async {
    //   // return Future.delayed(Duration.zero, () async {
    //   //   // PurchaseApi.init();
    //   //   await Purchases.setup(Coins._apiKey,
    //   //       appUserId: currentUser?.uid.toString());
    //   // });
    //   final testt = ref.watch(authManagerProvider);

    //   if (testt.isLoggedIn) {
    //     await Purchases.setup(dotenv.env['REVENUECAT_SECRET_KEY'].toString(),
    //         appUserId: currentUser?.uid.toString());
    //   }
    //   // await Purchases.setup(
    //   //   Coins._apiKey,
    //   //   appUserId: currentUser?.uid.toString(),
    //   // );
    // }

    // final entitlement = Provider.of<RevenueCat>(context).entitlement;
    // final deviceHeight = MediaQuery.of(context).size.height;
    // final entitlement = ref.watch(revenueCatProvider).entitlement;
    // final entitlement = ref.watch(purchaseManagerProvider).entitlement;
    final cityName = ref.watch(cityNameProvider);
    // final _purchaser = ref.watch(purchaseManagerProvider);
    // final isLoaded =
    //     ref.watch(bannerAdProvider.select((value) => value.isLoaded));
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
                // waiter(ref);
                // Future.delayed(Duration.zero,
                //     () => refreshPurchaser(context, ref));
                Future.delayed(Duration.zero,
                    () => submitCityName(context, cityName, ref));

                return Container();
              },
              loading: () => Container(),
              success: (data) => IconButton(
                    icon: const Icon(Icons.share_outlined),
                    onPressed: () {
                      final pressure = data.main?.pressure.toString();
                      Share.share(
                        '$pressure hPa is 低気圧しんどいぴえん🥺️ #kiatsu_app',
                      ).toString();
                    },
                  ),
              orElse: () {
                return Container();
              });
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
                  // showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return CustomDialogBox(
                  //         title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                  //         descriptions: 'この機能はまだ未実装です♡',
                  //         text: '押',
                  //         key: UniqueKey(),
                  //       );
                  //     });
                  await Navigator.pushNamed(context, '/notify');
                }),
          )
        ],
      ),
      body: RefreshIndicator(
        color: Colors.black,
        onRefresh: () async {
          // ref.refresh(clockProvider.notifier);
          // final currentTime = DateTime.now();

          // ref.read(purchaseManagerProvider);
          await ref
              .refresh(weatherStateNotifierProvider.notifier)
              .getWeather(cityName);
          final updatedAt = DateTime.now();
          await fromAtNow(updatedAt);
          // (context as Element).markNeedsBuild();

          // '最終更新 - ' + timeago.format(updatedAt, locale: 'ja');

          // final timeFormatted = DateFormat.Hms().format(bitch);
          // '最終更新 - $timeFormatted';
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
                                    cityName,
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
                            fontSize: 75,
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
                        fontWeight: FontWeight.w200, fontSize: 75),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 1),
            Consumer(
              builder: (context, watch, child) {
                final weatherState = ref.watch(weatherStateNotifierProvider);
                return weatherState.maybeWhen(
                  initial: () {
                    Future.delayed(
                      Duration.zero,
                      () => submitCityName(
                        context,
                        cityName,
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
                                    fontWeight: FontWeight.w200, fontSize: 56),
                              )
                            : data.weather![0].main.toString() == 'Clear Sky'
                                ? NeumorphicText(
                                    'Sunny',
                                    style: const NeumorphicStyle(
                                        color: Colors.black),
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
                                            fontSize: 56))
                                    : NeumorphicText(
                                        data.weather![0].main.toString(),
                                        style: const NeumorphicStyle(
                                          color: Colors.black,
                                        ),
                                        textStyle: NeumorphicTextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 56),
                                      ),
                  ),
                  orElse: () => Container(),
                  //   const Center(
                  //     child: Text('FETCHING DATA...'),
                  //   ),
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
                  loading: () {
                    return const Center(
                      child: Text('FETCHING DATA...'),
                    );
                    // Future.delayed(
                    //   Duration.zero,
                    //   () async {
                    //     final fuckMe = await handlePermission();
                    //     fuckMe == true ? const Center(
                    //       child: Text('FETCHING DATA...')
                    //     ) : const Center(
                    //       child: Text('位置情報を許可してください')
                    //     );
                    //   },
                    // );
                    // return Container();
                  },
                  success: (data) => Center(
                    //TODO: #146 ユーザーに表示する合わせてヤバさレベルを変えるようにする
                    child: data.main!.pressure! <= 1000
                        ? Text(
                            'DEADLY',
                            style: TextStyle(
                                color: Colors.redAccent[700],
                                fontWeight: FontWeight.w500,
                                fontSize: 80.0),
                          )
                        : data.main!.pressure! <= 1005
                            ? Text(
                                'KIKEN',
                                style: TextStyle(
                                    color: Colors.redAccent[400],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 60.0),
                              )
                            : data.main!.pressure! <= 1008
                                ? const Text(
                                    'YABAI',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  )
                                : data.main!.pressure! <= 1010
                                    ? const Text(
                                        'YABAME',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w200,
                                        ),
                                      )
                                    : const Center(
                                        child: Text(
                                        'KAITEKI',
                                        style: TextStyle(
                                          fontSize: 28.5,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal,
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
              child: Text(res2,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w100)),
            ),
            Consumer(
              builder: (BuildContext context, value, Widget? child) {
                final now = DateTime.now();
                final currentTime = ref.watch(clockProvider);
                // final List<DateTime> dates = [
                //   now.add(Duration(seconds: currentTime.second) * -1),
                //    now.add(Duration(minutes: currentTime.minute) * -1),
                // ];
                final date =
                    now.add(Duration(seconds: currentTime.second) * -5);
                // final secondsString = DateFormat.s().format(currentTime);
                // final secondsInt = int.parse(secondsString);
                // final minutesString = DateFormat.m().format(currentTime);
                // final minutesInt = int.parse(minutesString);
                String fromAtNow(DateTime date) {
                  // final DateTime currentTime = ref.watch(clockProvider);
                  final difference = DateTime.now().difference(date);
                  // final Duration difference =
                  //     DateTime.now().difference(currentTime);
                  final sec = difference.inSeconds;

                  if (sec >= 60 * 60 * 24) {
                    return '最終更新 - ${difference.inDays.toString()}日前';
                  } else if (sec >= 60 * 60) {
                    return '最終更新 - ${difference.inHours.toString()}時間前';
                  } else if (sec >= 60) {
                    return '最終更新 - ${difference.inMinutes.toString()}分前';
                  } else {
                    return '最終更新 - $sec秒前';
                  }
                }
                // final difference = dates.map((date) => Text(fromAtNow(date))).toList();

                // final updatedAt = DateTime.now();
                return Center(
                  child: Text(
                    //日本語的に違和感があったので、60秒未満前の場合'前'を表示しないようにした笑

                    // timeago.format(
                    //           currentTime,
                    //           locale: 'ja',
                    //           allowFromNow: false,
                    //         ) ==
                    //         '60秒未満前'
                    // secondsInt < 60
                    //     ? '最終更新 - ' +
                    //         timeago.format(
                    //           currentTime,
                    //           locale: 'ja',
                    //           allowFromNow: false,
                    //         ) -
                    //         '前'
                    //     : '最終更新 - ' +
                    // //         minutesString + '分前',
                    // secondsInt <= 60
                    //     ? '最終更新 - $secondsInt 秒前'
                    //     : secondsInt >= 60
                    //         ? '最終更新 - ' + minutesInt.toString() + ' 分前'
                    //         : '最終更新 - なう',
                    // currentTime.toString(),
                    fromAtNow(date),
                    // style: const NeumorphicStyle(
                    //   // height: 1, // 10だとちょうど下すれすれで良い感じ
                    //   color: Colors.black,
                    // ),
                    // textStyle: NeumorphicTextStyle(),
                  ),
                );
              },
            ),
            Center(
              child: Text(
                res2,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w100),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            Consumer(
              builder: (BuildContext context, value, Widget? child) {
                final isPaid =
                    ref.watch(userProvider.select((s) => s.isPaidUser));
                // final isLoaded = ref.watch(
                //   bannerAdProvider.select((s) => s.isLoaded),
                // );

                return Center(
                  child: SizedBox(
                    height: currentHeight * 0.6,
                    child: 
                    !isPaid
                    //     ? bannerNotifier.loadBannerAd()
                    //     :
                      ?
                        const AdBanner() : Container(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          child: const Text('＾ｑ＾'),
          onPressed: () async {
            // try {
            //   final result = await getLocationPermissions();
            // await Navigator.of(context).pushNamed('/timeline');
            // } on PlatformException catch (e) {
            //   print(e);
            //   if (e.message == 'ERROR_ALREADY_REQUESTING_PERMISSIONS' ) {
            //     throw Error();
            //   }
            // }
            try {
              final result = await handlePermission();
              if (result == true) {
                if (kDebugMode) {
                  print('permission granted');
                }
                await Navigator.of(context).pushNamed('/timeline');
              } else {
                if (kDebugMode) {
                  print('permission denied');
                }
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('このアプリは位置情報の許可が必須です'),
                  action: SnackBarAction(
                      label: '許可',
                      onPressed: () async {
                        // await getLocationPermissions();
                        await Geolocator.openLocationSettings();
                      }),
                ));
              }
            } on PlatformException catch (e) {
              e.code == 'ERROR_ALREADY_REQUESTING_PERMISSIONS'
                  ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.message.toString()),
                      action:
                          SnackBarAction(label: 'OK', onPressed: () async {}),
                    ))
                  : print(e);
              // await Permission.location.request();
            }
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
                  Icons.bar_chart_outlined,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Navigator.of(context).pushNamed('/timeline');
                  // 未実装ダイアログ
                  showDialog<Widget>(
                      context: context,
                      builder: (BuildContext context) {
                        return CustomDialogBox(
                          title: '',
                          descriptions: 'この機能は近日公開予定です♡',
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

// Widget buildAdmob() {
//   //TODO: #125 dispose()を呼び出す処理を書く
//   // 参考URL: https://uedive.net/2021/5410/flutter2-gad/
//   //TODO: #128 端末のサイズに合わせて自動で広告のサイズを変更する処理を書く
//   String getTestBannerUnitID() {
//     String testBannerUnitId = '';
//     if (Platform.isIOS) {
//       testBannerUnitId = 'ca-app-pub-3940256099942544/2934735716';
//     } else if (Platform.isAndroid) {
//       testBannerUnitId = 'ca-app-pub-3940256099942544/6300978111';
//     }
//     return testBannerUnitId;
//   }

//   final BannerAd myBanner = BannerAd(
//     adUnitId: getTestBannerUnitID(),
//     size: AdSize.banner,
//     request: const AdRequest(),
//     listener:
//         // BannerAdListener(),
//         BannerAdListener(
//       // 広告が正常にロードされたときに呼ばれます。
//       onAdLoaded: (Ad ad) => print('バナー広告がロードされました。'),
//       // 広告のロードが失敗した際に呼ばれます。
//       onAdFailedToLoad: (Ad ad, LoadAdError error) {
//         print('バナー広告のロードに失敗しました。: $error');
//       },
//       // 広告が開かれたときに呼ばれます。
//       onAdOpened: (Ad ad) => print('バナー広告が開かれました。'),
//       // 広告が閉じられたときに呼ばれます。
//       onAdClosed: (Ad ad) => print('バナー広告が閉じられました。'),
//       // ユーザーがアプリを閉じるときに呼ばれます。
//       // onApplicationExit: (Ad ad) => print('ユーザーがアプリを離れました。'),
//     ),
//   );
//   myBanner.load();
//   final AdWidget adWidget = AdWidget(ad: myBanner);
//   final Container adContainer = Container(
//     alignment: Alignment.center,
//     child: adWidget,
//     width: myBanner.size.width.toDouble(),
//     height: myBanner.size.height.toDouble(),
//   );
//   // return entitlement == Entitlement.pro ? Container() : adContainer;
//   return adContainer;
// }

Future<Object?> getTimelineView(BuildContext context) {
  return Navigator.of(context).pushNamed('/timeline2');
}
