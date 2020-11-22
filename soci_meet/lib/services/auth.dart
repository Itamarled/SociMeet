import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:socimeet/models/chanel.dart';
import 'package:socimeet/models/user.dart';
import 'package:socimeet/services/userDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:socimeet/services/channelsDB.dart';

class AuthService {
  User _currentUser;

  User get currentUser => _currentUser;

  final FirebaseAuth _auth = FirebaseAuth
      .instance; //singeltone of the firebase aut h object. to get all data from firebase
  final CollectionReference userCollection =
      Firestore.instance.collection('users');

/// create user object based on firebase object
  User _userFromFirebaseUser(
      FirebaseUser user, String first_name, String last_name, String gender) {
    // create our user from the the firebase instance user, we want to get te functionality of the user.
    return user != null
        ? User(
            uid: user.uid,
            emailAddress: user.email,
            first_name: first_name,
            last_name: last_name,
            gender: gender)
        : null;
  }

//auth change user stream
  Stream<User> get user {
    // going to return as User object was stream, and who logs in. with that info we can know how to navigate him
    return _auth.onAuthStateChanged
        .map((FirebaseUser user) => _userFromFirebaseUser(user, " ", "", ""));
  }

  ///register with email and password
  Future registerWithEmailAndPassword(
      String email,
      String Password,
      String first_name,
      String last_name,
      String gender,
      Map<String, String> userEventsIdList) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: Password);
      FirebaseUser user = result.user;

      /// create Document for user database.
      await UserDatabaseService(
              uid: user.uid,
              email: email,
              first_name: first_name,
              last_name: last_name,
              gender: gender)
          .createUser(
              email, first_name, last_name, gender, userEventsIdList);

      /// sign the user document to get his data.
      User appUser = _userFromFirebaseUser(user, first_name, last_name, gender);
      return appUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  ///sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      print("THIS IS FIREBASE USER: " + user.toString());
      User appUser = _userFromFirebaseUser(user, "", "", "");
      return appUser;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //TODO add register with facebook account

  //TODO add register with google account

  ///sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print("bad error");
      print(e.toString());
      return null;
    }
  }

  /// Creating an event
  Future createChannel(DateTime dateTime, String numberOfParticipants,
      User creator, String address, Channel channel, String index) async {
    try {
      return await ChannelsDatabaseServices().createEvent(
          dateTime,
          numberOfParticipants,
          creator,
          address,
          channel.channelName,
          index,
          1,
          creator.uid, []);
    } catch (e) {
      print(e);
    }
  }
}
