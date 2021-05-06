import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

  final Widget child;
  final Color color;

  CustomCard({@required this.child, this.color });

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery
        .of(context)
        .size;
    return Container(
        width: query.width * 0.9,
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Card(
          color: color == null ? Color(0xFF282B4E) : color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(10.0),
            splashColor: Color(0xFF1E7777).withAlpha(30),
            onTap: () {},
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  query.width * (1 / 20),
                  query.width * (1 / 40),
                  query.width * (1 / 20),
                  query.width * (1 / 40)),
              child: child,
            ),
          ),
        ));
  }
}