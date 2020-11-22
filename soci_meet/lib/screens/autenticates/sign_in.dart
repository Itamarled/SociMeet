import 'package:socimeet/services/auth.dart';
import 'package:socimeet/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///Sign in screen
class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>(); // for validation

  //text field states

  String email = '';
  String password = '';
  String error = "";

  @override
  Widget build(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Sign in Error"),
      content: Text('Wrong mail or Password'),
      actions: [
        okButton,
      ],
    );

    // show the dialog

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xFFFFCCBF),
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.83), BlendMode.dstATop),
                image: AssetImage("assets/ness-meet.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 16,
                    right: 16,
                    top: 100,
                    bottom: -280,
                    child: new Center(
                        child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.90), BlendMode.dstATop),
                      child: Container(
                        padding: EdgeInsets.only(right: 15),
                        width: 400.0,
                        height: 285.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0.0),
                            color: Color(0xffffffff),
                            backgroundBlendMode: BlendMode.dstATop),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 40.0, right: 15.0, top: 20),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "SIGN IN",
                                    style: Theme.of(context).textTheme.display1,
                                  ),
                                  FlatButton(
                                    child: Text('SIGN UP',
                                        style:
                                            Theme.of(context).textTheme.button),
                                    onPressed: () {
                                      widget.toggleView();
                                    },
                                  ),
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 7),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(right: 16),
                                      child: Icon(
                                        Icons.alternate_email,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        validator: (val) => val.isEmpty
                                            ? "Enter an email"
                                            : null,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        // style: TextStyle(color: Color(0xFFB0CBC4)),
                                        decoration: InputDecoration(
                                          hintText: "Enter Email Address",
                                          //hintStyle: TextStyle(color: Colors.black)
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            email = val;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 16, top: 5),
                                    child: Icon(
                                      Icons.lock,
                                      color: kPrimaryColor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Form(
                                      key: _formKey,
                                      child: TextFormField(
                                        obscureText: true,
                                        validator: (val) => val.length < 6
                                            ? "Enter valied password"
                                            : null,
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding:
                                              EdgeInsets.only(top: 14.0),

                                          hintText: 'Enter Password',
                                          // hintStyle: kHintTextStyle,
                                        ),
                                        onChanged: (val) {
                                          setState(() {
                                            password = val;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
                                      height: 50.0,
                                      margin: const EdgeInsets.only(
                                          left: 80.0, right: 15.0, top: 0.0),
                                      alignment: Alignment.center,
                                      child: new FlatButton(
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      30.0)),
                                          color: Colors.deepOrangeAccent[100],
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) //will check if our from is legit
                                            {
                                              print(email);
                                              print(password);
                                              dynamic result = await _auth
                                                  .signInWithEmailAndPassword(
                                                      email, password);

                                              if (result == null) {
                                                //TODO check
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return alert;
                                                  },
                                                );
                                              }
                                            }
                                            else{
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return alert;
                                                },
                                              );
                                            }
                                          },
                                          child: new Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 00,
                                              horizontal: 3.0,
                                            ),
                                            margin: EdgeInsets.all(7),
                                            child: new Row(
                                              children: <Widget>[
                                                new Expanded(
                                                  child: Text(
                                                    "LOGIN",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )),
                  )
                ],
              ),
            )),
      ),
    );

  }

}
