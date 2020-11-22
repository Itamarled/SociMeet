import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:socimeet/models/chanel.dart';
import 'package:socimeet/models/event.dart';
import 'package:socimeet/models/user.dart';
import 'package:socimeet/services/userDatabase.dart';

class ChannelsDatabaseServices {
  final String cid;


  ChannelsDatabaseServices({ this.cid });

  final CollectionReference channelCollection = Firestore.instance.collection(
      'Channels');

/// Updating an event after a user joins or leaves the event
  Future updateEvent(String channelName, String eventId, int counter, String uid, List<dynamic>userList) async {
    final eventsCollection = channelCollection.document(channelName).collection('Events');
    return await eventsCollection.document(eventId).updateData({
      'counter' : counter,
      'userList': userList,
    });
  }

  /// Creating a new event in a specific channel
  Future createEvent(DateTime dateTime, String numberOfParticipants, User creator,String address,String channelName, String index, int counter, String uid, List<dynamic>userList) async {
    final eventsCollection = channelCollection.document(channelName).collection('Events');
    userList.add(uid);
    return await eventsCollection.document(index).setData({
      'address': address,
      'creator': creator.first_name+" "+ creator.last_name,
      'creator_id' : creator.uid,
      'date': dateTime,
      'numberOfParticipants': numberOfParticipants,
      'counter' : counter,
      'userList': userList,
      'eventId' : index,
      'channelName' : channelName,
    });
  }
}


























/*
//Collection Reference
  final CollectionReference eventsCollection = Firestore.instance.collection(
      'Events');

// Creating an event
  Future createEvent(DateTime dateTime, int numberOfParticipants, User creator,
       String address,String index) async {
    print("THIS IS THE CREATOR: "+ creator.first_name);
    return await eventsCollection.document(index).setData({
      'address': address,
      'creator': creator.first_name,
      'date': dateTime,
      'n_o_f': numberOfParticipants,
      'userList': [creator.uid,],
    });
  }*/
