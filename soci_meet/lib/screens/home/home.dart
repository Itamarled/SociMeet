//import 'dart:html';

import 'package:socimeet/constants.dart';
import 'package:socimeet/models/user.dart';
import 'package:socimeet/screens/events/EventInfo.dart';
import 'package:socimeet/screens/events/myEventsWidget.dart';
import 'package:socimeet/services/auth.dart';
import 'package:socimeet/screens/home/HomeManagment.dart';
import 'package:flutter/material.dart';
import 'package:socimeet/models/chanel.dart';
import 'package:socimeet/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/chanel.dart';
import '../channel/channel.dart';

/// HomePage of the app,here you can roam between channels

class Home extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final User login_user;

  const Home(this.login_user);

  User getUser() {
    return login_user;
  }

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  final AuthService _auth = AuthService();

  /// uList is a map. key = channelName, value = list of subscribed users
  static Map<String, User> ulist = {};

  /// Hardcoded channels
  static Channel parties =
      Channel(channelName: "Parties", users: ulist, events: userEventsList);
  static Channel shabatDinner = Channel(
      channelName: "Shabat Dinner", users: ulist, events: userEventsList);
  static Channel sport =
      Channel(channelName: "Sport Games", users: ulist, events: userEventsList);
  static List<Channel> arrayChannels = [parties, shabatDinner, sport];

  /// userEventList contains the events which the user is currently subscribed to
  static List<Event> userEventsList = [];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double channelHeight = size.height * 0.30;
    User _user = widget.login_user;
    return StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(_user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return LinearProgressIndicator();
          } else {
            _user = User.fromSnapshot(snapshot.data, _user.uid);
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text(
                  "SociMeet",
                  style: Theme.of(context).textTheme.display1,
                ),
                actions: <Widget>[
                  FlatButton.icon(
                      onPressed: () async {
                        await _auth.signOut();

                        /// This will set the providers user to null and we'll take as back to the login home page
                      },
                      icon: Icon(Icons.person),
                      label: Text("Out")),
                ],
              ),
              body: Container(
                height: size.height,
                decoration: BoxDecoration(
                  color: Color(0xFFFFCCBF),
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.83), BlendMode.dstATop),
                    image: AssetImage("assets/friends1.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Welcome " + _user.first_name + "!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontSize: 40),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "     Channels",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),

                    /*const SizedBox(
                height: 5,
              ),*/
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: 0.8,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: size.width,
                        alignment: Alignment.topCenter,
                        height: channelHeight,
                        child: ChannelsCategoriesScroller(_user, arrayChannels),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    Text(
                      "     My Events",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Flexible(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: 0.8,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: size.width,
                            alignment: Alignment.topCenter,
                            height: channelHeight,
                            child: UserEventsCategoriesScroller(
                                _user, arrayChannels),
                          ),
                        ),
                        flex: 5)
                  ],
                ),
              ),
            );
          }
        });
  }
}

/// Our channels in a scroller format
///
/// login_user holds our current user
/// arrayChannels holds all of our existing channels
class ChannelsCategoriesScroller extends StatelessWidget {
  final User login_user;
  final List<Channel> arrayChannels;

  const ChannelsCategoriesScroller(this.login_user, this.arrayChannels);

  @override
  Widget build(BuildContext context) {
    final double categoryHeight =
        MediaQuery.of(context).size.height * 0.30 - 50;
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChannelWidget(login_user, arrayChannels[0])))

                    /// Creates our channel Widget
                    // TODO need to change it so we won't hardcode the index of the arrayChannels
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 20),
                    height: categoryHeight,
                    decoration: BoxDecoration(
                        color: Colors.orange[600],
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Parties ",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("Channels")
                                  .document(arrayChannels[0].channelName)
                                  .collection("Events")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return LinearProgressIndicator();
                                else {
                                  return Text(
                                    snapshot.data.documents.length.toString() +
                                        " Available Events",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChannelWidget(login_user, arrayChannels[1])))
                    // TODO need to change it so we won't hardcode the index of the arrayChannels
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 20),
                    height: categoryHeight,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Shabat Dinner ",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection("Channels")
                                    .document(arrayChannels[1].channelName)
                                    .collection("Events")
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return LinearProgressIndicator();
                                  else {
                                    return Text(
                                      snapshot.data.documents.length.toString() +
                                          " Available Events",

                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    );
                                  }
                              }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ChannelWidget(login_user, arrayChannels[2])))
                    // TODO need to change it so we won't hardcode the index of the arrayChannels
                  },
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(right: 20),
                    height: categoryHeight,
                    decoration: BoxDecoration(
                        color: Colors.pink.shade600,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Sport Games",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("Channels")
                                  .document(arrayChannels[2].channelName)
                                  .collection("Events")
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return LinearProgressIndicator();
                                else {
                                  return Text(
                                    snapshot.data.documents.length.toString() +
                                        " Available Events",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                  );
                                }
                              }
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

