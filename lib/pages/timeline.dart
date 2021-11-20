import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kiatsu/utils/providers.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final uid = firebaseAuth.currentUser!.uid;
final user = firebaseAuth.currentUser;
Stream<QuerySnapshot<Map<String, dynamic>>> collectionStream = firebaseStore
    .collectionGroup('comments')
    .orderBy('createdAt', descending: true)
    .snapshots();
final currentUser = firebaseAuth.currentUser;
final CollectionReference users = firebaseStore.collection('users');

void submitCityName(
    BuildContext context, String cityName, WidgetRef ref) async {
  await ref.read(weatherStateNotifierProvider.notifier).getWeather(cityName);
}

class Timeline extends ConsumerWidget {
  Timeline({required Key key}) : super(key: key);
  late final String? cityName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: neu.NeumorphicAppBar(
        title: Text('お気持ち投稿の場'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // TODO: #123 非ログイン時に投稿ボタンを消してTLだけ見れるような実装にしたい
          if (snapshot.hasError) print(snapshot.error);
          if (!snapshot.hasData)
            return Center(child: Text('この機能を使うにはログインする必要があります'));
          return ListView(
            children: snapshot.data.docs.map<Widget>(
                (DocumentSnapshot<Map<String, dynamic>> docSnapshot) {
              return GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  elevation: 10,
                  child: Slidable(
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                            icon: Icons.delete,
                            label: '削除',
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            onPressed: (_) {
                              if (docSnapshot
                                  .data()!
                                  .containsValue(currentUser?.uid))
                                users
                                    .doc(currentUser!.uid)
                                    .collection('comments')
                                    .doc(docSnapshot.id)
                                    .delete();
                            })
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.all(10.0),
                      padding: EdgeInsets.all(2.0),
                      child: Column(children: [
                        ListTile(
                          leading: (docSnapshot
                                  .data()!
                                  .containsValue(currentUser?.uid))
                              ? CircleAvatar(
                                  radius: 20.0,
                                  child: ClipRRect(
                                    child: Image.network(
                                        user!.providerData.first.photoURL!),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                )
                              : Icon(
                                  Icons.cloud_circle,
                                  size: 44.0,
                                  color: Colors.black,
                                ),
                          title: Text(docSnapshot.data()!['comment'].toString(),
                              style: TextStyle(
                                  fontSize: 18.0, color: Colors.black)),
                          subtitle: Text(
                            (docSnapshot.data()!['location'].toString() ==
                                        "null" ||
                                    docSnapshot
                                            .data()!['location']
                                            .toString() ==
                                        'Cupertino')
                                ? "電子の海"
                                : docSnapshot.data()!['location'].toString(),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: (user == null)
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {},
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  final DateTime createdAt = new DateTime.now();
                  var _editor = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: EdgeInsets.all(10),
                        child: Stack(
                          // ignore: deprecated_member_use
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
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
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
                              right: 1,
                              child: Consumer(builder: (context, watch, child) {
                                final weatherState =
                                    ref.watch(weatherStateNotifierProvider);
                                return weatherState.when(
                                    initial: () {
                                      Future.delayed(
                                          Duration.zero,
                                          () => submitCityName(context,
                                              cityName.toString(), ref));
                                      return Container();
                                    },
                                    success: (data) => TextButton(
                                        onPressed: () async {
                                          await users
                                              .doc(currentUser!.uid)
                                              .collection('comments')
                                              .doc()
                                              .set({
                                            'comment': _editor.text,
                                            'createdAt': createdAt,
                                            'userId': currentUser!.uid,
                                            'location': data.name.toString(),
                                          });
                                          // print(createdAt.toString());
                                          Navigator.of(context).pop();
                                        },
                                        child: neu.NeumorphicText(
                                          '押',
                                          style: neu.NeumorphicStyle(
                                            color: Colors.black87,
                                          ),
                                          textStyle: neu.NeumorphicTextStyle(
                                            fontSize: 30,
                                          ),
                                        )),
                                    loading: () => Container(),
                                    error: (String? message) {
                                      return SnackBar(
                                        content: Text(message.toString()),
                                        action: SnackBarAction(
                                          label: 'りょ',
                                          onPressed: () {},
                                        ),
                                      );
                                    });
                              }),
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
