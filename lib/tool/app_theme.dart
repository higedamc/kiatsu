import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class AppTheme extends ChangeNotifier {
	AppTheme() : _isDark = false;

	bool get isDark => _isDark;

	bool _isDark;
	
	ThemeData buildTheme()
		=> _isDark ? ThemeData.dark() : ThemeData.light();
	
	void changeMode() {
		_isDark = !_isDark;
		notifyListeners();
	}
} 