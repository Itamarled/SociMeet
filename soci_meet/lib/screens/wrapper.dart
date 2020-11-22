import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socimeet/models/user.dart';
import 'package:socimeet/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth.dart';
import 'autenticates/autenticate.dart';

/// Choose between sign up and sign in pages
class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context)   {
    //var check =  AuthService().isUserLoggedIn();

    final AuthService _auth =  AuthService();
    final user  = Provider.of<User>(context); // listen to the provider, if it will be null we will navigate to the log in page. else we can access the user data from the provider.
     if(user == null) {
      return Authenticate();
    }else{
       print(user.uid);
       print(user.emailAddress);
       print(user.first_name);

       return Home(user);
    }

  }
}