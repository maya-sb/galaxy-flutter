import 'package:flutter/material.dart';
import 'package:galaxy_flutter/views/EditarPlaneta.dart';
import 'package:galaxy_flutter/views/Home.dart';
import 'package:galaxy_flutter/views/Login.dart';
import 'package:galaxy_flutter/views/Planet.dart';
import 'package:galaxy_flutter/views/Planetas.dart';
import 'package:galaxy_flutter/views/Signup.dart';

class RouteGenerator {

  static const String INITIAL_ROUTE = "/";
  static const String ROUTE_LOGIN = "/login";
  static const String ROUTE_SIGNUP = "/signup";
  static const String ROUTE_HOME = "/home";
  static const String ROUTE_PLANETAS = "/planetas";
  static const String ROUTE_PLANET = "/planet";
  static const String ROUTE_EDITAR_PLANETA = "/editarPlaneta";

  static Route<dynamic> generateRoute(RouteSettings settings){
    
    switch(settings.name){
      case INITIAL_ROUTE:
        return MaterialPageRoute(
          builder: (context) => Login());
      case ROUTE_LOGIN:
        return MaterialPageRoute(
          builder: (context) => Login());
      case ROUTE_SIGNUP:
        return MaterialPageRoute(
          builder: (context) => Signup());
      case ROUTE_HOME:
        return MaterialPageRoute(
          builder: (context) => Home());
      case ROUTE_PLANETAS:
        return MaterialPageRoute(
          builder: (context) => Planetas());
      case ROUTE_PLANET:
        return MaterialPageRoute(
          builder: (context) => Planet());
      case ROUTE_EDITAR_PLANETA:
        return MaterialPageRoute(
          builder: (_) => EditarPlaneta());
    }
    
  }

}