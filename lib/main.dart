import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unscatter/constants/constants.dart';
import 'package:unscatter/screens/Dashboard.dart';
import 'package:unscatter/screens/AddOrModify.dart';
import 'package:unscatter/screens/Delete.dart';
import 'package:unscatter/screens/Experiment.dart';
import 'package:unscatter/screens/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unscatter/screens/Registration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
      debugShowCheckedModeBanner: false,
      routes: {
        LandingPage.id : (context) => LandingPage(),
        LoginPage.id : (context) => LoginPage(),
        RegistrationPage.id : (context) => RegistrationPage(),
        Dashboard.id : (context) => Dashboard(),
        AddOrModify.id : (context) => AddOrModify(),
        Delete.id : (context) => Delete(),
      },
      theme: kAppTheme,
    )
  );
}

class LandingPage extends StatefulWidget {
  static String id = 'LandingPage';
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  String email;

  void getUser() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? ' ';
    });
    print(email);
    // if (  email!=null )
    // {
    //   Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //           builder: (context) => LandingPage()
    //       ),
    //       ModalRoute.withName(LandingPage.id)
    //   );
    // }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return (email!=' ') ? Dashboard() : LoginPage();
  }
}
