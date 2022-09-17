import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart'; // LINE SDK追加
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:kiatsu/providers/scaffold_messanger_provider.dart'; // cloud_functions追加

final authManagerProvider = ChangeNotifierProvider<AuthManager>(
  (ref) {
    return AuthManager();
  },
);

class AuthManager with ChangeNotifier {
  AuthManager() {
    _firebaseAuth.authStateChanges().listen((user) {
      isLoggedIn = user != null;
      notifyListeners();
    });
  }
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStore = FirebaseFirestore.instance;
  // final _lineSdk = LineSDK.instance; // LINE SDKのインスタンス
  bool isLoggedIn = false;
  // ログイン処理
  // Future<void> signInWithLine() async {
  //   // LINEログインし、LINEのuserIdを取得する
  //   final result = await _lineSdk.login();
  //   final lineUserId = result.userProfile?.userId;

  //   // LINEのuserIdを使って、Cloud Functionsからカスタムトークンを取得する
  //   final callable = FirebaseFunctions.instanceFor(region: 'asia-northeast1')
  //       .httpsCallable('fetchCustomToken');
  //   final response = await callable.call({
  //     'userId': lineUserId,
  //   });

  //   // functionsから取得したカスタムトークンを使用して、Firebaseログイン
  //   await _firebaseAuth.signInWithCustomToken(response.data['customToken']);
  // }

  // ログアウト処理
  Future<void> signOut() async {
    // LINE, Firebase両方でログアウトする
    // await _lineSdk.logout();
    await _firebaseAuth.signOut();
  }

  //アカウント削除
  //TODO: ここにアカウント削除機能を後々統合していきたい。。。
  Future<void> deleteAccount(BuildContext context, WidgetRef ref) async {
    await _firebaseStore
        .collection('users')
        .doc(
          _firebaseAuth.currentUser!.uid,
        )
        .delete();
    await _firebaseAuth.currentUser!.unlink('apple.com').whenComplete(
          () => ref
              .read(scaffoldMessengerProvider)
              .currentState
              ?.showAfterRemoveSnackBar(
                message: 'アカウント情報をすべて削除しました',
              ),
        );
    await _firebaseAuth.currentUser!.delete();
  }
}
