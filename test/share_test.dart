import 'package:flutter/material.dart';
import 'package:share/share.dart';

void main() {
  runApp(DemoApp());
}

class DemoApp extends StatefulWidget {
  @override
  DemoAppState createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Share Plugin Demo',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Share Plugin Demo'),
          ),
          body: Center(
            child: Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () {
                    Share.share('test');
                  },
                )
              ],
            ),
          ),
        ));
  }
}
