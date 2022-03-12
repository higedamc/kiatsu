import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationPage extends ConsumerWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,  WidgetRef ref) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('通知'),
      ),
      body: const Center(
        child: Text('通知はありません'),
      ),
    );
  }
}
