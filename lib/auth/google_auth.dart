import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// 参考: https://qiita.com/smiler5617/items/f94fdc1afe088586715b

// TODO: 本リリースまでに実装する

class GoogleAuthUtil {
  /// サインイン中か
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  static final googleSignIn = GoogleSignIn(scopes: [
    'email'
  ]);

  /// サインイン
  static Future<User?> signIn(BuildContext context) async {
    final UserCredential? credential = await signInWithGoogle(context);
    return credential?.user;
  }

  static Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    final newUser = FirebaseAuth.instance;
    final createdAt = DateTime.now();
    final FirebaseFirestore firebaseStore = FirebaseFirestore.instance;
    final CollectionReference collection = firebaseStore.collection('users');

    try {
      final GoogleSignInAccount? googleUser =
        await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final googleAuthCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // final AuthCredential googleAuthCredential = GoogleAuthProvider.credential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    return newUser
        .signInWithCredential(googleAuthCredential)
        .then((result) async {
      final displayName = result.user?.displayName;
      final email = result.user?.email;
      final photoUrl = result.user?.photoURL;
      final uid = result.user?.uid;
      final providerData = result.user?.providerData;
      final firebaseUser = result.user;
      await firebaseUser?.updatePhotoURL(photoUrl);
      await collection.doc(result.user?.uid).set({
        'uid': uid,
        'displayName': displayName,
        'email': email,
        'photoUrl': photoUrl,
        'createdAt': createdAt,
        'providerData': providerData,
      });
    });
    } on FirebaseAuthException catch (e) {
      print('Failed with error code: ${e.code}');
      print(e.message);
      return null;
    }
  }
}
