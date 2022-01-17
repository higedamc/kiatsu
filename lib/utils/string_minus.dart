extension Minus on String {
  String operator -(String rhs) => replaceAll(rhs, '');
}