import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

final DateTime createdAt = new DateTime.now();
DateTime today = new DateTime(createdAt.year, createdAt.month, createdAt.day);

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
var currentUser = firebaseAuth.currentUser;
CollectionReference users = firebaseStore.collection('users');

Future<UserCredential> signInAnon() async {
  UserCredential user = await firebaseAuth.signInAnonymously();
  return user;
}

// ignore: must_be_immutable
class Timeline extends StatelessWidget {
  var user = currentUser;
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
        stream: users.doc(user.uid).collection('comments').snapshots(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return CircularProgressIndicator();
          return ListView.builder(
            itemBuilder: (context, index) {
              Container(
                  child: GestureDetector(
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
                        title: Text(
                            snapshot.data.docs[index]['comment'].toString(),
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black)),
                      ),
                    ]),
                  ),
                ),
              ));
            },
            itemCount: snapshot.data.docs.length,
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
            TextEditingController Comment = TextEditingController();
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('自由にコメントしてね🥺'),
                    content: Builder(builder: (context) {
                      var height = MediaQuery.of(context).size.height / 6;
                      var width = MediaQuery.of(context).size.width / 2;
                      return Container(
                        height: height,
                        width: width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: Comment,
                              decoration:
                                  InputDecoration(hintText: 'ベロベロニャァァァァ'),
                            ),
                          ],
                        ),
                      );
                    }),
                    actions: [
                      FlatButton(
                        child: Text('post'),
                        onPressed: () {
                          users.doc(today.toString()).set({'comment': Comment});
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
