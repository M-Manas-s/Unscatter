import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

TextStyle kAppBarTitleStyle = TextStyle(
  fontFamily: 'Barlow',
  letterSpacing: 8,
  fontSize: 29,
  fontWeight: FontWeight.w500,
);

TextStyle kCourseNameDB = TextStyle(
  fontSize: 20,
  letterSpacing: 4,
);

TextStyle kTimeDB = TextStyle(
  fontSize: 13,
  letterSpacing: 2,
);

const kTextDecoration = InputDecoration(
  filled: false,
  hintText: "Email/Mobile Number",
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
);

ThemeData kAppTheme = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF0A0E23),
  scaffoldBackgroundColor: Color(0xff0f142d),
  accentColor: Color(0xFFE45465),
  cardColor: Color(0xff0f142d),
  colorScheme: ThemeData.dark().colorScheme.copyWith(
    surface: Color(0xFF0A0E23),
  ),
  timePickerTheme: TimePickerThemeData(
    helpTextStyle: TextStyle(
      letterSpacing: 2,
      fontSize: 20,
    ),
  )
);

ThemeData kAppTheme2 = ThemeData.dark().copyWith(
  primaryColor: Color(0xFF11163A),
  scaffoldBackgroundColor: Color(0xFF0F1434),
  accentColor: Color(0xFFE45465),
);


String fnameValidator(value) {
  if (value.isEmpty) {
    return "Please Enter Text";
  }
}

String usernameValidator(value) {
  if (value.isEmpty) {
    return "Please Enter Text";
  }
}

String dobValidator(value) {
  String pattern = r'^\d\d[/]\d\d[/]\d\d\d\d$';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return "Please Enter Text";
  }else if (!regex.hasMatch(value)) {
    return "Please USe DD/MM/YYYY";
  }
}

String numberValidator(value) {
  if (value.isEmpty) {
    return "Please Enter Number";
  } else if (value.length < 10 || value.length > 10) {
    print(value.length);
    return "Enter A Valid Mobile Number ";
  }
  return null;
}

String passwordValidator(value) {

  if (value.isEmpty) {
    return 'Please Enter Text';
  } else if (value.length <= 7) {
    return 'Password Must Be Atleast 8 Characters Long';
  }
   else {
    return null;
  }
}

String emailChecker(value) {
  String pattern = r'.+@.+[.].+';
  RegExp regex = new RegExp(pattern);
  if (value.isEmpty) {
    return 'Please Enter Text';
  } else if (!regex.hasMatch(value)) {
    return "Please Enter A Valid Email";
  }

  return null;
}

class buttonWidget extends StatelessWidget {
  final String title;
  final Function onpressed;
  const buttonWidget({
    Key key,
    this.title,
    this.onpressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        elevation: 2.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        minWidth: MediaQuery.of(context).size.width * 0.3,
        color: Theme.of(context).accentColor,
        onPressed: onpressed,
        child: Text(
          title,
          style: TextStyle(color: Colors.white),
        ));
  }
}

class signUpRichText extends StatelessWidget {
  final String title;
  final String text;
  final Function onTap;
  const signUpRichText({
    Key key,
    @required this.title,
    @required this.onTap, this.text = "Don't Have An Account? ",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: text,
          style: TextStyle(color: Colors.white, fontSize: 13),
          children: [
            TextSpan(
                recognizer: TapGestureRecognizer()..onTap = onTap,
                text: title,
                style: TextStyle(decoration: TextDecoration.underline,color: Colors.white))
          ]),
    );
  }
}