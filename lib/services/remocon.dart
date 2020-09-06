import 'package:firebase_remote_config/firebase_remote_config.dart';

// static const String APP = "app";

remoCon(String id) async {
  RemoteConfig _remo;
  // final RemoteConfig _remo = await RemoteConfig.instance;
  const String APP = "app";
  await _remo.fetch(expiration: Duration(seconds: 0));
  await _remo.activateFetched();
  String yeah = _remo.getValue(APP).asString();
  return yeah;
}

Future<RemoteConfig> setupRemoteConfig() async {
  final RemoteConfig remoteConfig = await RemoteConfig.instance;
  remoteConfig.setConfigSettings(RemoteConfigSettings(debugMode: true));
  remoteConfig.setDefaults(<String, dynamic>{
    'nyan_nyan': 'F-U',
  });

  try {
    // Using default duration to force fetching from remote server.
    await remoteConfig.fetch();
    await remoteConfig.activateFetched();
  } on FetchThrottledException catch (exception) {
    // Fetch throttled.
    print(exception);
  } catch (exception) {
    print(exception);
  }
  return remoteConfig;
}
