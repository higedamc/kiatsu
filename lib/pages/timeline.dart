import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kiatsu/model/auth.dart';
import 'package:kiatsu/model/user.dart';

final DateTime createdAt = new DateTime.now();
final DateTime today =
    new DateTime(createdAt.year, createdAt.month, createdAt.day);
final DateTime now = new DateTime.now();
String _comment = 'comment';
final Auth auth = Auth();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
Stream collectionStream = firebaseStore.collectionGroup('comments').snapshots();
final currentUser = firebaseAuth.currentUser;
final CollectionReference users = firebaseStore.collection('users');
// var allUsers = firebaseStore.collectionGroup('comments').get();
// var getOne = firebaseStore
//     .collection('users').doc(user.uid).collection('comments')
//         .where('comments', isEqualTo: 'ha').get();

class Timeline extends StatelessWidget {
  final user = firebaseAuth.currentUser;

  // final DocumentSnapshot snapshot;

  // Future getDocs(QuerySnapshot snapshot) async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("users").get();

  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i];

  //     return snapshot =
  //         (await FirebaseFirestore.instance.collection('users').doc(a.id).get()) as QuerySnapshot;
  //   }
  // }
  // Future getDocs() async {
  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection("collection").get();
  //   for (int i = 0; i < querySnapshot.docs.length; i++) {
  //     var a = querySnapshot.docs[i];
  //     return (a.data());
  //   }
  // }

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
        // onPressed: () {},
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
