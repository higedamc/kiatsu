import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kiatsu/pages/custom_dialog_box.dart';
import 'package:kiatsu/providers/providers.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final uid = firebaseAuth.currentUser?.uid;
final user = firebaseAuth.currentUser;
final currentUser = firebaseAuth.currentUser;
final CollectionReference users = firebaseStore.collection('users');

Stream<QuerySnapshot<Map<String, dynamic>>> collectionStream = firebaseStore
    .collectionGroup('comments')
    .orderBy('createdAt', descending: true)
    .snapshots();

void submitCityName(
    BuildContext context, String cityName, WidgetRef ref) async {
  await ref.read(weatherStateNotifierProvider.notifier).getWeather(cityName);
}

class Timeline extends ConsumerWidget {
  const Timeline({required this.cityName, required Key key}) : super(key: key);
  final String? cityName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final authUser = ref.watch(authStateChangesProvider).asData?.value;
    return Scaffold(
      appBar: neu.NeumorphicAppBar(
        title: const Text('お気持ち投稿の場'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: collectionStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
           // TODO: 非ログイン時に投稿ボタンを消してTLだけ見れるような実装にしたい
           if (user == null) print(snapshot.error);
          if (!snapshot.hasData) {
             return const Center(child: Text('この機能はログインしているユーザーのみ使用できます'));

           }
          return ListView(
            // TODO: ここの処理を全部Riverpod化する
            children: snapshot.data?.docs.map<Widget>(
                (DocumentSnapshot<Map<String, dynamic>> docSnapshot) {
              return GestureDetector(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  elevation: 10,
                  child: Slidable(
                    actionPane: const SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(2.0),
                      child: Column(children: [
                        ListTile(
                          leading: (docSnapshot
                                  .data()!
                                  .containsValue(currentUser?.uid))
                              ? CircleAvatar(
                                  radius: 20.0,
                                  child: ClipRRect(
                                    child: user?.providerData.first.photoURL ==
                                            null
                                        ? null
                                        : Image.network(
                                            user!.providerData.first.photoURL!),
                                    borderRadius: BorderRadius.circular(50.0),
                                  ),
                                )
                              : const Icon(
                                  Icons.cloud_circle,
                                  size: 44.0,
                                  color: Colors.black,
                                ),
                          title: Text(docSnapshot.data()!['comment'].toString(),
                              style: const TextStyle(
                                  fontSize: 18.0, color: Colors.black)),
                          subtitle: Text(
                            (docSnapshot.data()!['location'].toString() ==
                                        'null' ||
                                    docSnapshot
                                            .data()!['location']
                                            .toString() ==
                                        'Cupertino')
                                ? '電子の海'
                                : docSnapshot.data()!['location'].toString(),
                          ),
                        ),
                      ]),
                    ),
                    actions: <Widget>[
                      if (docSnapshot.data()!.containsValue(currentUser?.uid))
                        IconSlideAction(
                          caption: '削除',
                          color: Colors.red[700],
                          icon: Icons.delete,
                          onTap: () => {
                            users
                                .doc(currentUser!.uid)
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
        backgroundColor: Colors.black,
        onPressed: () {},
        child: IconButton(
          icon: const Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            final DateTime createdAt = DateTime.now();
            final _editor = TextEditingController();
            (uid == null)
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialogBox(
                        title: 'てへぺろ☆(ゝω･)vｷｬﾋﾟ',
                        descriptions: 'この機能はログインしているユーザーのみ使用できます',
                        text: 'りょ',
                        key: UniqueKey(),
                      );
                    })
                : showDialog(
                    context: context,
                    builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        insetPadding: const EdgeInsets.all(10),
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
                              padding:
                                  const EdgeInsets.fromLTRB(20, 50, 20, 20),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                controller: _editor,
                                cursorWidth: 2,
                                cursorColor: Colors.grey,
                                decoration: const InputDecoration(
                                  hintText: '自由にコメントしてね🥺',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 140,
                              right: 1,
                              child: Consumer(builder: (context, ref, child) {
                                final weatherState =
                                    ref.watch(weatherStateNotifierProvider);
                                return weatherState.when(
                                    initial: () {
                                      Future.delayed(
                                          Duration.zero,
                                          () => submitCityName(
                                                context,
                                                cityName.toString(),
                                                ref,
                                              ));
                                      return Container();
                                    },
                                    success: (data) => ElevatedButton(
                                          // style: ButtonStyle(
                                          //   backgroundColor: MaterialStateProperty.all(Colors.black38),
                                          // ),
                                          style: ElevatedButton.styleFrom(
                                            primary: Colors.white,
                                            onPrimary: Colors.black,
                                            shape: const CircleBorder(
                                              side: BorderSide(
                                                color: Colors.black,
                                                width: 1,
                                                style: BorderStyle.solid,
                                              ),
                                            ),
                                          ),

                                          onPressed: () async {
                                            (_editor.text.isEmpty)
                                                ? showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const AlertDialog(
                                                            title: Text(
                                                                'コメントを入力してください')))
                                                : await users
                                                    .doc(currentUser!.uid)
                                                    .collection('comments')
                                                    .doc()
                                                    .set({
                                                    'comment': _editor.text,
                                                    'createdAt': createdAt,
                                                    'userId': currentUser!.uid,
                                                    'location':
                                                        data.name.toString(),
                                                  });
                                            // print(createdAt.toString());
                                            Navigator.of(context).pop();
                                          },
                                          child: NeumorphicText(
                                            '押',
                                            // textAlign: TextAlign.center,
                                            style: const NeumorphicStyle(
                                                depth: 20,
                                                intensity: 0.5,
                                                color: Colors.white),
                                            textStyle: NeumorphicTextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
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
