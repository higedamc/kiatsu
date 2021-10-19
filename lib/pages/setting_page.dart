import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:kiatsu/api/purchase_api.dart';

import 'package:kiatsu/pages/sign_in_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wiredash/wiredash.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final currentUser = firebaseAuth.currentUser;
// test1
final currentPurchaser = PurchaseApi.getCurrentPurchaser();

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return neu.Neumorphic(
      child: SettingsList(
        sections: [
          SettingsSection(
            title: 'アカウント管理',
            tiles: [
              SettingsTile(
                  title: 'SNSログイン',
                  subtitle: '押',
                  leading: neu.NeumorphicIcon(Icons.account_circle_outlined),
                  onPressed: (context) async {
  
                    await Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignInPage()));
                  }),
              SettingsTile(
                  title: 'アカウント名',
                  onPressed: (context) => Clipboard.setData(
                        ClipboardData(
                          text: currentUser!.uid.toString(),
                        ),
                      ).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              key: UniqueKey(),
                              content: const Text('アカウント名がコピーされました！')),
                        );
                      }),
                  subtitle: currentUser!.uid),
            ],
          ),
          SettingsSection(
            title: '開発者を応援する＾q＾',
            tiles: [
              SettingsTile(
                  title: 'フィードバック送信',
                  subtitle: '押',
                  leading: neu.NeumorphicIcon(Icons.bug_report),
                  onPressed: (context) async {
                    Wiredash.of(context)!.show();
                  }),
              // snapshot.hasData
              //     ? SettingsTile(
              //         title: '広告解除済み',
              //         subtitle: '',
              //         leading: neu.NeumorphicIcon(Icons.attach_money_rounded),
              //         onPressed: (_) async {
              //           // // Navigator.pushNamed(_, '/buy');
              //           // fetchOffers2(context);
              //         })
              //     : SettingsTile(
              //         title: '有料機能',
              //         subtitle: '押',
              //         leading: neu.NeumorphicIcon(Icons.attach_money_rounded),
              //         onPressed: (_) async {
              //           // Navigator.pushNamed(_, '/buy');
              //           //  Navigator.pushNamed(context, '/subsc');
              //           Navigator.pop(context);
              //           // Navigator.pushNamed(context, '/iap');
              //         }),
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
