import 'package:flutter/material.dart';

import 'custom_dialog_box.dart';

class Dialogs extends StatefulWidget {
  const Dialogs({Key? key}) : super(key: key);

  @override
  _DialogsState createState() => _DialogsState();
}

class _DialogsState extends State<Dialogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Dialog In Flutter'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: ElevatedButton(
            onPressed: (){
              showDialog(context: context,
                builder: (BuildContext context){
                return CustomDialogBox(
                  title: 'Custom Dialog Demo',
                  descriptions: 'Hii all this is a custom dialog in flutter and  you will be use in your flutter applications',
                  text: 'Yes', key: UniqueKey(),
                );
                }
              );
            },
          child: const Text('Custom Dialog'),

        ),
      ),
    );
  }
}