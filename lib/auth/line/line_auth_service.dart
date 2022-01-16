import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

final lineAuthServiceProvider = Provider<LineAuthService>((ref) {
  return LineAuthService();
});

class LineAuthService {
  LineAuthService() {
    Future<void>(() async {
      try {
        final _user = await _lineSdk.getProfile();
        _authStateController.sink.add(_user.userId);
        // _authStateController.sink.add(_user.pictureUrl);
      } catch (e) {
        // 未ログイン時はgetProfile()がエラーになる
        print('Not Logged In');
      }
    });
  }
  final _lineSdk = LineSDK.instance;
  final _authStateController = StreamController<String?>();
  // ログインしていれば、userIdを返す
  Stream<String?> get authStateChange => _authStateController.stream;

  Future<void> signIn() async {
    await _lineSdk.login();
    final _user = await _lineSdk.getProfile();
    _authStateController.sink.add(_user.userId);
    // _authStateController.sink.add(_user.pictureUrl);
  }

  Future<void> signOut() async {
    await _lineSdk.logout();
    _authStateController.sink.add(null);
  }
}