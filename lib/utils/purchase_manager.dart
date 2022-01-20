// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:kiatsu/model/entitlement.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';

// final purchaseManagerProvider = ChangeNotifierProvider<PurchaseManager>(
//   (ref) {
//     return PurchaseManager();
//   },
// );

// class PurchaseManager with ChangeNotifier {
//   Entitlement _entitlement = Entitlement.free;
//   Entitlement get entitlement => _entitlement;

//   Future purchaseManager() async {
//     // _firebaseAuth.authStateChanges().listen((user) {
//     //   isLoggedIn = user != null;
//     Purchases.addPurchaserInfoUpdateListener((entitlement) async {
//       updatePurchaseStatus();
//       isPurchased = entitlement != Entitlement.free;
//       notifyListeners();
//     });
//   }

//   // final _firebaseAuth = FirebaseAuth.instance;
//   // final _lineSdk = LineSDK.instance; // LINE SDKのインスタンス
//   bool isPurchased = false;
//   // ログイン処理
//   // Future<void> signInWithLine() async {
//   //   // LINEログインし、LINEのuserIdを取得する
//   //   final result = await _lineSdk.login();
//   //   final lineUserId = result.userProfile?.userId;

//   //   // LINEのuserIdを使って、Cloud Functionsからカスタムトークンを取得する
//   //   final callable = FirebaseFunctions.instanceFor(region: 'asia-northeast1')
//   //       .httpsCallable('fetchCustomToken');
//   //   final response = await callable.call({
//   //     'userId': lineUserId,
//   //   });

//   //   // functionsから取得したカスタムトークンを使用して、Firebaseログイン
//   //   await _firebaseAuth.signInWithCustomToken(response.data['customToken']);
//   // }

//   Future updatePurchaseStatus() async {
//     final purchaserInfo = await Purchases.getPurchaserInfo();
//     print(purchaserInfo);
//     final entitlements = purchaserInfo.entitlements.active.values.toList();
//     _entitlement = entitlements.isEmpty ? Entitlement.free : Entitlement.pro;

//     // notifyListeners();

//     // ログアウト処理
//     Future<void> signOut() async {}
//   }
// }
