import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socimeet/models/chanel.dart';
import 'package:socimeet/models/event.dart';
import 'package:socimeet/models/user.dart';
import 'addEventForm.dart';
import '../events/EventInfo.dart';

/// Channel screen
class ChannelWidget extends StatefulWidget {
  User login_user;
  final Channel channel;

  ChannelWidget(this.login_user, this.channel);

  @override
  ChannelState createState() => ChannelState();
}

class ChannelState extends State<ChannelWidget> {
  /// Contains events from firebase based on current channel
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
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EventInfoWidget(
                                  eve, widget.login_user, widget.channel)));
                    },
                    icon: Icon(Icons.info),
                    tooltip: "Event information",
                  ),
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

  /// Update _events so it will hold the current events
  void _buildEventsList(BuildContext context, List<DocumentSnapshot> snapshot) {
    _events = snapshot.map((data) {
      final event = Event.fromSnapshot(data);
      return event;
    }).toList();
    for (int i = 0; i < _events.length; i++) {
      /// Removes events one day after they are over from the DB
      if (_events[i].date.day.compareTo(DateTime.now().day + 1) < 0 &&
          _events[i].date.month.compareTo(DateTime.now().month) == 0 &&
          _events[i].date.year.compareTo(DateTime.now().year) == 0) {
        Firestore.instance
            .collection('Channels')
            .document(widget.channel.channelName)
            .collection('Events')
            .document(_events[i].eventId)
            .delete();
        _events.remove(i);
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
            _buildEventsList(context, snapshot.data.documents);
            return SafeArea(
              bottom: false,
              child: Scaffold(
                backgroundColor: Colors.grey[200],
                appBar: AppBar(
                  backgroundColor: Colors.blueGrey[300],
                  title: Text(widget.channel.channelName),
                  centerTitle: true,
                  elevation: 0,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    var alertDialog = AlertDialog(
                      title: Text("Add Event"),
                      content: EventForm(widget.channel, widget.login_user,
                          _events, null, "", "", null),
                    );
                    showDialog(context: context, builder: (_) => alertDialog);
                  },
                  child: Icon(Icons.add),
                ),
                body: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFFCCBF),
                    image: DecorationImage(
                      colorFilter: new ColorFilter.mode(
                          Colors.black.withOpacity(0.83), BlendMode.dstATop),
                      image: AssetImage(
                          "assets/" + widget.channel.channelName + ".jpg"),
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
