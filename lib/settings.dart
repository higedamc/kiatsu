import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('settings'),
        ),
        body: SettingsList(
          sections: [
            SettingsSection(
              title: 'Language',
              tiles: [
                SettingsTile(
                  title: 'Language',
                  subtitle: 'English',
                  leading: Icon(Icons.language),
                  onTap: () {},
                ),
              ],
            ),
            SettingsSection(
              title: 'Theme',
              tiles: [
                SettingsTile.switchTile(
                    title: 'Theme',
                    leading: Icon(Icons.lightbulb_outline),
                    onToggle: (bool value) {
                      setState(() {
                        ThemeData.dark() == value;
                      });
                    },
                    switchValue: true),
              ],
            ),
            SettingsSection(
              title: 'App Infomation',
              tiles: [
                SettingsTile(
                  title: 'バージョン情報',
                  subtitle: 'Ver.1.0.0',
                  leading: Icon(Icons.info_outline),
                )
              ],
            ),
          ],
        ));
  }
}
