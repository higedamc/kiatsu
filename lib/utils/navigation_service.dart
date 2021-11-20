import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(Route route) {   
  return globalKey.currentState!.push(route);
  }
}