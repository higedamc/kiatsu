import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:settings_ui/settings_ui.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: SettingsList(
        key: _scaffoldKey,
        sections: [
          SettingsSection(
            title: 'デバッグ用',
            tiles: [
              SettingsTile(
                title: '強制クラッシュ',
                subtitle: '押',
                leading: NeumorphicIcon(Icons.language),
                onTap: () {
                  FirebaseCrashlytics.instance.crash();
                },
              ),
              // SettingsTile.switchTile(
              //   title: 'Use fingerprint',
              //   leading: Icon(Icons.fingerprint),
              //   switchValue: value,
              //   onToggle: (bool value) {},
              // ),
            ],
          ),
          SettingsSection(
            title: 'デバッグ用',
            tiles: [
              SettingsTile(
                  title: 'クラッシュ',
                  subtitle: '押',
                  leading: NeumorphicIcon(Icons.bug_report),
                  onTap: () async {
                    try {
                      throw 'error example';
                    } catch (e, s) {
                      FirebaseCrashlytics.instance.recordError(e, s);
                    }
                    print('クラッシュさせました＾ｑ＾');
                    _scaffoldKey.currentState.showSnackBar(SnackBar(
                      content: NeumorphicText('クラッシュボタンを押しました＾ｑ＾'),
                      duration: const Duration(seconds: 5),
                      action: SnackBarAction(label: '押した', onPressed: () {}),
                    ));
                  })
            ],
          ),
          SettingsSection(
            title: 'デバッグ用',
            tiles: [
              SettingsTile(
                title: 'アカウント削除',
                subtitle: '押',
                leading: NeumorphicIcon(Icons.language),
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('CAUTION!!!'),
                          content:
                              Text('Do you really want to delete account?'),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancel')),
                            FlatButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  var currentUser = firebaseAuth.currentUser;
                                  await currentUser.delete();
                                },
                                child: Text('OK')),
                          ],
                        );
                      });
                },
              ),
              // SettingsTile.switchTile(
              //   title: 'Use fingerprint',
              //   leading: Icon(Icons.fingerprint),
              //   switchValue: value,
              //   onToggle: (bool value) {},
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
