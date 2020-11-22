

import 'package:socimeet/models/event.dart';
import 'package:socimeet/models/user.dart';
/// Template for a generic channel
class Channel {

  Map<String,User> users; //unique UserId ==> will help us get boolean when added\ removed\ already in\ not signed
  List<Event> events;
  String channelName;
  int eventCount = 0;

  Channel({this.channelName,this.users,this.events});
}