import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:apple_sign_in/apple_sign_in_button.dart' as app;
import 'package:flutter/material.dart';
import 'package:kiatsu/auth/apple_signin_available.dart';
import 'package:kiatsu/utils/apple_auth.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            if (appleSignInAvailable.isAvailable)
              AppleSignInButton(
                style: app.ButtonStyle.black, // style as needed
                type: ButtonType.signIn, // style as needed
                onPressed: () {
                  AppleAuthUtil.signInWithApple();
                },
              ),
          ],
        ),
      ),
    );
  }
}
