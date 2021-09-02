import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(Route Route) {   
  return globalKey.currentState!.push(Route);
  }
}