import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kiatsu/controller/user_controller.dart';

import 'ad_state.dart';

const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');


final bannerAdProvider =
    StateNotifierProvider.autoDispose<BannerAdController, BannerAdState>(
        (ref) => BannerAdController());

class BannerAdController extends StateNotifier<BannerAdState> {
  BannerAdController() : super(const BannerAdState());

  loadBannerAd() {
    final myBanner = BannerAd(
      adUnitId: _rewardAdUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$ad loaded.');
          state = state.copyWith(
            bannerAd: ad,
            isLoaded: true,
          );
          // state.bannerAd?.adUnitId. =
          //     FullScreenContentCallback(
          //   onAdShowedFullScreenContent: (RewardedAd ad) =>
          //       print('$ad onAdShowedFullScreenContent.'),
          //   onAdDismissedFullScreenContent: (RewardedAd ad) {
          //     print('$ad onAdDismissedFullScreenContent.');
          //     ad.dispose();
          //     state.bannerAd?.dispose();
          //   },
          //   onAdFailedToShowFullScreenContent:
          //       (RewardedAd ad, AdError error) {
          //     print('$ad onAdFailedToShowFullScreenContent: $error');
          //     ad.dispose();
          //     state.bannerAd?.dispose();
          //   },
          //   onAdImpression: (RewardedAd ad) =>
          //       print('$ad impression occurred.'),
          // );
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('RewardedAd failed to load: $error');
          state = state.copyWith(isLoaded: false);
          ad.dispose();
          state.bannerAd?.dispose();
        },
      ),
      size: AdSize.banner,
    );
    if (!state.isLoaded) {
      myBanner.load();
      final AdWidget adWidget = AdWidget(ad: myBanner);
      final Container adContainer = Container(
        alignment: Alignment.center,
        child: adWidget,
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
      );
      return adContainer;
    } else if (state.isLoaded) {
      // myBanner.load();
      final AdWidget adWidget = AdWidget(ad: myBanner);
      final Container adContainer = Container(
        alignment: Alignment.center,
        child: adWidget,
        width: myBanner.size.width.toDouble(),
        height: myBanner.size.height.toDouble(),
      );
      return adContainer;
      // return Container();
    }
  }

  // /// 引数は報酬を付与する処理
  // Future<void> showBannerAd() async {
  //   await

  // }

  String get _rewardAdUnitId {
    
    String adMobUnitIdDev = dotenv.env['ADMOB_BANNER_UNIT_ID_IOS_DEV'].toString();
    String adMobUnitIdProd = dotenv.env['ADMOB_BANNER_UNID_ID_IOS'].toString();
    if (kDebugMode) {
      return adMobUnitIdDev;
    }

    if (Platform.isAndroid && flavor == 'dev') {
      //TODO: Android用のUnitIDの設定を後でやる
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS && flavor == 'dev') {
      return adMobUnitIdDev;
    } 
    // else if (Platform.isAndroid && flavor == 'prod') {
    //   return null;
    // } 
    //TODO: 一旦テストでProd版でもDev版を表示させているがリリース前に戻すのを忘れないこと
    else if (Platform.isIOS && flavor == 'prod') {
      return adMobUnitIdDev;
    }
     else {
      return adMobUnitIdDev;
    }
  }

  @override
  void dispose() {
    if (state.bannerAd != null) {
      state.bannerAd?.dispose();
      state = state.copyWith(bannerAd: null);
    }
    super.dispose();
  }
}
