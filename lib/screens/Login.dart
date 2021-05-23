import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/screens/Dashboard.dart';
import 'package:unscatter/screens/Registration.dart';
import 'package:unscatter/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  static String id = 'LoginPage';
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorText;
  String email;
  String password;
  String number;
  bool spinner = false;
  bool state = true;
  bool absorb=false;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorText = ' ';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitChasingDots(
        color: Theme.of(context).accentColor,
        size: 30.0,
      ),
      inAsyncCall: spinner,
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Form(
              key: _formKey,
              child:
              Stack(
                children: [
                  //if things go wrong remove stack and add expanded and change singlechilscroll to col
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    onChanged: (value) {
                                      email = value.trim();
                                    },
                                    cursorColor: Theme.of(context).accentColor,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      filled: false,
                                      hintText: "Email",
                                      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                    ),
                                    validator: emailChecker,
                                  ),
                                ),
                                //SizedBox(height: 10),
                                Padding(
                                  padding:  EdgeInsets.all(10),
                                  child: Stack(
                                    children: [
                                      TextFormField(
                                        onChanged: (value) {
                                          password = value.trim();
                                        },
                                        obscureText: state,
                                        cursorColor: Theme.of(context).accentColor,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          filled: false,
                                          hintText: "Password",
                                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                        ),
                                        validator: passwordValidator,
                                      ),
                                      Positioned(
                                        top: 10,
                                        right: 20,
                                        child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (state == false) {
                                                  setState(() {
                                                    state = true;
                                                  });
                                                } else if (state == true) {
                                                  setState(() {
                                                    state = false;
                                                  });
                                                }
                                              });
                                            },
                                            child: Icon(Icons.remove_red_eye)),
                                      )
                                    ],
                                  ),
                                ),

                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(errorText, style: TextStyle(color: Colors.red),),
                                ),
                                SizedBox(
                                  height: 40,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    buttonWidget(
                                      title: "Student Login",
                                      onpressed: () async {

                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            spinner = true;
                                          });
                                          try {
                                            var user = await auth.signInWithEmailAndPassword(
                                                email: email, password: password);
                                            await FirebaseFirestore.instance
                                                .collection('Student')
                                                .where('Email', isEqualTo: email)
                                                .get()
                                                .then((QuerySnapshot querySnapshot) {
                                              if ( querySnapshot==null ) {
                                                print("Not a Student");
                                                throw Exception(
                                                    "Not a Student");
                                              }
                                            });

                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setString('email', '$email');
                                            prefs.setString('user','Student');
                                            if (user != null) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => LandingPage()
                                                  ),
                                                  ModalRoute.withName(LandingPage.id)
                                              );
                                            }
                                          }
                                          on Exception{
                                            setState(() {
                                              spinner = false;
                                              errorText = "Wrong Email/Password";
                                            });
                                          }
                                        }
                                      },
                                    ),
                                    SizedBox(width:5),
                                    buttonWidget(
                                      title: "Faculty Login",
                                      onpressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          setState(() {
                                            spinner = true;
                                          });
                                          try {
                                            var user = await auth.signInWithEmailAndPassword(
                                                email: email, password: password);

                                            await FirebaseFirestore.instance
                                                .collection('Faculty')
                                                .where("Email", isEqualTo: email)
                                                .get()
                                                .then((QuerySnapshot querySnapshot) {
                                              if ( querySnapshot==null ) {
                                                print("Not a Faculty");
                                                throw Exception(
                                                    "Not a Faculty");
                                              }
                                            });

                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.setString('email', '$email');
                                            prefs.setString('user','Faculty');
                                            if (user != null) {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => LandingPage()
                                                  ),
                                                  ModalRoute.withName(LandingPage.id)
                                              );
                                            }
                                          }
                                          on Exception{
                                            setState(() {
                                              spinner = false;
                                              errorText = "Wrong Email/Password";
                                            });
                                          }
                                        }
                                      },
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                signUpRichText(
                                  title: "Sign Up!",
                                  onTap: () {
                                    Navigator.pushNamed(context, RegistrationPage.id);
                                  },
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                ],
              )


          ),
        ),
      ),
    );
  }
}