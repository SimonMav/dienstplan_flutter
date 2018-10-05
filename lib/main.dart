import 'package:flutter/material.dart';

import './home.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Dienstplan Flutter Test'),
        ),
        body: Home(),
      ),
    );
  }
}
