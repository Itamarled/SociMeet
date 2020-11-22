
import 'package:socimeet/models/user.dart';
import 'package:socimeet/screens/home/home.dart';
import 'package:socimeet/screens/wrapper.dart';
import 'package:socimeet/services/auth.dart';
import 'package:socimeet/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  ///  Root of the application.
  @override
  Widget build(BuildContext context) {


    return StreamProvider<User>.value(
      value: AuthService().user, // get the instance of the user stream that we made in auth.dart
      child: MaterialApp(

        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kBackgroundColor,
          textTheme: TextTheme(
            display1: TextStyle(color: Colors.indigo.withOpacity(.8),//Color(0xFFFFAB9E),
              //0xFFB0CBCA
              fontWeight: FontWeight.bold,
              fontFamily: "CaviarDreams",
              fontSize: 32.0,
            ),
            button: TextStyle(color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: "CaviarDreams",
            ),
            headline:
            TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
          ),
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white.withOpacity(.2),
              ),
            ),
          ),
        ),


        home:Wrapper(),

      ),
    );
  }
}
