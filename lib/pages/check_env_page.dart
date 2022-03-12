import 'dart:io' show Platform;

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';



class CheckEnvPage extends StatelessWidget {
  const CheckEnvPage({Key? key}) : super(key: key);
  
  

  Future<PackageInfo> _getPackageInfo() {
    return PackageInfo.fromPlatform();
  }

  @override
  Widget build(BuildContext context) {
  // String? dartDefineMode = Platform.environment['DART_DEFINE_MODE'];
  const dartDefineMode = String.fromEnvironment('DART_DEFINE_MODE', defaultValue: 'null');
  const appIdSuffix = String.fromEnvironment('APP_ID_SUFFIX', defaultValue: 'null');
  const profile = String.fromEnvironment('APP_PROVISIONING_PROFILE_SPECIFIER', defaultValue: 'null');


    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('通知'),
      ),
      body: Center(
        child: FutureBuilder<PackageInfo>(
            future: _getPackageInfo(),
            builder:
                (BuildContext context, AsyncSnapshot<PackageInfo> snapshot) {
              if (snapshot.hasError) {
                return const Text('ERROR');
              } else if (!snapshot.hasData) {
                return const Text('Loading...');
              }
              final data = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('App Name: ${data?.appName}'),
                  Text('Package Name: ${data?.packageName}'),
                  Text('Version: ${data?.version}'),
                  Text('Build Number: ${data?.buildNumber}'),

                  const Text('Mode is: $dartDefineMode'),
                  const Text('App id suffix is: $appIdSuffix'),
                  const Text ('Profile is: $profile'),
                ],
              );
            }),
      ),
    );
  }
}
