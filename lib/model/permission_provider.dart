import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/repository/permission_repository.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionProvider {
  PermissionProvider({
    this.isGranted = true,
  });
  final bool isGranted;
}

late final PermissionRepository _permissionRepository;

class PermissionNotifier extends StateNotifier<PermissionProvider> {
  PermissionNotifier() : super(PermissionProvider());

  // void enabler() {
  //   state = PermissionProvider(isGranted: state.isGranted);
  // }
  Future<void> handlePermission() async {
    _permissionRepository.handlePermission();
    state = state..isGranted;
  } 
}

final permissionsProvider = StateNotifierProvider<PermissionNotifier, PermissionProvider>((ref) {
  return PermissionNotifier() ;
});