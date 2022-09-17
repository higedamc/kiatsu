import 'package:flutter_dotenv/flutter_dotenv.dart';

class DevIds {
  String get dev1 => dotenv.env['DEV_ID_1'].toString();
  String get dev2 => dotenv.env['DEV_ID_2'].toString();
  String get dev3 => dotenv.env['DEV_ID_3'].toString();
  String get dev4 => dotenv.env['DEV_ID_4'].toString();
}
