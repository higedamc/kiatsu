import 'package:cloud_firestore/cloud_firestore.dart';

class PienDo {
  final String pienDo;
  final int votes;
  final DocumentReference reference;

  PienDo.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['pien_do'] != null),
        assert(map['votes'] != null),
        pienDo = map['pien_do'],
        votes = map['votes'];

  PienDo.fromSnapshot(DocumentSnapshot snaps)
      : this.fromMap(snaps.data(), reference: snaps.reference);

  @override
  String toString() => "Record<$pienDo:$votes>";
}