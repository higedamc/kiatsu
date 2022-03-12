import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(size);
    final width = size.width;
    final height = size.height;
    final currentWidth = width / 100;
    final currentHeight = height / 100;
    var changedWidth = currentWidth * 73;
    var changedHeight = currentHeight * 73;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
      ),
      body: Stack(
        children: [
          Positioned(
            top: currentHeight * 60,
            left: currentWidth * 75,
            child: Container(
              color: Colors.blue,
            
              child: Lottie.asset('assets/json/arrow_down_bounce.json',
                      width: 100,
                      height: 100,
                      ),
            ),
          ),
          Positioned(
            left: changedWidth,
            top: changedHeight,
              child: Container(
                child: Text('$changedWidth + $changedHeight'),
            color: Colors.red,
            width: 100,
            height: 100,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
