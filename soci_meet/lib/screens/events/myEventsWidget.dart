import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socimeet/models/chanel.dart';
import 'package:socimeet/models/event.dart';
import 'package:socimeet/models/user.dart';

import '../events/EventInfo.dart';

/// myEvents screen
class myEventsWidget extends StatefulWidget {
  final User login_user;
  final Channel channel;

  myEventsWidget(this.login_user, this.channel);

  @override
  myEventsState createState() => myEventsState();
}

class myEventsState extends State<myEventsWidget> {
  List<Event> _events = [];

  /// Event card
  Widget EventcardTemplate(Event eve) {
    return Card(
        color: Colors.white.withOpacity(0.7),
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    eve.address,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  FlatButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EventInfoWidget(eve, widget.login_user,widget.channel)));
                    },
                    icon: Icon(Icons.info),
                    label: Text(''),
                  )
                ],
              ),

              // SizedBox(height: 2.0),
              Text(
                eve.creator,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 6.0),
              Row(
                children: [
                  Text(
                      '${eve.date.toString().substring(0, eve.date.toString().indexOf(' '))}'),
                  SizedBox(width: 50.0),
                  Text(
                      '${eve.date.toString().substring(eve.date.toString().indexOf(' ') + 1, (eve.date.toString().length - 7))}'),
                ],
              ),

              Text(
                '${eve.counter} / ${eve.numberOfParticipants}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: (eve.counter == eve.numberOfParticipants)
                      ? Colors.red[900]
                      : Colors.greenAccent,
                ),
              ),
            ],
          ),
        ));
  }

  /// _buildEventsList is used to get the events from firebase
  ///
  ///  Here userEventsList will be filled accordingly
  void _buildEventsList(BuildContext context, List<DocumentSnapshot> snapshot,
      User user, String channelName) {
    _events.addAll(snapshot.map((data) {
      final Event event = Event.fromSnapshot(data);
      print("this is event " + event.toString());
      return event;
    }).toList());
    print("\n\n\nThis is the userEvent list len\n" + _events.length.toString());
    for (int i = 0; i < _events.length; i++) {
      if (user.userEventsIdMap[channelName] != null &&
          !user.userEventsIdMap[channelName].contains(_events[i].eventId)) {
        _events.remove(_events[i]);
        i--;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('Channels')
            .document(widget.channel.channelName)
            .collection('Events')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return LinearProgressIndicator();
          else {
            _buildEventsList(context, snapshot.data.documents,
                widget.login_user, widget.channel.channelName);
            return SafeArea(
              bottom: false,
              child: Scaffold(
                backgroundColor: Colors.grey[200],
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey[300],
                  title: Text(widget.login_user.first_name +
                      " events from " +
                      widget.channel.channelName +
                      " channel"),
                  centerTitle: true,
                  elevation: 0,
                ),
                body: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFCCBF),
                    image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.83), BlendMode.dstATop),
                      image: AssetImage("assets/"+widget.channel.channelName+".jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 4.0),
                          child: Column(
                            children: _events
                                .map((eve) => EventcardTemplate(eve))
                                .toList(),
                          ),
                        );
                      }),
                ),
              ),
            );
          }
        });
  }
}
