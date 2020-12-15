import 'package:kiatsu/model/feedback_form.dart';
import 'package:http/http.dart' as http;
import 'package:sky_engine/convert/convert.dart' as convert;

class FromController {
  final void Function(String) callback;
  static const String URL =
      'https://script.google.com/macros/s/AKfycbzpNpfJbuhOTFHhTeNimzuiyubI9QBd2f6qpdiITsgYReSk2GzI/exec';
  static const STATUS_SUCCESS = 'SUCCESS';

  FromController(this.callback);

  void submitForm(FeedbackForm feedbackForm) async {
    try {
      await http.get(URL + feedbackForm.toParams()).then((response) {
        callback(convert.jsonDecode(response.body)['status']);
      });
    } catch (e) {
      print(e);
    }
  }
}
