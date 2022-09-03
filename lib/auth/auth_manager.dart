import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';  // LINE SDK追加
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // cloud_functions追加

final authManagerProvider = ChangeNotifierProvider<AuthManager>(
  (ref) {
    return AuthManager();
  },
);

class AuthManager with ChangeNotifier {
  AuthManager() {
    _firebaseAuth.authStateChanges().listen((user) {
      if(user !=null) {
        setAuth(user.uid);
      }
      notifyListeners();
    });
  }
  final _firebaseAuth = FirebaseAuth.instance;
  final _supabaseAuth = Supabase.instance;
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
    await _supabaseAuth.client.auth.signOut();
  }
  
  void setAuth(String uid) {
    const secret = 'wSaQ++TBdVQ2e6tA895SWQuMsOefEt2dbHsNlTu8c3/GLdsTo5XiKdHKPxsRqqtjgVdLV3AuYnFKyc7d409eiQ==';
    try {
      final jwt = JWT(
        {
          'uid': uid,
          'role': 'authenticated',
        }
      );
      final token = jwt.sign(
        SecretKey(secret),
        expiresIn: const Duration(hours: 1),
      );
      _supabaseAuth.client.auth.setAuth(token);
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
