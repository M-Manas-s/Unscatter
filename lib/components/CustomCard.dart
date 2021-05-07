import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {

  final Widget child;
  final Color color;
  final double radius;

  CustomCard({@required this.child, this.color= const Color(0xFF282B4E) ,this.radius=10.0});

  @override
  Widget build(BuildContext context) {
    Size query = MediaQuery
        .of(context)
        .size;
    return Container(
        //width: query.width * 0.9,
        margin: EdgeInsets.only(top: 5, bottom: 5),
        child: Card(
          color: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(radius),
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