import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class Clock extends StateNotifier<DateTime> {
  // 現時時刻の初期化
  Clock() : super(DateTime.now()) {
    //発火タイマーの設定
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      //現在時刻でステートの更新
      state = DateTime.now();
    });
  }

  late final Timer _timer;

  // 4. cancel the timer when finished
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}