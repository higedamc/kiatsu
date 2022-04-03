import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//参考URL: https://zenn.dev/8yabusa/scraps/36fe02c710850c


const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

String get adBannerUnitId {
    final adMobUnitIdIOS = dotenv.env['ADMOB_BANNER_UNIT_ID_IOS'].toString();
    final adMobUnitIdAndroid =
        dotenv.env['ADMOB_BANNER_UNIT_ID_ANDROID'].toString();

    if (flavor == 'dev') {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    } else if (flavor == 'prod') {
      return Platform.isAndroid ? adMobUnitIdAndroid : adMobUnitIdIOS;
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
  }


BannerAd newAdBanner(AdSize size) => BannerAd(
      adUnitId: adBannerUnitId,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => log('Ad loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          log('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => log('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => log('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => log('Ad impression.'),
      ),
    );

class AdBanner extends HookConsumerWidget {
  const AdBanner({this.size = AdSize.banner})
   : super();

  final AdSize size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final adBanner = useMemoized(() => newAdBanner(size)..load());
    useEffect(() => adBanner.dispose, []);
    return Container(
      alignment: Alignment.center,
      width: adBanner.size.width.toDouble(),
      height: adBanner.size.height.toDouble(),
      child: AdWidget(ad: adBanner),
    );
  }
}