/// CategoriesScroller to choose from which channel we will display the events on the home screen
class UserEventsCategoriesScroller extends StatelessWidget {
  final User login_user;
  final List<Channel> arrayChannels;
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  /// userEventList contains the events which the user is currently subscribed to
  static List<Event> userEventsList = [];

  UserEventsCategoriesScroller(this.login_user, this.arrayChannels);

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.30;
    final double categoryWidth = MediaQuery.of(context).size.width * 0.30;
    return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: FittedBox(
            fit: BoxFit.fill,
            alignment: Alignment.topCenter,
            child: Row(
              children: <Widget>[
                GestureDetector(
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => myEventsWidget(
                                      login_user, arrayChannels[0]))

                              /// Creates the events card which our user subscribes to
                              // TODO need to change it so we won't hardcode the index of the arrayChannels
                              )
                        },
                    child: Container(
                      width: categoryWidth,
                      margin: EdgeInsets.only(right: 20),
                      height: categoryHeight - 100,
                      decoration: BoxDecoration(
                          color: Colors.orange[400],
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ///Box name
                              "My " + arrayChannels[0].channelName,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
                GestureDetector(
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => myEventsWidget(
                                      login_user, arrayChannels[1])))
                          // TODO need to change it so we won't hardcode the index of the arrayChannels
                        },
                    child: Container(
                      width: categoryWidth,
                      margin: EdgeInsets.only(right: 20),
                      height: categoryHeight - 100,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ///Box name
                              "My " + arrayChannels[1].channelName,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
                GestureDetector(
                    onTap: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => myEventsWidget(
                                      login_user, arrayChannels[2])))
                          // TODO need to change it so we won't hardcode the index of the arrayChannels
                        },
                    child: Container(
                      width: categoryWidth,
                      margin: EdgeInsets.only(right: 20),
                      height: categoryHeight - 100,
                      decoration: BoxDecoration(
                          color: Colors.pink.shade400,
                          borderRadius:
                              BorderRadius.all(Radius.circular(20.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              ///Box name
                              "My " + arrayChannels[2].channelName,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }

//   /// Creates the card that displays events which the user subscribed to per channel
//   Widget createUserEventCard(double categoryHeight, String channelName) {
//     return StreamBuilder<QuerySnapshot>(
//         stream: Firestore.instance
//             .collection('Channels')
//             .document(channelName)
//             .collection('Events')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return LinearProgressIndicator();
//           } else {
//             _buildEventsList(
//                 context, snapshot.data.documents, login_user, channelName);
//             return ListView.builder(
//                 controller: controller,
//                 itemCount: userEventsList.length,
//                 padding: EdgeInsets.only(top: 0, bottom: 0),
//                 physics: BouncingScrollPhysics(),
//                 itemBuilder: (context, index) {
//                   double scale = 1.0;
//                   if (topContainer > 0.5) {
//                     scale = index + 0.5 - topContainer;
//                     if (scale < 0) {
//                       scale = 0;
//                     } else if (scale > 1) {
//                       scale = 1;
//                     }
//                   }
//                   return Opacity(
//                       opacity: scale,
//                       child: Transform(
//                         transform: Matrix4.identity()..scale(scale, scale),
//                         alignment: Alignment.bottomCenter,
//                         child: Align(
//                           heightFactor: 0.7,
//                           alignment: Alignment.topCenter,
//                           child: ChannelState()
//                               .EventcardTemplate(userEventsList[index]),
//                         ),
//                       ));
//                 });
//           }
//         });
//   }
}
