import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:timeago/timeago.dart' as timeago;

final geo = Geoflutterfire();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final uid = firebaseAuth.currentUser.uid;
Stream collectionStream = firebaseStore
.collectionGroup('comments')
.orderBy('createdAt', descending: true)
.snapshots();
final currentUser = firebaseAuth.currentUser;
final CollectionReference users = firebaseStore.collection('users');

class Timeline extends StatefulWidget {

  Timeline({Key key}) : super(key: key);

  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  final user = firebaseAuth.currentUser;

  DateTime updatedAt = DateTime.now();

  Future<void> _refresher() async {
    setState(() {
      updatedAt = new DateTime.now();
      // 引っ張ったときに5日分の天気データ取得する
      // queryForecast();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime createdAt = new DateTime.now();
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text('受付タイムライン'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            ));
          return RefreshIndicator(
            onRefresh: () => _refresher(),
            child: ListView(
              children: snapshot.data.documents
                  .map<Widget>((DocumentSnapshot docSnapshot) {
                return GestureDetector(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    elevation: 10,
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.25,
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
                            title: Text(docSnapshot.data()['comment'].toString(),
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black)),
                            subtitle: Text(timeago.format(updatedAt, locale: 'ja').toString()),
                          ),
                        ]),
                      ),
                      actions: <Widget>[
                        if (docSnapshot.data().containsValue(user.uid))
                        IconSlideAction(
                          caption: '削除',
                          color: Colors.red[700],
                          icon: Icons.delete,
                          onTap: () => {
                            users
                                .doc(user.uid)
                                .collection('comments')
                                .doc(docSnapshot.id)
                                .delete()
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
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
            final DateTime createdAt = new DateTime.now();
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
                                'createdAt': createdAt,
                                'userId': user.uid
                              });
                              // print(createdAt.toString());
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
