import 'package:flutter/material.dart';
import 'package:socimeet/models/user.dart';
import 'home.dart';

class HomeManagement extends StatefulWidget {

  final User login_user;

  const HomeManagement(this.login_user);

  get toggleViewShowHomeVsGuestManagement => toggleViewShowHomeVsGuestManagement();

  @override
  _HomeManagementState createState() => _HomeManagementState();
}

class _HomeManagementState extends State<HomeManagement> {
  bool showHomeVsGuestManagement =true; // what we prefer to show
  @override
  Widget build(BuildContext context) {

    return Home(widget.login_user);

  }
}