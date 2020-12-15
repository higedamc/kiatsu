import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kiatsu/controller/controller.dart';
import 'package:kiatsu/model/feedback_form.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';

class GeneratePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<GeneratePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void _subimitForm() {
    if (_formKey.currentState.validate()) {
      FeedbackForm feedbackForm = FeedbackForm(
          nameController.text, timeController.text, statusController.text);
      FromController fromController = FromController((String response) {
        print("Response: $response");
        if (response == FromController.STATUS_SUCCESS) {
          _showSnackBar("送信されました");
        } else {
          _showSnackBar('エラーが発生しました＾q＾');
        }
      });
      _showSnackBar('送信しています');
      fromController.submitForm(feedbackForm);
    }
  }

  _showSnackBar(String message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: NeumorphiAppBar(
      //   title: Text('QRコードを生成します'),
      // ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5,
              child: ListTile(
                leading: Icon(Icons.edit),
                trailing: FlatButton(
                  child: Text(
                    "ENTER",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      dummyData = nameController.text == ""
                          ? null
                          : nameController.text;
                    });
                    // _subimitForm();
                  },
                ),
                title: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "登録する利用者名を入力してください",
                  ),
                ),
              ),
            ),
          ),
          (dummyData == null)
              ? Center(child: Text("QR生成するぜ"))
              : QrImage(
                  embeddedImage: AssetImage(
                    "assets/images/shisha.png",
                  ),
                  data: dummyData,
                  gapless: true,
                ),
        ],
      ),
    );
  }
}

String dummyData;

// TextEditingController qrTextController = TextEditingController();
