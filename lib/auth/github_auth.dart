import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:github_sign_in/github_sign_in.dart';

// TODO: #121 ログインキャンセル時のエラーハンドリングをする
// TODO: #122 そもそもログインできない問題をどうにかする
// TODO: 本リリースまでに実装する

class GithubAuthUtil {
  static final GitHubSignIn? _github = GitHubSignIn(
    clientId: dotenv.env['GITHUB_CLIENT_ID'].toString(),
    clientSecret: dotenv.env['GITHUB_CLIENT_SECRET'].toString(),
    redirectUrl: dotenv.env['FIREBASE_REDIRECT_URL'].toString(),
  );

  /// サインイン中か
  static bool isSignedIn() => FirebaseAuth.instance.currentUser != null;

  /// 現在のユーザー情報
  static User? getCurrentUser() => FirebaseAuth.instance.currentUser;

  /// サインアウト
  static void signOut() => FirebaseAuth.instance.signOut();

  /// サインイン
  static Future<User?> signIn(BuildContext context) async {
    final UserCredential? credential = await signInWithGithub(context);
    return credential?.user;
  }

  static Future<UserCredential?> signInWithGithub(BuildContext context) async {
    final result = await _github?.signIn(context);

    final githubAuthCredential =
        GithubAuthProvider.credential(result!.token!);

    return await FirebaseAuth.instance
        .signInWithCredential(githubAuthCredential);
  }
}