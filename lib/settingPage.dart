import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {

  @override
  Widget build (BuildContext context) {
    return SettingsList(
        sections: [
          SettingsSection(
            title: 'セクション',
            tiles: [
              SettingsTile(
                title: '言語',
                subtitle: '日本語',
                leading: Icon(Icons.language),
                onTap: () {},
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
      );
  }
}

