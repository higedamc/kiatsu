// import 'package:flutter/material.dart';
// import 'package:wiredash/wiredash.dart';

// class MyApp extends StatelessWidget {
//   // It's important that Wiredash and your root Material- / Cupertino- / WidgetsApp
//   // share the same Navigator key.
//   final _navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   Widget build(BuildContext context) {
//     return Wiredash(
//       projectId: 'YOUR-PROJECT-ID',
//       secret: 'YOUR-SECRET',
//       navigatorKey: _navigatorKey,
//       child: MaterialApp(
//         navigatorKey: _navigatorKey,
//         title: 'Flutter Demo',
//         home: YourSuperDuperAwesomeApp(),
//       ),
//     );
//   }
// }