import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

final DateTime createdAt = new DateTime.now();
final DateTime today =
    new DateTime(createdAt.year, createdAt.month, createdAt.day);
final DateTime now = new DateTime.now();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
Stream collectionStream = firebaseStore
.collectionGroup('comments')
// .limit(100)
// .where('comment')
// .limit(50)
// .orderBy('createdAt', descending: true)
// .limit(10)
.snapshots();
final currentUser = firebaseAuth.currentUser;
final CollectionReference users = firebaseStore.collection('users');
// StreamController streamController = streamController
// .addStream(collectionStream)

class Timeline extends StatelessWidget {
  final user = firebaseAuth.currentUser;

  Timeline({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: Text('timeline'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                          // ワンチャンここのStreamBuilder要らないかもしれない（白目）
                          title: Text(docSnapshot.data()['comment'].toString(),
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black)),
                        ),
                      ]),
                    ),
                    actions: <Widget>[
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
