import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyStopWatch extends StateNotifier<DateTime> {
  // 現時時刻の初期化
  MyStopWatch() : super(DateTime.now()) {
    // 1秒ごとに現時時刻を更新
    stopWatch = Stopwatch()..start();
    state = DateTime.now();
  }

  late final Stopwatch stopWatch;


  @override
  void dispose() {
    stopWatch.stop();
    super.dispose();
  }
}
