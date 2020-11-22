import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socimeet/models/user.dart';

/// Extracting user data which is saved on firebase
class UserDatabaseService {
  final String uid;

  UserDatabaseService(
      {this.uid,
      String first_name,
      String last_name,
      String gender,
      String email});

  /// Collection  reference to our users collection
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

  /// Creating a user on firebase
  Future createUser(String emailAddress, String first_name, String last_name,
      String gender, Map<String, String> userEventsIdList) async {
    print("THIS IS USERCOLLECTION:  " +
        userCollection.document(uid).get().toString());
    return await userCollection.document(uid).setData({
      'emailAddress': emailAddress,
      'first_name': first_name,
      'last_name': last_name,
      'gender': gender,
      'userEventsIdList': userEventsIdList,
    });
  }

  /// Updating the userEventsIdList on firebase
  Future updateUserEvents(User user) async {
    //update the events of specific user in firebase
    try {
      print("now upadte..." + user.userEventsIdMap.toString());
      return await userCollection.document(user.uid).updateData({
        'userEventsIdList': user.userEventsIdMap,
      });
    } catch (e) {
      print("the user is not update" + e);
    }
  }
}
