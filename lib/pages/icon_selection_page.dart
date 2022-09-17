// import 'package:app_icon_changer/app_icon_changer.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiatsu/const/icon_selection_sentences.dart';
import 'package:kiatsu/controller/app_icon.dart';
import 'package:kiatsu/gen/assets.gen.dart';
import 'package:scaled_list/scaled_list.dart';

//TODO: 後でriverpod化するページ
class IconSelectionPage extends ConsumerWidget {
  const IconSelectionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: NeumorphicAppBar(
        title: const Text('アイコン選択'),
      ),
      body: Column(
        children: [
          ScaledList(
            itemCount: categories.length,
            itemColor: (index) {
              return kMixedColors[index % kMixedColors.length];
            },
            itemBuilder: (index, selectedIndex) {
              final category = categories[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: selectedIndex == index ? 100 : 80,
                    child: Image.asset(category.image),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    category.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: selectedIndex == index ? 25 : 20,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        if (selectedIndex == index) {
                          //Swiftでネイティブコード呼び出し
                          await AppIcon.setLauncherIcon(category.appIcon);
                        }
                      } on PlatformException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                          ),
                        );
                      }
                    },
                    child: const Center(
                      child: Text('OPEN'),
                    ),
                  )
                ],
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                welecomeMessage,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Color> kMixedColors = [
  const Color(0xff71A5D7),
  const Color(0xff72CCD4),
  const Color(0xffFBAB57),
  const Color(0xffF8B993),
  const Color(0xff962D17),
  const Color(0xffc657fb),
  const Color(0xfffb8457),
];

final List<Category> categories = [
  Category(
    image: Assets.images.face.path,
    title: 'Face',
    name: 'Face',
    appIcon: IconType.Face,
  ),
  Category(
      image: Assets.images.model.path,
      title: 'HIGECHANG',
      name: 'Model',
      appIcon: IconType.Model),
  Category(
      image: Assets.images.kiatsuLogoInvert.path,
      title: 'KIATSU',
      name: 'Normal',
      appIcon: IconType.Normal),
  // Category(image: 'assets/images/4.png', name: 'Lamb'),
  // Category(image: 'assets/images/5.png', name: 'Pasta'),
];

class Category {
  Category({required this.image, required this.name, required this.appIcon, required this.title});
  final String image;
  final String title;
  final String name;
  final IconType appIcon;
}
