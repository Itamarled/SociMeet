

import 'package:socimeet/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Template for a generic channel
class Event {
  DateTime date = DateTime.now();
  String numberOfParticipants;
  String creator;
  String creator_id;
  int counter = 1; //how many registered
  String address;
  String eventId;
  String channelName;
  List<dynamic> userList;
  final DocumentReference reference;


  Event(
      {this.date, this.numberOfParticipants, this.address, this.creator,this.creator_id, this.eventId, this.reference,this.channelName});
  /// Pulling event related data from firebase
  ///
  /// Using fromSnapshot to receive the correct map for the data
  Event.fromMap(Map<String, dynamic> map, {this.reference}):
        assert(map['date'] != null),
        assert(map['numberOfParticipants'] != null),
        assert(map['creator'] != null),
        assert(map['counter'] != null),
        assert(map['address'] != null),
        assert(map['eventId'] != null),
        assert(map['creator_id'] != null),
        assert(map['channelName'] != null),
        assert(map['userList'] != null),

        date = DateTime.fromMicrosecondsSinceEpoch(map['date'].microsecondsSinceEpoch),
        numberOfParticipants = map['numberOfParticipants'],
        creator = map['creator'],
        counter = map['counter'],
        creator_id = map['creator_id'],
        address = map['address'],
        eventId = map['eventId'],
        channelName = map['channelName'],
        userList = map['userList'];

  /// Sending the data map from firebase to FromMap
  Event.fromSnapshot(DocumentSnapshot snapshot) :
        this.fromMap(snapshot.data, reference: snapshot.reference);

  /// Updating the Event field based on data from firebase
  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'numberOfParticipants': numberOfParticipants,
      'creator': creator,
      'counter': counter,
      'creator_id': creator_id,
      'address': address,
      'eventId': eventId,
      'channelName' : channelName,
    };
  }
}

