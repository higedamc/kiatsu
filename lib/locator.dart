import 'package:get_it/get_it.dart';
import 'package:kiatsu/services/remote_config_service.dart';

GetIt locator = GetIt.instance;

Future setupLocator() async {
  var remoteConfigService = await RemoteConfigService.getInstance();
  locator.registerSingleton(remoteConfigService);
}