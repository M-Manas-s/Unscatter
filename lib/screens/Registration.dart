import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unscatter/main.dart';
import 'package:unscatter/screens/Dashboard.dart';
import 'package:unscatter/screens/Login.dart';


class RegistrationPage extends StatefulWidget {
  static String id = "RegistrationPage";
  const RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String fullName;
  String regno;
  String dob;
  String address;
  String email;
  String password;
  List<String> number = [];
  bool spinner = false;
  bool state = true;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitChasingDots(
        color: Theme.of(context).accentColor,
        size: 30.0,
      ),
      inAsyncCall: spinner,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formKey,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Hero(
                        //     tag: "Logo",
                        //
                        //     child: Image.asset()
                        // ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            onChanged: (value) {
                              fullName = value.trim();
                            },
                            cursorColor: Theme.of(context).accentColor,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: false,
                              hintText: "Full Name",
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            ),
                            validator: fnameValidator,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                            onChanged: (value) {
                              regno = value.trim();
                            },
                            cursorColor: Theme.of(context).accentColor,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              filled: false,
                              hintText: "Unique ID",
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                            ),
                            validator: usernameValidator,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                number = value.trim().split(',');
                              },
                              cursorColor: Theme.of(context).accentColor,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: false,
                                hintText: "Mobile Number",
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              ),
                              validator: numberValidator),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                              onChanged: (value) {
                                dob = value.trim();
                              },
                              cursorColor: Theme.of(context).accentColor,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: false,
                                hintText: "Date of Birth",
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              ),
                              validator: dobValidator),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: TextFormField(
                              onChanged: (value) {
                                address = value.trim();
                              },
                              cursorColor: Theme.of(context).accentColor,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                filled: false,
                                hintText: "Address",
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                              ),
                              validator: fnameValidator),
                        ),
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
                              validator: emailChecker),
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.all(10),
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
                                  validator: passwordValidator),
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
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            buttonWidget(
                              title: "Register (Student)",
                              onpressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    spinner = true;
                                  });
                                  var newuser =
                                  await auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
//                                UserUpdateInfo updateInfo = UserUpdateInfo();
//                                updateInfo.displayName = _usernameController.text;
//                                user.updateProfile(updateInfo);
                                  await auth.currentUser
                                      .updateProfile(displayName: fullName);
                                  FirebaseFirestore.instance
                                      .collection('Student')
                                      .add({
                                    'Name': "$fullName",
                                    "Regno": "$regno",
                                    "DOB" : dob,
                                    "Address" : address,
                                    "Email" : email,
                                  });
                                  for ( int i=0; i<number.length; i++ ) {
                                    FirebaseFirestore.instance
                                        .collection('StudentPhoneNo')
                                        .add({
                                      "Regno": "$regno",
                                      "PhoneNumber" : number[i]
                                    });
                                  }
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('email', '$email');
                                  prefs.setString('user','Student');
                                  prefs.setBool('periodBegun',false);
                                  if (newuser != null) {
                                    Navigator.pushNamed(context, LandingPage.id);
                                  }
                                  setState(() {
                                    spinner = false;
                                  });
                                }
                              },
                            ),
                            SizedBox(width: 5,),
                            buttonWidget(
                              title: "Register (Faculty)",
                              onpressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    spinner = true;
                                  });
                                  var newuser =
                                  await auth.createUserWithEmailAndPassword(
                                      email: email, password: password);
                                  await auth.currentUser
                                      .updateProfile(displayName: fullName);
                                  FirebaseFirestore.instance
                                      .collection('Faculty')
                                      .add({
                                    'Name': "$fullName",
                                    "FacultyID": "$regno",
                                    "DOB" : dob,
                                    "Address" : address,
                                    "Email" : email,
                                  });
                                  for ( int i=0; i<number.length; i++ ) {
                                    FirebaseFirestore.instance
                                        .collection('FacultyPhoneNo')
                                        .add({
                                      "FacultyID": "$regno",
                                      "PhoneNumber" : number[i]
                                    });
                                  }
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('email', '$email');
                                  prefs.setString('user','Faculty');
                                  prefs.setBool('periodBegun',false);
                                  if (newuser != null) {
                                    Navigator.pushNamed(context, LandingPage.id);
                                  }
                                  setState(() {
                                    spinner = false;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        signUpRichText(
                            title: "Log In!",
                            text: "Already Have An Account? ",
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()
                                  ),
                                  ModalRoute.withName(LoginPage.id)
                              );
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
