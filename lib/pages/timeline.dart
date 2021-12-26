import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kiatsu/model/dev_id.dart';
import 'package:kiatsu/pages/custom_dialog_box.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:permission_handler/permission_handler.dart';

//TODO: Firestore関連の処理のRiverpod化
//TODO: リアクション機能実装したい

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final currentUser = firebaseAuth.currentUser;
final uid = firebaseAuth.currentUser?.uid;
final CollectionReference users = firebaseStore.collection('users');
final CollectionReference<Map<String, dynamic>> test =
    users.doc(uid).collection('comments');

class Timeline extends ConsumerWidget {
  const Timeline({required this.cityName, required Key key}) : super(key: key);

  final String? cityName;

  void submitCityName(
      BuildContext context, String cityName, WidgetRef ref) async {
    await ref.read(weatherStateNotifierProvider.notifier).getWeather(cityName);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: neu.NeumorphicAppBar(
        title: const Text('お気持ち投稿の場'),
        centerTitle: true,
      ),
      body: ref.watch(collectionStreamProvider).when(
          data: (data) {
            print(data.length);
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return data[index]['userId'] != ''
                    ? GestureDetector(
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
                                  //TODO: ここなんかもっと上手い書き方ないですかね（）
                                  leading: data[index]['userId'] ==
                                              DevIds().dev1 ||
                                          data[index]['userId'] == DevIds().dev2
                                      ? const Text(
                                          'Dev',
                                          style: TextStyle(
                                            fontWeight: neu.FontWeight.bold,
                                          ),
                                        )
                                      : null,
                                  // leading:
                                  //     data[index]['userId'] == currentUser?.uid
                                  //         ? CircleAvatar(
                                  //             radius: 20.0,
                                  //             child: ClipRRect(
                                  //               child: currentUser?.providerData
                                  //                           .first.photoURL ==
                                  //                       null
                                  //                   ? const Icon(
                                  //                       Icons.cloud_circle,
                                  //                       size: 44.0,
                                  //                       color: Colors.black,
                                  //                     )
                                  //                   : Image.network(currentUser!
                                  //                       .providerData
                                  //                       .first
                                  //                       .photoURL!),
                                  //               borderRadius:
                                  //                   BorderRadius.circular(50.0),
                                  //             ),
                                  //           )
                                  //         : CircleAvatar(
                                  //             radius: 20.0,
                                  //             child: ClipRRect(
                                  //               child: Image.network(currentUser!
                                  //                       .providerData
                                  //                       .first
                                  //                       .photoURL!),
                                  //               borderRadius:
                                  //                   BorderRadius.circular(50.0),
                                  //             ),
                                  //           ),
                                  title: Text(data[index]['comment'].toString(),
                                      style: const TextStyle(
                                          fontSize: 18.0, color: Colors.black)),
                                  subtitle: Text(
                                    (data[index]['location'].toString() ==
                                                'null' ||
                                            data[index]['location']
                                                    .toString() ==
                                                'Cupertino')
                                        ? '電子の海'
                                        : data[index]['location'].toString(),
                                  ),
                                ),
                              ]),
                            ),
                            actions: <Widget>[
                              if (data[index]['userId']
                                  ?.contains(currentUser?.uid))
                                IconSlideAction(
                                    caption: '削除',
                                    color: Colors.red[700],
                                    icon: Icons.delete,
                                    onTap: () async {
                                      test
                                          .doc(data[index]['commentId'])
                                          .delete();
                                      // });
                                      // });
                                    }),
                            ],
                          ),
                        ),
                      )
                    : Container();
              },
            );
          },
          error: (err, stack) => Center(child: Text(err.toString())),
          loading: () => const Center(child: CircularProgressIndicator())),
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
                                            var status = await Permission
                                                .location
                                                .request();
                                            if (status !=
                                                PermissionStatus.granted) {
                                              // 一度もリクエストしてないので権限のリクエスト.
                                              status = await Permission.location
                                                  .request();
                                            }
                                            // 権限がない場合の処理.
                                            // if (
                                            //     status.isDenied ||
                                            //     status.isRestricted ||
                                            //     status.isPermanentlyDenied) {
                                            //   // 端末の設定画面へ遷移.
                                            //   await openAppSettings();
                                            //   return;
                                            // }
                                            // var collection = FirebaseFirestore
                                            //     .instance
                                            //     .collection('comments');
                                            final docRef = await users
                                                .doc(currentUser?.uid)
                                                .collection('comments')
                                                .add({
                                              'comment': _editor.text,
                                              'createdAt': createdAt,
                                              'userId': currentUser!.uid,
                                              'location': data.name.toString(),
                                            });
                                            // var documentId = docRef.id;
                                            (_editor.text.isEmpty)
                                                ? showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        const AlertDialog(
                                                            title: Text(
                                                                'コメントを入力してください')))
                                                : docRef;
                                            final documentId = docRef.id;
                                            await users
                                                .doc(currentUser!.uid)
                                                .collection('comments')
                                                .doc(documentId)
                                                .update({
                                              'comment': _editor.text,
                                              'createdAt': createdAt,
                                              'userId': currentUser!.uid,
                                              'location': data.name.toString(),
                                              'commentId': documentId,
                                            });
                                            // print(createdAt.toString());
                                            Navigator.of(context).pop();
                                          },
                                          child: neu.NeumorphicText(
                                            '押',
                                            // textAlign: TextAlign.center,
                                            style: const neu.NeumorphicStyle(
                                                depth: 20,
                                                intensity: 0.5,
                                                color: Colors.white),
                                            textStyle: neu.NeumorphicTextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                    loading: () => Container(),
                                    error: (String? error) {
                                      print(error);
                                      return Container();
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
