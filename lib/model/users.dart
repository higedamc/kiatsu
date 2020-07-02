import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

abstract class BaseUsers {
  Future<void> create(String uid);
  Future<void> update(String uid);
}

class Users implements BaseUsers {
  Future<void> create(String uid) async {
    var db = Firestore.instance;

    await db.collection("users").document(uid).setData({
      "uid": uid,
      "createdAt": DateFormat("y/m/d H:mm", "en_US").format(new DateTime.now()),
      "updatedAt": DateFormat("y/m/d H:mm", "en_US").format(new DateTime.now()),
      "deletedAt": ''
    });
  }

  Future<void> update(String uid) async {
    var db = Firestore.instance;
    await db.collection("users").document(uid).setData({
      "updatedAt": DateFormat("y/m/d/ H:mm", "en_US").format(new DateTime.now())
    });
  }
}
