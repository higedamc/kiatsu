import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TwitterAuthSupabase {
  Future<void> signInWithTwitter() async {

    final res = await Supabase.instance.client.auth.
    signInWithProvider(Provider.twitter,
    options: AuthOptions(
      redirectTo: kIsWeb
      ? null
      : 'io.supabase.flutter://reset-callback/'
    ));
    final error = res.error;

  }
}







