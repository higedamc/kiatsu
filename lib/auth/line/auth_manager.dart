import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/auth/line/line_auth_service.dart';

final authManagerProvider = ChangeNotifierProvider<AuthManager>(
  (ref) {
    return AuthManager(
      ref.watch(lineAuthServiceProvider),
    );
  },
);

class AuthManager with ChangeNotifier {
  AuthManager(this._lineAuthService) {
    // Firebase Authのログイン状態を管理
    _firebaseAuth.authStateChanges().listen((user) {
      isLoggedIn = user != null;
      currentUserId = user?.uid;
      notifyListeners();
    });

    // LINE SDKのログイン状態を管理
    _lineAuthService.authStateChange.listen((userId) {
      isLoggedIn = userId != null;
      currentUserId = userId;
      // currentPictureUrl = _lineAuthService..pictureUrl;
      notifyListeners();
    });
  }
  final LineAuthService _lineAuthService;

  final _firebaseAuth = FirebaseAuth.instance;
  String? currentUserId;
  bool isLoggedIn = false;

  Future<void> signInWithFirebaseAuth() async {
    // Firebase対応のログイン処理
    final result = await _firebaseAuth.signInAnonymously();
    final displayName = result.user?.displayName;
    // final updateDisplayName = displayName != null
    //     ? null
    //     : 
        await result.user?.updateDisplayName(currentUserId);
        print(displayName);
        print(currentUserId);
  }

  // LINEログイン
  Future<void> signInWithLine() async => await _lineAuthService.signIn();

  // ログアウト処理
  Future<void> signOut() async {
    // Firebase, LINEどちらも、未ログイン状態でsignOut()しても問題なし
    await _firebaseAuth.signOut();
    await _lineAuthService.signOut();
  }
}