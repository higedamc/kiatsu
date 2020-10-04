import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kiatsu/model/user.dart';

class Auth2 {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _firebaseAuth.currentUser;
    return currentUser;
  }

  Future<List<Users>> fetchAllUsers(User currentUser) async {
    List<Users> userList = List<Users>();

    QuerySnapshot querySnapshot =
        await firestore.collectionGroup("comments").get();
    for (var i = 0; i < querySnapshot.docs.length; i++) {
      // ignore: unrelated_type_equality_checks
      if (querySnapshot.docs[i].data() != currentUser.uid) {
        userList.add(Users.fromMap(querySnapshot.docs[i].data()));
      }
    }
    return userList;
  }
}
