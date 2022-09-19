import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart' as neu;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kiatsu/auth/auth_manager.dart';
import 'package:kiatsu/controller/user_controller.dart';
import 'package:kiatsu/model/dev_id.dart';
import 'package:kiatsu/providers/providers.dart';
import 'package:lottie/lottie.dart';
import 'package:wiredash/wiredash.dart';

//TODO: Firestore関連の処理のRiverpod化
//TODO: リアクション機能実装したい

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
final currentUser = firebaseAuth.currentUser;
final uid = firebaseAuth.currentUser?.uid;
final CollectionReference users = firebaseStore.collection('users');
final CollectionReference<Map<String, dynamic>> comment =
    users.doc(uid).collection('comments');
final CollectionReference blocked = firebaseStore.collection('blockedUsers');
// final stream = FirebaseFirestore.instance.collection('users')
//   // .orderBy('isBlocked', descending: false)
//   // .snapshots();
//   .where('isBlockedBy', arrayContains: uid);
// final docShot = firebaseStore.collection('isBlocked').where('isBlockedBy', arrayContains: uid).snapshots();
// ログインユーザーのコメント群

class Timeline extends ConsumerWidget {
  const Timeline({this.cityName, this.deletedUser, Key? key}) : super(key: key);

  final String? cityName;
  final String? deletedUser;

  Future<void> submitCityName(
      BuildContext context, String cityName, WidgetRef ref) async {
    await ref
        .read(weatherStateNotifierProvider.notifier)
        .getWeather(cityName, ref, context);
  }

