class FeedbackForm {
  String _name;
  String _time;
  String _status;

  FeedbackForm(this._name, this._time, this._status);

  String toParams() => "?name=$_name&time=$_time&status=$_status"; 
}