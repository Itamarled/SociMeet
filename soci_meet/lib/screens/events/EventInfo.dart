import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socimeet/models/chanel.dart';
import 'package:socimeet/models/event.dart';
import 'package:socimeet/models/user.dart';
import 'package:socimeet/screens/channel/addEventForm.dart';
import 'package:socimeet/screens/channel/addEventForm.dart';
import 'package:socimeet/services/channelsDB.dart';
import 'package:socimeet/services/userDatabase.dart';

showAlertDialog(BuildContext context, String msg) {
  // set up the buttons
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Message"),
    content: Text(msg),
    actions: [okButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

/// Info widget
///
/// Users can join events which they are not subscribed to
/// Users can leave events which they are subscribed to
// ignore: must_be_immutable
class EventInfoWidget extends StatefulWidget {
  Event myEvent;
  Channel channel;
  // ignore: non_constant_identifier_names
  User login_user;

  EventInfoWidget(Event myEvent, User login_user,Channel channel) {
    this.myEvent = myEvent;
    this.login_user = login_user;
    this.channel = channel;
  }

  @override
  _State createState() => _State(myEvent);
}

class _State extends State<EventInfoWidget> {
  Event myEvent;
  bool isJoined = false;

  _State(Event myEvent) {
    this.myEvent = myEvent;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey[300],
        actions: [
          creatorEventDelete(widget.login_user, myEvent),
          userUnsubscribeEvent(widget.login_user, myEvent),
          creatorUpdateEvent(widget.login_user, myEvent),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFFCCBF),
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.83), BlendMode.dstATop),
            image: AssetImage("assets/"+widget.channel.channelName+"2.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white.withOpacity(0.7),
            margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 280),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Text(
                        'Creator: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(myEvent.creator, style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  Row(
                    children: [
                      Text('Date: ', style: TextStyle(fontSize: 20)),
                      Text(
                          '${myEvent.date.toString().substring(0, myEvent.date.toString().indexOf(' '))}',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  Row(
                    children: [
                      Text('Time: ', style: TextStyle(fontSize: 20)),
                      Text(
                          '${myEvent.date.toString().substring(myEvent.date.toString().indexOf(' '), myEvent.date.toString().length - 7)}',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  Row(
                    children: [
                      Text('Address: ', style: TextStyle(fontSize: 20)),
                      Text('${myEvent.address}', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  Row(
                    children: [
                      Text('Number of participants: ${myEvent.counter}/',
                          style: TextStyle(fontSize: 20)),
                      Text('${myEvent.numberOfParticipants}',
                          style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  SizedBox(
                    height: 65,
                  )
                ],
              ),
            ),
          ),
        ),
      ),

      /// Join button
      ///
      /// User can join events by using this button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (int i = 0; i < myEvent.userList.length; i++) {
            if (widget.login_user.uid == myEvent.userList[i]) {
              isJoined = true;
            }
          }
          if (!isJoined) {
            if (myEvent.counter < int.parse(myEvent.numberOfParticipants)) {
              setState(() {
                myEvent.counter++;
                myEvent.userList.add(widget.login_user.uid);
                EventForm(null, null, null, null, null, null, null)
                    .updateUserEventsIdMap(
                        widget.login_user,
                        myEvent.channelName,
                        myEvent.eventId); //add to event id map
                ChannelsDatabaseServices().updateEvent(
                    myEvent.channelName,
                    myEvent.eventId,
                    myEvent.counter,
                    widget.login_user.uid,
                    myEvent
                        .userList); //update event in firebase + update eventUserList
                UserDatabaseService().updateUserEvents(
                    widget.login_user); //update in database the event id map
              });
              isJoined = true;
              showAlertDialog(context, "You have joined this event, have fun!");
            } else {
              showAlertDialog(context, "This event is already full!");
            }
          } else {
            showAlertDialog(
                context,
                widget.login_user.first_name +
                    " you are already a part of this event");
          }
        },
        child: Text('join'),
      ),
    );
  }

  /// delete event id from user events map
  // TODO add deleting from all users subscribing to this event, currently only deleting from the event creator.
  void deleteEventFromUserEventsMap(
      User user, String channelName, String eventId) {
    user.userEventsIdMap.forEach((key, value) {
      if (value.contains(eventId)) {
        value.remove(eventId);
        return;
      }
    });
  }

  /// Event deletion
  ///
  /// If you are the creator the event will be deleted
  // TODO add warning about deleting\unsubscribe so a user can confirm his decision
  Widget creatorEventDelete(User user, Event event) {
    // If I am the creator, delete the event
    if (user.uid == event.creator_id) {
      return Tooltip(
        message: "Delete Event",
        child: FlatButton.icon(
            icon: Icon(Icons.delete),
            onPressed: () async {
              event.userList.map((uid) {
                //for each user in this event, delete the event id from its map in the database
                Future<User> user = Firestore.instance
                    .collection('users')
                    .document(uid)
                    .get()
                    .then((doc) => User.fromSnapshot(doc, uid));
                user.then((userFuture) => deleteEventFromUserEventsMap(
                    userFuture, event.channelName, event.eventId));
                user.then((userFuture) =>
                    UserDatabaseService().updateUserEvents(userFuture));
              });
              deleteEventFromUserEventsMap(
                  user, event.channelName, event.eventId);
              UserDatabaseService().updateUserEvents(user);
              Firestore.instance
                  .collection('Channels')
                  .document(event.channelName)
                  .collection('Events')
                  .document(event.eventId)
                  .delete();
              Navigator.pop(context);
            },
            label: Text("")),
      );
    }

    return Text("");
  }

  /// User unSubscribes from an event.
  Widget userUnsubscribeEvent(User user, Event event) {
    // if this user subscribed to this event and he is not the creator
    if (event.userList.contains(user.uid) && event.creator_id != user.uid) {
      return Tooltip(
        message: "Unsubscribe",
        child: FlatButton.icon(
            onPressed: () async {
              setState(() {
                event.counter--;
                event.userList.remove(user.uid);
                deleteEventFromUserEventsMap(
                    user, event.channelName, event.eventId);
                ChannelsDatabaseServices().updateEvent(event.channelName,
                    event.eventId, event.counter, user.uid, event.userList);

                ///Update this event on firebase
                UserDatabaseService().updateUserEvents(user);

                ///Updates the user event id list
              });
              showAlertDialog(context, "You have unsubscribed from this event");
            },
            icon: Icon(Icons.cancel),
            label: Text(" ")),
      );
    }
    return Text(" ");
  }

  Widget creatorUpdateEvent(User user, Event event) {
    // if I'm the creator I can update my event
    if (user.uid == event.creator_id) {
      return Tooltip(
        message: "Update event",
        child: FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection("Channels").document(event.channelName).collection("Events").document(event.eventId).get(),
          builder: (context, snapshot) {
            return FlatButton.icon(
                onPressed: () async{
                  int counter = event.counter;
                  List<dynamic> eventUserList = event.userList;
                  setState(()  {
                    var alertDialog =AlertDialog(
                        title: Text("Update Event"),
                        content:EventForm(widget.channel, user, null, event.date, event.numberOfParticipants,
                            event.address, event.eventId)
                    );
                    ChannelsDatabaseServices().updateEvent(
                        event.channelName, event.eventId, counter, user.uid, eventUserList);
                    myEvent = Event.fromSnapshot(snapshot.data);// TODO fix - the new data is not displaying on the page, only when returning to it.
                    showDialog(context: context, builder: (_) => alertDialog);
                  });
                },
                icon: Icon(Icons.save),
                label: Text(" "));
          }
        )
      );
    }
    else{
      return Text(" ");
    }
  }
}
