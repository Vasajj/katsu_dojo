import 'package:flutter/material.dart';

class EnterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.indigo, Colors.indigoAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
              ),
              child: ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '8');
                      },
                      padding: EdgeInsets.all(0.0),
                      child: Image.asset('images/katsudojo.png'))))),
    );
  }
}