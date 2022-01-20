import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final progressController = ChangeNotifierProvider(
  (ref) => ProgressController(),
);

class ProgressController extends ChangeNotifier {
  bool _show = false;
  bool get show => _show;

  Future<T> executeWithProgress<T>(Future<T> Function() f) async {
    try {
      _show = true;
      notifyListeners();
      return await f();
    } finally {
      _show = false;
      notifyListeners();
    }
  }
}
