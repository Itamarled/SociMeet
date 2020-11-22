import 'package:cloud_firestore/cloud_firestore.dart';

/// Template for a generic user
class User {
  final String uid;
  final String emailAddress;
  final String first_name;
  final String last_name;
  final String gender;
  Map<String, dynamic> userEventsIdMap;
  final DocumentReference reference;

  User(
      {this.uid,
      this.emailAddress,
      this.first_name,
      this.last_name,
      this.gender,
      this.reference}); //the constructor for user

  /// Pulling user relevant data from firebase and updating user fields
  User.fromMap(Map<String, dynamic> map, String _uid, {this.reference})
      : assert(map['first_name'] != null),
        assert(map['emailAddress'] != null),
        assert(map['last_name'] != null),
        assert(map['gender'] != null),
        assert(map['userEventsIdList'] != null),
        uid = _uid,
        emailAddress = map['emailAddress'],
        first_name = map['first_name'],
        last_name = map['last_name'],
        gender = map['gender'],
        userEventsIdMap = map['userEventsIdList'];

  /// Sending the data map to fromMap function
  User.fromSnapshot(DocumentSnapshot snapshot, String user_uid)
      : this.fromMap(snapshot.data, user_uid, reference: snapshot.reference);
}
