import 'package:firebase_remote_config/firebase_remote_config.dart';

const String _GetSomething = "app";
Map<String, dynamic> defaults;
class RemoteConfigService {
  final RemoteConfig _remoteConfig;

  static RemoteConfigService _instance;
  static Future<RemoteConfigService> getInstance() async {
    if (_instance == null) {
      _instance = RemoteConfigService(
        remoteConfig: await RemoteConfig.instance,
      );
    }

    return _instance;
  }
  Future initialize() async {
    try {
      await _remoteConfig.setDefaults(defaults);
      await _fetchAndActivate();
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print('Remote config fetch throttled: $exception');
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }

  RemoteConfigService({RemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;
  String get getSomething => _remoteConfig.getValue(_GetSomething).asString();

  Future _fetchAndActivate() async {
    await _remoteConfig.fetch();
    await _remoteConfig.activateFetched();
  }
}