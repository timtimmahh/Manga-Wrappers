import 'package:flutter/material.dart';

class ErrorPage extends Page {
  @override
  Route createRoute(BuildContext context) => MaterialPageRoute(
        settings: this,
        builder: (BuildContext context) {
          return ErrorPageScreen();
        },
      );
}

class ErrorPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text('404!'),
        ),
      );
}
