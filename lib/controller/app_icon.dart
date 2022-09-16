import 'dart:io';

import 'package:flutter/services.dart';

//TODO: 後で小文字enumに変える
enum IconType {Normal, Face, Model}

// ignore: avoid_classes_with_only_static_members
class AppIcon {
  static const MethodChannel platform = MethodChannel('appIconChannel');

  static Future<void> setLauncherIcon(IconType icon) async{
    if (!Platform.isIOS) return null;
    String? iconName;
    switch(icon){
      case IconType.Face:
        iconName = 'Face';
        break;
      case IconType.Model:
        iconName = 'Model';
        break;
      // ignore: no_default_cases
      default:
        iconName = 'Normal';
        break;
    }
    return platform.invokeMethod('changeIcon', iconName);
  }
}
