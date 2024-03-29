/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/face.png
  AssetGenImage get face => const AssetGenImage('assets/images/face.png');

  /// File path: assets/images/kiatsu_logo_invert.jpg
  AssetGenImage get kiatsuLogoInvert =>
      const AssetGenImage('assets/images/kiatsu_logo_invert.jpg');

  /// File path: assets/images/line.png
  AssetGenImage get line => const AssetGenImage('assets/images/line.png');

  /// File path: assets/images/model.jpg
  AssetGenImage get model => const AssetGenImage('assets/images/model.jpg');
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  /// File path: assets/json/arrow_down_bounce.json
  String get arrowDownBounce => 'assets/json/arrow_down_bounce.json';
}

class Assets {
  Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();
  static const String macosxwheel = 'assets/macosxwheel.flr';
  static const String meteor = 'assets/meteor.flr';
  static const AssetGenImage model = AssetGenImage('assets/model.jpg');
  static const String modelPng = 'assets/model.png.bak';
  static const AssetGenImage onbo1 = AssetGenImage('assets/onbo1.PNG');
  static const AssetGenImage onbo1Fixed =
      AssetGenImage('assets/onbo1_fixed.png');
  static const AssetGenImage onbo2 = AssetGenImage('assets/onbo2.PNG');
  static const AssetGenImage onbo2Fixed =
      AssetGenImage('assets/onbo2_fixed.png');
  static const AssetGenImage onbo3 = AssetGenImage('assets/onbo3.PNG');
  static const AssetGenImage onbo8 = AssetGenImage('assets/onbo8.png');
  static const AssetGenImage onboX = AssetGenImage('assets/onbo_x.png');
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName);

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
