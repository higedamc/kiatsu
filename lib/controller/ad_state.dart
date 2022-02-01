import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'ad_state.freezed.dart';

@freezed
class BannerAdState with _$BannerAdState {
  const factory BannerAdState({
    Ad? bannerAd,
    @Default(false) bool isLoaded,
  }) = _BannerAdState;
}