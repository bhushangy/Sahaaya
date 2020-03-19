import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';

class ReusableCard2 extends StatelessWidget {
  ReusableCard2(
      {@required this.value,
        @required this.onPressed1,
        @required this.onPressed2,
        @required this.image1,
        @required this.image2});
  String value;
  Function onPressed1, onPressed2;
  File image1, image2;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF212121),
        borderRadius: BorderRadius.circular(10.0),
      ),
      height: 170.0,
      width: 170.0,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '\n$value\n',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          image1 == null && image2 == null
              ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RoundIconButton(
                icon: FontAwesomeIcons.camera,
                onPressed: onPressed1,
              ),
              SizedBox(
                width: 20.0,
              ),
              RoundIconButton(
                icon: FontAwesomeIcons.file,
                onPressed: onPressed2,
              ),
            ],
          )
              : image1 == null
              ? Row(
            children: <Widget>[
              Image.file(
                image2,
                width: 162,
                height: 100,
                fit: BoxFit.cover,
              )
            ],
          )
              : Row(
            children: <Widget>[
              Image.file(
                image1,
                width: 162,
                height: 100,
                fit: BoxFit.cover,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed});

  final IconData icon;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: Icon(icon),
      onPressed: onPressed,
      constraints: BoxConstraints.tightFor(
        width: 56.0,
        height: 56.0,
      ),
      shape: CircleBorder(),
      fillColor: Color(0xFF4C4F5E),
    );
  }
}