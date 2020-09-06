import 'package:flutter/material.dart';
import 'package:kiatsu/services/remote_config_service.dart';

import '../locator.dart';

class BaseModel extends ChangeNotifier {
  final RemoteConfigService _remoteConfigService = locator<RemoteConfigService>();
  String get getSomething => _remoteConfigService.getSomething;
}