import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IconSelectionPage extends ConsumerWidget {
  const IconSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('アイコン選択'),
      ),
      body: ListView(
        children: [
          Card(
            child: ListTile(
              title: const Text('アイコン1'),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
