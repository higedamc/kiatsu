import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:purchases_flutter/object_wrappers.dart';

part 'user_state.freezed.dart';

@freezed
class UserState with _$UserState {
  factory UserState({
    User? user,
    CustomerInfo? customerInfo,
  }) = _UserState;
  UserState._();

  late final List<EntitlementInfo> activeEntitlements =
      customerInfo?.entitlements.active.entries.map((e) => e.value).toList() ??
          [];

  // 複数のPackagesのうちいずれか一つでも購入/購読している状態
  late final bool isPaidUser =
      customerInfo?.entitlements.active.isNotEmpty ?? false;

  // Entitlements`NoAds`を購入した状態
  late final bool isNoAdsUser =
      customerInfo?.entitlements.all['pro']?.isActive ?? false;

  // 複数のPackagesのうちいずれか一つでも購入/購読している状態
  late final String? appUserId = customerInfo?.originalAppUserId;
}
