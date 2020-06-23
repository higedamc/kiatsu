import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build (BuildContext context) {
    return SettingsList(
      key: _scaffoldKey,
        sections: [
          SettingsSection(
            title: 'デバッグ用',
            tiles: [
              SettingsTile(
                title: '強制クラッシュ',
                subtitle: '押',
                leading: Icon(Icons.language),
                onTap: () {
                  Crashlytics.instance.crash();
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
                title:
                 'クラッシュ',
                 subtitle: '押',
                 leading: Icon(Icons.bug_report),
                 onTap: () async {
                   try{
                              throw 'error example';
                            } catch (e, s) {
                              Crashlytics.instance.recordError(e, s, context: '＾ｑ＾');
                            }
                   print('クラッシュさせました＾ｑ＾');
                   _scaffoldKey.currentState.showSnackBar(
                     SnackBar(
                       content: const Text('クラッシュボタンを押しました＾ｑ＾'),
                       duration: const Duration(seconds: 5),
                       action: SnackBarAction(
                         label: '押した',
                          onPressed: (){
                            
                          }),)
                   );
                 })
            ],
          ),
        ],
      );
  }
}

