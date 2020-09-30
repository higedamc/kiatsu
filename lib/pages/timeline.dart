import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

final DateTime createdAt = new DateTime.now();
DateTime today = new DateTime(createdAt.year, createdAt.month, createdAt.day);
DateTime now = new DateTime.now();

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
var currentUser = firebaseAuth.currentUser;
CollectionReference users = firebaseStore.collection('users');

class Timeline extends StatelessWidget {
  var user = firebaseAuth.currentUser;

  Timeline({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // var listitem = [
    //   '低気圧つらすぎぴえん会社やめるニートになるもう誰か養って誰でもいいからもうここまで来たら。嫌なんだよ地元に帰って深夜にドンキに集まるクソガイジヤンキーの連れになってジャージにキティサンでハイエースゴールインは死んでもむりだからぁぁぁぁ👠',
    //   '気圧もそうだが雨も辛いね、そうです。今日は部長の代わりにとらやの羊羹で謝罪クエストがあるんです。え？私は受注したつもり無いですよ？でも社会人というのは不思議なものです🥺',
    //   '今日はあっちこっち炎上してるけども、季節の変わり目と低気圧のせいだろうから一回寝ろ。あと、そういう時期はヤベエ奴ほどヤバさが天元突破して活発になっちゃうから相手すんな。まじでうまいもん食ってクソして寝ろ。 https://twitter.com/ayuneo/status/1303746094740811776',
    //   '低気圧即死我即死即死即死即死即死即死他民加油加油加油加油🤮🤮🤮🤮',
    //   '低気圧つらいぴえんしょんしょん。。低気圧つらいぴえんしょんしょん。。低気圧つらいぴえんしょんしょん。。🥺🥺🥺',
    // ];
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text('timeline'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: users
            .doc(user.uid)
            .collection('comments')
            .orderBy('createdAt', descending: true)
            .snapshots(includeMetadataChanges: true),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // final _doc = snapshot.data.docs.where((f) {
          //   return f.documentID == _comments;
          // }).toList();
          if (!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ));
          return ListView(
            children: snapshot.data.documents
                .map<Widget>((DocumentSnapshot docSnapshot) {
              return GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  elevation: 10,
                  child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(2.0),
                    child: Column(children: <Widget>[
                      ListTile(
                        leading: Icon(
                          Icons.cloud_circle,
                          size: 40,
                          color: Colors.black,
                        ),
                        title: Text(docSnapshot.data()['comment'],
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),
                    ]),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black26,
        onPressed: () {},
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            var _editor = TextEditingController();
            return showDialog(
                context: context,
                child: Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.all(10),
                    child: Stack(
                      overflow: Overflow.visible,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white),
                          padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                          child: TextFormField(
                            controller: _editor,
                            cursorWidth: 2,
                            cursorColor: Colors.grey,
                            decoration: InputDecoration(
                              hintText: '自由にコメントしてね🥺',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 140,
                          right: -20,
                          child: FlatButton(
                              onPressed: () async {
                                await users
                                    .doc(user.uid)
                                    .collection('comments')
                                    .doc()
                                    .set({
                                  'comment': _editor.text,
                                  'createdAt': createdAt
                                });
                                Navigator.of(context).pop();
                              },
                              child: NeumorphicText(
                                '押',
                                style: NeumorphicStyle(
                                  color: Colors.black87,
                                ),
                                textStyle: NeumorphicTextStyle(
                                  fontSize: 30,
                                ),
                              )),
                        ),
                      ],
                    )),
                );
          },
        ),
      ),
    );
  }
}
