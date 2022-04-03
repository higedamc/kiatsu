import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
// import 'package:flutter/material.dart';
import 'package:kiatsu/gen/assets.gen.dart';
import 'package:kiatsu/widget/page_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


//TODO: Riverpod化
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final currentUser = firebaseAuth.currentUser;


class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  // final List<String> _images = [
  //   'assets/images/onboarding/onboarding_1.png',
  //   'assets/images/onboarding/onboarding_2.png',
  //   'assets/images/onboarding/onboarding_3.png',
  // ];
  final controller = PageController();
  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            buildPage(
              color: Colors.white24,
               urlImage: (Device.get().hasNotch) ? Assets.onboX.path : Assets.onbo8.path, title: 'シンプル', subtitle: '使い方は簡単！起動したら気圧の状況が一目でわかります', textColor: Colors.black),
            buildPage(
              color: Colors.white24, urlImage: Assets.onbo2Fixed.path, title: 'つながる', subtitle: '今の気分や体調をシェアして、匿名で他の人とつながることができます', textColor: Colors.black87),
            Container(
                color: Colors.white24,
                child: Center(child: Image.asset(Assets.images.face.path))),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                // primary: Colors.white,
                backgroundColor: Colors.white,
                minimumSize: const Size.fromHeight(80),
              ),
              onPressed: () async {
                await Navigator.pushReplacementNamed(context, '/home');
              },
              child: const Text(
                'さぁ、はじめましょう',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            )
          : Container(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () => controller.jumpToPage(2),
                      child: const Text('SKIP')),
                  Center(
                    child: SmoothPageIndicator(
                      controller: controller,
                      count: 3,
                      effect: const WormEffect(
                        spacing: 16,
                        dotColor: Colors.black26,
                        activeDotColor: Colors.black,
                      ),
                      onDotClicked: (index) => controller.animateToPage(index,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn),
                    ),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () => controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut),
                      child: const Text('NEXT')),
                ],
              ),
            ),
    );
  }
}
