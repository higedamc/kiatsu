import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart' as app;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kiatsu/auth/apple_signin_available.dart';
import 'package:kiatsu/pages/timeline.dart';
import 'package:kiatsu/utils/apple_auth.dart';
import 'package:provider/provider.dart';

// Future<User> linkAnonToApple(BuildContext context) async {
//     final _auth = FirebaseAuth.instance;
//     final user = _auth.currentUser;
//     final credential = await signInWithApple();
//     // final AuthCredential authCredential = credential.credential;

//     return firebaseUser;
//   }

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final now = _auth.currentUser;
    final appleSignInAvailable =
        Provider.of<AppleSignInAvailable>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (appleSignInAvailable.isAvailable && now!.isAnonymous) ?
              AppleSignInButton(
                style: app.ButtonStyle.black, // style as needed
                type: ButtonType.signIn, // style as needed
                onPressed: () async {
                  if (now.isAnonymous) {
                    // await AppleAuthUtil.signIn(context);
                    // if (currentUser.isAnonymous)
                    // await AppleAuthUtil.linkAnonToApple(context);
                    await AppleAuthUtil.forceLink(context);
                    print(now.uid);
                  }
                  else {
                    print('Apple IDでサイン済み');
                  }
                },
              ) : Center(child: Text('Apple IDでサインイン済み')),
          ],
        ),
      ),
    );
  }
}
