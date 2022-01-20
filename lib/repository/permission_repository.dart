import 'package:permission_handler/permission_handler.dart';

abstract class PermissionRepository {
  Future<bool> handlePermission();
  // Future getPermission();
}

class PermissionRepositoryImpl implements PermissionRepository {

  // Map<Permission, PermissionStatus>
  // @override
  // Future getPermission() async {
  //   if (isGranted) {
  //     return true;
  //   } else {
  //     final status = await permission.request();
  //     return status == PermissionStatus.granted;
  //   }
  // }

  @override
  Future<bool> handlePermission() async {
    // TODO: implement handlerPermission
    // final status = await Permission.locationAlways.request();
    // // // status.isGranted ? print('Permission granted') : print('Permission denied');
    // if(status.isGranted) {
    //   print(status.toString());
    //   return true;
    // }
    // else {
    //   print(status.toString());
    //   return false;
    // }
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
    ].request();
    print(statuses);
    if (statuses[Permission.location] == PermissionStatus.granted &&
        statuses[Permission.locationAlways] == PermissionStatus.granted &&
        statuses[Permission.locationWhenInUse] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
    // statuses.forEach((key, value) {
    //   print('$key: $value');
    //   if (value.isGranted) {
    //     // return isGranted(true);
    //   } else {
    //     print('Permission denied');
    //   }
    // });
    // if (statuses[Permission.location] == Permission.) {
    //   return isGranted;
    // } else {
    //   print('Permission denied');
    // }
  }
}
