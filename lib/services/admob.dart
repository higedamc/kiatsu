import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as dotenv;

class AdMobService {
  String? getBannerAdUnitId() {
    // iOSとAndroidで広告ユニットIDを分岐させる
    if (Platform.isAndroid) {
      // Androidの広告ユニットID
      return dotenv.dotenv.env['ADMOB_UNIT_ID_ANDROID_TEST']; 
    } else if (Platform.isIOS) {
      // iOSの広告ユニットID
      return dotenv.dotenv.env['ADMOB_UNIT_ID_IOS_TEST']; 
    }
    return null;
  }

  // 表示するバナー広告の高さを計算
  double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.06).toDouble();

    return percent; 
  }
}