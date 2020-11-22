import 'package:flutter/material.dart';
import 'package:socimeet/models/chanel.dart';
import 'package:socimeet/models/user.dart';
import 'package:socimeet/services/auth.dart';
import 'package:socimeet/services/userDatabase.dart';
import 'package:socimeet/models/event.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class EventForm extends StatefulWidget {
  final User user;
  List<Event> _events;
  bool isValid = false;
  final Channel channel;
  DateTime date;
  String numberOfParticipants;
  String address;
  String eventId;

  EventForm(this.channel, this.user, this._events, this.date,this.numberOfParticipants,this.address,this.eventId);

  /// add event id to the user map
  void updateUserEventsIdMap(User user, String channelName, String eventId) {
    if (user.userEventsIdMap.containsKey(channelName)) {
      //adding event id to map if the channel exist
      user.userEventsIdMap.update(channelName, (value) {
        if(!value.contains(eventId))
          value.add(eventId);
        return value;
      });
    } else
      // adding key + eventId to map
      user.userEventsIdMap.addAll({
        channelName: [eventId]
      });
  }

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  int counter = 1; //how many users are registered

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),

          /// Add event form
          Form(
            key: _formKey, // keep track to our form, for validate.
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20.0),
                // Address form field
                TextFormField(
                  initialValue:widget.address ,
                  validator: (val) => val.isEmpty ? "enter Address" : null,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Address"),
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                  onChanged: (val) {
                    _formKey.currentState.save();
                    setState(() {
                      widget.address = val;
                    });
                  },
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                DateTimeField(
                    initialValue:widget.date ,
                    format: DateFormat("yyyy-MM-dd 'At' HH:mm"),
                    onShowPicker: (context, currentValue) async {
                      widget.date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      if (widget.date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              currentValue ?? DateTime.now()),
                        );
                        return DateTimeField.combine(widget.date, time);
                      } else {
                        return currentValue;
                      }
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(20.0),
                          borderSide: new BorderSide(),
                        ),
                        labelText: "Date"),
                    onChanged: (dt) {
                      _formKey.currentState.save();
                      setState(() {
                        widget.date = dt;
                      });
                    }),
                new Padding(padding: EdgeInsets.all(8.0)),
                // Number of participants form field
                TextFormField(
                  initialValue:widget.numberOfParticipants ,
                  validator: (val) => numberValidator(val),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(20.0),
                        borderSide: new BorderSide(),
                      ),
                      labelText: "Number of participants"),
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                  onChanged: (val) {
                    final form = _formKey.currentState;
                    if (form.validate())
                      widget.isValid =
                          true; // TODO this only works correctly when user fill fields from top to bottom, need to find a better way to do it
                    setState(() {
                      widget.numberOfParticipants = val;
                    });
                  },
                ),
                new Padding(padding: EdgeInsets.all(8.0)),

                /// Press this and an event will be added
                RaisedButton(
                    color: widget.isValid ? Colors.blue : Colors.pink[52],
                    child: Text(
                      widget.eventId !=null?'Update event':'Add event',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      final form = _formKey.currentState;
                      form.save();
                      if (form.validate()) //will check if our from is legit
                      {
                        widget.isValid = true;
                        if(widget.eventId == null)
                          widget.eventId = UniqueKey().toString();
                        Navigator.pop(context);


                        print(
                            "this is the event list of the user before update" +
                                widget.user.userEventsIdMap.toString());
                        dynamic result = _auth.createChannel(
                            widget.date,
                            widget.numberOfParticipants,
                            widget.user,
                            widget.address,
                            widget.channel,
                            widget.eventId);
                        widget.updateUserEventsIdMap(
                            widget.user, widget.channel.channelName, widget.eventId);
                        UserDatabaseService()
                            .updateUserEvents(widget.user); //update in database
                        widget.channel.eventCount++;
                      }
                    }),
                SizedBox(height: 12.0),
              ],
            ),
          )
        ],
      ),
    );
  }
}

String numberValidator(String value) {
  if (value == null) {
    return null;
  }
  final n = num.tryParse(value);
  if (n == null) {
    return '"$value" is not a valid number';
  }
  return null;
}
