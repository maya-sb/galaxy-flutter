import 'package:flutter/material.dart';
import 'package:galaxy_flutter/screens/EditGalaxy.dart';
import 'package:galaxy_flutter/screens/EditarPlaneta.dart';
import 'package:galaxy_flutter/screens/GalaxyProfile.dart';
import 'package:galaxy_flutter/screens/Home.dart';
import 'package:galaxy_flutter/screens/Login.dart';
import 'package:galaxy_flutter/screens/PlanetProfile.dart';
import 'package:galaxy_flutter/screens/Planetas.dart';
import 'package:galaxy_flutter/screens/RegisterGalaxy.dart';
import 'package:galaxy_flutter/screens/Signup.dart';
import 'package:galaxy_flutter/screens/CadastrarPlaneta.dart';
import 'package:galaxy_flutter/screens/Galaxies.dart';

class RouteGenerator {

  static const String INITIAL_ROUTE = "/";
  static const String ROUTE_LOGIN = "/login";
  static const String ROUTE_SIGNUP = "/signup";
  static const String ROUTE_HOME = "/home";
  static const String ROUTE_PLANETAS = "/planetas";
  static const String ROUTE_PLANET = "/planet";
  static const String ROUTE_EDITAR_PLANETA = "/editarPlaneta";
  static const String ROUTE_CADASTRAR_PLANETA = "/cadastrarPlaneta";
  static const String ROUTE_GALAXIES = "/galaxies";
  static const String ROUTE_REGISTER_GALAXY = "/registerGalaxy";
  static const String ROUTE_GALAXY = "/galaxy";
  static const String ROUTE_EDIT_GALAXY = "/editGalaxy";

  static Route<dynamic> generateRoute(RouteSettings settings){
    final arguments = settings.arguments;
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
      case ROUTE_CADASTRAR_PLANETA:
        return MaterialPageRoute(
          builder: (_) => CadastrarPlaneta());
      case ROUTE_GALAXIES:
        return MaterialPageRoute(
          builder: (_) => Galaxies());
      case ROUTE_REGISTER_GALAXY:
        return MaterialPageRoute(
          builder: (_) => RegisterGalaxy());
      case ROUTE_GALAXY:
        return MaterialPageRoute(
          builder: (_) => GalaxyProfile(galaxy: arguments));
      case ROUTE_EDIT_GALAXY:
        return MaterialPageRoute(
          builder: (_) => EditGalaxy(galaxy: arguments));
    }
    
  }

}