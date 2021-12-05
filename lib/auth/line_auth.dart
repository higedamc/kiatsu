// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart';
// import 'package:github_sign_in/github_sign_in.dart';

// //TODO: 今週中に実装する
// //参照すべきURL: https://zenn.dev/yskuue/articles/410e5b787b354a
// //参照すべきURL2: https://www.youtube.com/watch?v=TT_RoA4ygEU&list=PLmg-gZJdxKEUbB8c-OPgCcpibP2L1tm-w&index=1&t=1328s 


// class LineAuthUtil {

//   /// サインイン中か
//   static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

//   /// 現在のユーザー情報
//   static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

//   /// サインアウト
//   static void signOut() => FirebaseAuth.instance.signOut();

//   /// サインイン
//   static Future<User?> signIn(BuildContext context) async {
//     final UserCredential? credential = await signInWithLine(context);
//     return credential?.user;
//   }

//   static Future<UserCredential?> signInWithLine(BuildContext context) async {
//     final result = await LineSDK.instance.login(
//       option: LoginOption(false, 'aggressive'),
//     );

//     return await FirebaseAuth.instance
//         .signInWithCredential(githubAuthCredential);
//   }
// }