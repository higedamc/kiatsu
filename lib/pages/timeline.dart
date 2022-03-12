import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kiatsu/auth/auth_manager.dart';
import 'package:kiatsu/controller/user_controller.dart';
import 'package:kiatsu/model/dev_id.dart';
import 'package:kiatsu/pages/custom_dialog_box.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:lottie/lottie.dart';

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
    final _authManager = ref.watch(authManagerProvider);
    final isNoAds = ref.watch(userProvider.select((s) => s.isNoAdsUser));
    final createdAt = ref.watch(clockProvider);
    Size size = MediaQuery.of(context).size;
    print(size);
    final width = size.width;
    final height = size.height;
    final currentWidth = width / 100;
    final currentHeight = height / 100;
    final txtControllerProvider = ref.watch(textControllerStateProvider);
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
                return _authManager.isLoggedIn
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
                                  // TODO: 課金した際に自分の名前の投稿がわかる機能追加
                                  leading: isNoAds &&
                                          (data[index]['userId']
                                              ?.contains(currentUser?.uid))
                                      ? const Text(
                                          'Me',
                                          style: TextStyle(
                                              fontWeight: neu.FontWeight.bold,
                                              color: Colors.pink),
                                        )
                                      : data[index]['userId'] ==
                                                  DevIds().dev1 ||
                                              data[index]['userId'] ==
                                                  DevIds().dev2 ||
                                              data[index]['userId'] ==
                                                  DevIds().dev3 ||
                                              data[index]['userId'] ==
                                                  DevIds().dev4
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
          error: (err, stack) => Stack(
                children: const [
                  Center(
                    child: Text('この機能を使うためにはログインが必要です'),
                  ),
                ],
              ),
          loading: () => const Center(child: CircularProgressIndicator())),
      floatingActionButton: !_authManager.isLoggedIn
          ? Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    color: Colors.white,
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Lottie.asset(
                        'assets/json/arrow_down_bounce.json',
                      ),
                    )),
                const SizedBox(
                  height: 30,
                ),
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  onPressed: () {},
                  child: IconButton(
                    icon: const Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await Navigator.pushNamed(context, '/sign');
                    },
                  ),
                ),
              ],
            )
          : FloatingActionButton(
              backgroundColor: Colors.black,
              onPressed: () {},
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  print(currentWidth + currentHeight);
                  // final _editor = TextEditingController();

                  showDialog(
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
                                controller: txtControllerProvider,
                                cursorWidth: 2,
                                cursorColor: Colors.grey,
                                decoration: InputDecoration(
                                  hintText: txtControllerProvider.text.isEmpty
                                      ? 'テキストを入力してください'
                                      : '',
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
                                            if (txtControllerProvider
                                                .text.isEmpty) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                content:
                                                    const Text('テキストの入力が必要です'),
                                                action: SnackBarAction(
                                                    label: 'OK',
                                                    onPressed: () {}),
                                              ));
                                              Navigator.pop(context);
                                            } else {
                                              final docRef = await users
                                                  .doc(currentUser?.uid)
                                                  .collection('comments')
                                                  .add({
                                                'comment':
                                                    txtControllerProvider.text,
                                                'createdAt': createdAt,
                                                'userId': currentUser!.uid,
                                                'location':
                                                    data.name.toString(),
                                              });
                                              final documentId = docRef.id;

                                              await users
                                                  .doc(currentUser?.uid)
                                                  .collection('comments')
                                                  .doc(documentId)
                                                  .update({
                                                'comment':
                                                    txtControllerProvider.text,
                                                'createdAt': createdAt,
                                                'userId': currentUser!.uid,
                                                'location':
                                                    data.name.toString(),
                                                'commentId': documentId,
                                              });
                                              Navigator.pop(context);
                                            }
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
