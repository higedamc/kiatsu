import 'package:flutter/material.dart';
import 'package:share/share.dart';

void main() {
  runApp(const DemoApp());
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

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
                  icon: const Icon(Icons.share),
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
