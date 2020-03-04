import 'package:flutter/material.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/views/Login.dart';

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
        scaffoldBackgroundColor: Color(0xff380b4c)
      ),
      //initialRoute: RouteGenerator.INITIAL_ROUTE,
      initialRoute: RouteGenerator.ROUTE_PLANETAS,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
      home: Login(),
    );
  }
}
