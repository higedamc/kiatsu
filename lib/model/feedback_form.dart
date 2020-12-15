class FeedbackForm {
  String _name;
  String _time;
  // String _status;

  FeedbackForm(this._name, this._time);

  String toParams() => "?name=$_name&time=$_time"; 
}