  Future<bool> getDeletedUser(
    BuildContext context,
    String deletedUser,
    WidgetRef ref,
  ) async {
    final CollectionReference deletedUsers = firebaseStore.collection('users');
    final test = await deletedUsers.doc(currentUser?.uid).get();
    final dynamic deletedUser = test.get(FieldPath.fromString('idDeleted'));
    if (deletedUser != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authManager = ref.watch(authManagerProvider);
    final isNoAds = ref.watch(userProvider.select((s) => s.isNoAdsUser));
    final createdAt = ref.watch(clockProvider);
    // final isBlocked = ref.watch(blockedOrNotProvider);
    // final isCurrentUserBlocked = ref.watch(isCurrentUserblockedOrNotProvider);
    final size = MediaQuery.of(context).size;
    if (kDebugMode) {
      print(size);
    }
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
      body: ref.watch(commentsCollectionStreamProvider).when(
            data: (data) {
              if (kDebugMode) {
                print(data.length);
              }
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return authManager.isLoggedIn
                      ? GestureDetector(
                          // ignore: avoid_dynamic_calls
                          child: Visibility(
                            //TODO: commentのisBlockedByにログインユーザーのuidが含まれている場合は表示しない
                            // visible: data[index]['isBlockedBy']
                            //     .contains(currentUser!.uid) == true,
                            // visible: !(data[index]['commentId'] == true),
                            // visible: !(blockListProvider.asData?.value
                            //         .contains(data[index]['userId']) ==
                            //     false),
                            // visible: data[index]['userId'].toString() == docShot.contains(data[index]['userId']).toString(),
                            // visible: (
                            // ignore: avoid_dynamic_calls
                            //  blocks['${data[index]['blockId']}'] == null
                            // users
                            // .doc(currentUser?.uid).collection('blocks').
                            // .doc(data[index]['uid']).get().then(
                            //       (value) => value.exists,
                            //     ),

                            // ),
                            //TODO: とりあえず投稿単位ではブロックできる
                            visible:
                                //  isBlocked == false
                                // ,
                                //  &&
                                data[index]['isBlockedBy']
                                        .toString()
                                        .contains(uid!) ==
                                    false
                            // && isCurrentUserBlocked == false

                            // visible: !(users.),
                            // visible: !(blockListProvider.value
                            //         ?.contains(data[index]['userId']) ??
                            //     false),

                            // visible: firebaseStore.doc('blocked/$uid').snapshots().contains(data[index]['userId']) == true,
                            // visible: docShot.where((event) => event.data()!.containsKey(data[index]['$uid'])) == true,
                            ,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 10,
                              child: Slidable(
                                actionPane: const SlidableDrawerActionPane(),
                                actionExtentRatio: 0.25,
                                actions: <Widget>[
                                  if (data[index]['userId']
                                          ?.contains(currentUser?.uid) ==
                                      true)
                                    IconSlideAction(
                                      caption: '削除',
                                      color: Colors.red[700],
                                      icon: Icons.delete,
                                      onTap: () async {
                                        await comment
                                            .doc(
                                              data[index]['commentId']
                                                  .toString(),
                                            )
                                            .delete();
                                        // });
                                        // });
                                      },
                                    ),
                                ],
                                secondaryActions: <Widget>[
                                  if (data[index]['userId']
                                          ?.contains(currentUser?.uid) ==
                                      false)
                                    IconSlideAction(
                                      caption: '通報・ブロック',
                                      color: Colors.blueGrey,
                                      icon: Icons.block,
                                      onTap: () => showDialog<Widget>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          // final width =
                                          //     MediaQuery.of(context).size.width;
                                          // final height =
                                          //     MediaQuery.of(context).size.height;
                                          return AlertDialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              contentPadding: EdgeInsets.zero,
                                              elevation: 0,
                                              // title: Center(child: Text("Evaluation our APP")),
                                              content: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration: const BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    10))),
                                                    child: Column(
                                                      children: <Widget>[
                                                        InkWell(
                                                          child: const Center(
                                                            child: Text('違反報告'),
                                                          ),
                                                          onTap: () async =>
                                                              Wiredash.of(
                                                                      context)
                                                                  .show(),
                                                        ),
                                                        const Divider(),
                                                        InkWell(
                                                            child: const Center(
                                                              child: Text(
                                                                'ブロック',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () async {
                                                              //TODO: ここにブロックの処理を書く
                                                              // if (kDebugMode) {
                                                              //   print(docShot);
                                                              // }
                                                              // final yesss = await docShot.;
                                                              // if (kDebugMode) {
                                                              //   print(yesss);
                                                              // }
                                                              // final mapData = <
                                                              //     String,
                                                              //     dynamic>{
                                                              //   'comment':
                                                              //       txtControllerProvider
                                                              //           .text,
                                                              //   'createdAt':
                                                              //       createdAt,
                                                              //   'userId':
                                                              //       currentUser!
                                                              //           .uid
                                                              // };
                                                              //TODO: 後で試す
                                                              // final mapData = <
                                                              //     String,
                                                              //     dynamic>{
                                                              //   'blockId':
                                                              //       currentUser!
                                                              //           .uid,
                                                              //   'createdAt':
                                                              //       createdAt,
                                                              //   'userId':
                                                              //       data[index][
                                                              //               'userId']
                                                              //           .toString(),
                                                              // };
                                                              // await
                                                              //     users.doc(currentUser?.uid).collection('blocks').add(
                                                              //           mapData
                                                              // );
                                                              final maps = <
                                                                  String,
                                                                  dynamic>{
                                                                data[index][
                                                                        'userId']
                                                                    .toString(): true
                                                              };
                                                              // await blocks.doc(currentUser?.uid).set(
                                                              //    maps
                                                              // );
                                                              // await test2
                                                              //     .doc(currentUser!.uid)
                                                              //     .update({
                                                              //   data[index][
                                                              //           'userId']
                                                              //       .toString(): true,
                                                              // });
                                                              // final mapData = <
                                                              //     String,
                                                              //     dynamic>{
                                                              //   'isHidden':
                                                              //       true
                                                              // };
                                                              // await comment
                                                              //     .doc(
                                                              //       data[index][
                                                              //               'isHidden']
                                                              //           .toString(),
                                                              //     ).set(true)
                                                              //     // .set(mapData,
                                                              //     //     SetOptions(
                                                              //     //         merge:
                                                              //     //             true))
                                                              //     ;
                                                              // await users.doc(data[index]['isHidden'].toString()).update(maps);
                                                              //TODO: これは動く
                                                              // await firebaseStore
                                                              //     .doc(
                                                              //         'blocked/$uid')
                                                              //     .update({
                                                              //   data[index]
                                                              //           ['userId']
                                                              //       .toString(): true
                                                              // });
                                                              //TODO: arrayUnionしたい
                                                              // final  dummyToken = {"dummy": 'dummy', "isBlockedBy": data[index]['userId'].toString()} as List<dynamic>;
                                                              // await firebaseStore
                                                              //     .doc(
                                                              //         'isBlocked/$uid')
                                                              //     .update({
                                                              //       'isBlockedBy': FieldValue.arrayUnion(
                                                              //         dummyToken
                                                              //       )
                                                              // });
                                                              // await users.get();
                                                              final DocumentReference
                                                                  docRefs =
                                                                  users.doc(data[
                                                                              index]
                                                                          [
                                                                          'userId']
                                                                      .toString());
                                                              // final DocumentReference docRefs2 = blocked.doc(data[index]['userId'].toString());
                                                              final foo = [
                                                                'dummy',
                                                                currentUser?.uid
                                                              ];
                                                              await docRefs
                                                                  .update({
                                                                'isHidden':
                                                                    true,
                                                                'isBlockedBy':
                                                                    FieldValue
                                                                        .arrayUnion(
                                                                            foo),
                                                              });
                                                              final getDocRefs =
                                                                  await docRefs
                                                                      .get();
                                                              final Map<String,
                                                                      dynamic>
                                                                  baka =
                                                                  getDocRefs
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>;
                                                              final result = baka[
                                                                      'isBlockedBy']
                                                                  as List<
                                                                      dynamic>;
                                                              final result2 = result
                                                                  .where((dynamic
                                                                          e) =>
                                                                      e !=
                                                                      'dummy')
                                                                  .toList();
                                                              result2.isNotEmpty
                                                                  ? log(
                                                                      'This shit is blocked!')
                                                                  : log(
                                                                      'Aint blocked yet');
                                                              await docRefs
                                                                  .collection(
                                                                      'comments')
                                                                  .doc(data[index]
                                                                          [
                                                                          'commentId']
                                                                      .toString())
                                                                  .update({
                                                                'isBlockedBy':
                                                                    FieldValue
                                                                        .arrayUnion(
                                                                            foo),
                                                              });

                                                              log(getDocRefs
                                                                  .data()
                                                                  .toString());
                                                              // log(blockListProvider.value.toString());
                                                              log('hi, I am: ${result.toString()}');
                                                              log('hi, we are: ${result2.toString()}');
                                                              // await docRefs2
                                                              //     .update({
                                                              //   'THIS IS A TEST': true
                                                              // });
                                                              Future.delayed(
                                                                Duration.zero,
                                                                () => Navigator
                                                                    .pop(
                                                                        context),
                                                              );
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: InkWell(
                                                      child: const Center(
                                                          child: Text('キャンセル')),
                                                      onTap: () =>
                                                          Navigator.pop(
                                                              context),
                                                    ),
                                                  )
                                                ],
                                              ));
                                        },
                                      ),
                                      // showDialog<Widget>(
                                      //   context: context,
                                      //   builder: (BuildContext context) {
                                      //     return ReportDialogBox(
                                      //       title: '',
                                      //       descriptions: 'この機能は近日公開予定です♡',
                                      //       text: '押',
                                      //       key: UniqueKey(),
                                      //     );
                                      //   },
                                      // ),
                                    ),
                                ],
                                child: Container(
                                  margin: const EdgeInsets.all(10.0),
                                  padding: const EdgeInsets.all(2.0),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        //TODO: ここなんかもっと上手い書き方ないですかね（）
                                        // TODO: 課金した際に自分の名前の投稿がわかる機能追加
                                        leading: isNoAds == true &&
                                                (data[index]['userId']
                                                        ?.contains(
                                                      currentUser?.uid,
                                                    ) ==
                                                    true)
                                            ? const Text(
                                                'Me',
                                                style: TextStyle(
                                                  fontWeight:
                                                      neu.FontWeight.bold,
                                                  color: Colors.pink,
                                                ),
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
                                                      fontWeight:
                                                          neu.FontWeight.bold,
                                                    ),
                                                  )
                                                : null,

                                        title: Text(
                                          //TODO: 後で戻す => commentId
                                          data[index]['comment'].toString(),
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        subtitle: Text(
                                          (data[index]['location'].toString() ==
                                                      'null' ||
                                                  data[index]['location']
                                                          .toString() ==
                                                      'Cupertino')
                                              ? '電子の海'
                                              : data[index]['location']
                                                  .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
            loading: () => const Center(child: CircularProgressIndicator()),
          ),
      floatingActionButton: !authManager.isLoggedIn
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
                  ),
                ),
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
                  //refreshを走らせないとボタンが表示されないため走らせている
                  await ref
                      .refresh(
                        weatherStateNotifierProvider.notifier,
                      )
                      .getWeather(cityName!, ref, context);
                  if (kDebugMode) {
                    print(currentWidth + currentHeight);
                  }

                  await showDialog<Widget>(
                    context: context,
                    builder: (context) => Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: const EdgeInsets.all(10),
                      child: Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () => FocusScope.of(context).unfocus(),
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.white,
                              ),
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
                          ),
                          Positioned(
                            top: 140,
                            right: 1,
                            child: Consumer(
                              builder: (context, ref, child) {
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
                                      ),
                                    );
                                    return Container();
                                  },
                                  success: (data) => ElevatedButton(
                                    key: UniqueKey(),
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
                                      if (txtControllerProvider.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text('テキストの入力が必要です'),
                                            action: SnackBarAction(
                                              label: 'OK',
                                              onPressed: () {},
                                            ),
                                          ),
                                        );
                                        // Navigator.pop(context);
                                      } else {
                                        final mapData = <String, dynamic>{
                                          'comment': txtControllerProvider.text,
                                          'createdAt': createdAt,
                                          'userId': currentUser!.uid,
                                          'location': data.name.toString(),
                                        };

                                        final docRef = await users
                                            .doc(currentUser?.uid)
                                            .collection('comments')
                                            .add(mapData);
                                        final documentId = docRef.id;

                                        await users
                                            .doc(currentUser?.uid)
                                            .collection('comments')
                                            .doc(documentId)
                                            .update({
                                          'comment': txtControllerProvider.text,
                                          'createdAt': createdAt,
                                          'userId': currentUser!.uid,
                                          'location': data.name,
                                          'commentId': documentId,
                                          'isHidden': false
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
                                        color: Colors.white,
                                      ),
                                      textStyle: neu.NeumorphicTextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  loading: () => Container(),
                                  error: (String? error) {
                                    if (kDebugMode) {
                                      print(error);
                                    }
                                    return Container();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
