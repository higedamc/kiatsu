class Users {
  String uid;
  DateTime createdAt;

  Users({this.uid, this.createdAt});

  Map toMap(Users user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['createdAt'] = user.createdAt;
    return data;
  }

  Users.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.createdAt = mapData['createdAt'];
  }
}
