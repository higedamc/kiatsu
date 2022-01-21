// URL: https://github.com/vandadnp/flutter-tips-and-tricks/commit/2d3c01d4683a348afa4fa134bdba707b450e4ee1

// Stringで'+'以外に'-'が使えるようになるｗ

extension Minus on String {
  String operator -(String rhs) => replaceAll(rhs, '');
}