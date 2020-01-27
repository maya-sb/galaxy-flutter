import 'package:flutter/material.dart';
import 'package:galaxy_flutter/views/Login.dart';
import 'package:galaxy_flutter/views/Home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galaxy Flutter',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        textSelectionHandleColor: Colors.purple[700],
        cursorColor: Colors.purple[700],
      ),
      
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
