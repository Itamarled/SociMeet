import 'package:flutter/material.dart';
import 'package:socimeet/services/auth.dart';


final List<String> _items = [
   'Man',



   'Woman',


 'Another Gender',

];

///Register screen
class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password1 = '';
  String password2 = '';
  String first_name = '';
  String last_name = '';
  String _selectedGender = 'Man';
  String error = " ";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[100],
        appBar: AppBar(
          backgroundColor: Colors.black12, //for the appbar
          elevation: 0.0, // elevation from the screen
          title: Text('Sign up',
          style: TextStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),),
          //centerTitle: true,
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person,color: Colors.white,),
              label: Text('Already\nregistered?',
                  style:TextStyle(
                  fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),),
              onPressed: () {
                widget.toggleView(); // this is how we call to the function
              },
            )
          ],
        ),
        body: LayoutBuilder(builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            // wil help as to scrolling down with no issue

            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Container(
                decoration: BoxDecoration(
                  //color: Color(0xFFFFCCBF),
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(
                        Colors.white.withOpacity(0.83), BlendMode.dstATop),
                    image: AssetImage("assets/HouseMeet.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.9,
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 22.0),
                child: Form(
                    key: _formKey, // keep truck to our form, for validate.
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),

                        /// form field for email
                        // TODO add email validation field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20.0),
                          ),

                          child: Padding(padding: EdgeInsets.only(left: 0.1),
                            child: TextFormField(
                              validator: (val) =>
                                  val.isEmpty ? "Enter an email" : null,
                              decoration: InputDecoration(


                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Enter Email",
                              hoverColor: Colors.white),
                              keyboardType: TextInputType.emailAddress,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  email = val;
                                });
                              },
                            ),
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(8.0)),

                        /// form field for password
                        // TODO add a password validation form field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextFormField(
                            validator: (val) => val.length < 6
                                ? "Enter password longer then 6"
                                : null,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: new BorderSide(),
                                ),
                                labelText: "Password"),
                            style: new TextStyle(
                              fontFamily: "Poppins",
                               color: Colors.white,
                            ),
                            obscureText: true,
                            //for password
                            onChanged: (val) {
                              setState(() {
                                password1 = val;
                              });
                            },
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(8.0)),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextFormField(
                            validator: (val) => password2!=password1
                                ? "Password Doesn't Match!"
                                : null,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: new BorderSide(),
                                ),
                                labelText: "Repeat The Password"),
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                            obscureText: true,
                            //for password
                            onChanged: (val) {
                              setState(() {
                                password2 = val;
                              });
                            },
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(8.0)),
                        /// form field for first name
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextFormField(
                            validator: (val) =>
                                val.length < 2 ? "Enter valied name" : null,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: new BorderSide(),
                                ),
                                labelText: "First Name"),
                            keyboardType: TextInputType.emailAddress,
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                            onChanged: (val) {
                              setState(() {
                                first_name = val;
                              });
                            },
                          ),
                        ),
                        new Padding(padding: EdgeInsets.all(8.0)),

                        /// form field for last name
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: TextFormField(
                            validator: (val) =>
                                val.length < 2 ? "Enter valied name" : null,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                border: new OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(20.0),
                                  borderSide: new BorderSide(),
                                ),
                                labelText: "Last Name"),
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                            ),
                            onChanged: (val) {
                              setState(() {
                                last_name = val;
                              });
                            },
                          ),
                        ),

                        /// Field for gender
                        // TODO add Gender choice
                        Padding(padding: EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(20.0),
                              
                            ),
                            
                            child:DropdownButton(
                              hint: Text('Select Your Gender',textAlign: TextAlign.center,), // Not necessary for Option 1
                              value: _selectedGender,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedGender = newValue;
                                });
                              },
                              items: _items.map((value) {
                                return DropdownMenuItem(
                                  child: new Text(value.toString()),
                                  value: value,
                                );
                              }).toList(),

                            ) /*SelectFormField(
                              initialValue: 'Man',
                              labelText: 'Gender',
                              items: _items,
                              onChanged: (val) =>  gender = val,
                              onSaved: (val) =>  gender = val,
                            ),*//*TextFormField(
                              validator: (val) =>
                                  val.length < 2 ? "Enter valied name" : null,
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  border: new OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    borderSide: new BorderSide(),
                                  ),
                                  labelText: "Gender"),
                              style: new TextStyle(
                                fontFamily: "Poppins",
                              ),
                              onChanged: (val) {
                                setState(() {
                                  gender = val;
                                });
                              },
                            ),*/
                          ),
                        ),

                        /// Press and you will be registered!
                        ///
                        /// here we will validate the form, and contact firebase to add a new user
                        RaisedButton(
                          color: Colors.pink[52],
                          child: Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState
                                .validate()) //will check if our from is legit
                            {
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email,
                                      password1,
                                      first_name,
                                      last_name,
                                      _selectedGender,
                                      Map<String, String>());
                              if (result == null) {
                                setState(() => error =
                                    'Could not sign in with those credentials'); //TODO check
                              }
                            }
                          },
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    )),
              ),
            ),
          );
        }));
  }
}
