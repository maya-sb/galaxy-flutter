import 'package:flutter/material.dart';
import 'package:galaxy_flutter/screens/EditGalaxy.dart';
import 'package:galaxy_flutter/screens/EditOrbit.dart';
import 'package:galaxy_flutter/screens/EditSatellite.dart';
import 'package:galaxy_flutter/screens/EditPlanet.dart';
import 'package:galaxy_flutter/screens/GalaxyProfile.dart';
import 'package:galaxy_flutter/screens/Home.dart';
import 'package:galaxy_flutter/screens/Login.dart';
import 'package:galaxy_flutter/screens/OrbitProfile.dart';
import 'package:galaxy_flutter/screens/Orbits.dart';
import 'package:galaxy_flutter/screens/PlanetProfile.dart';
import 'package:galaxy_flutter/screens/Planets.dart';
import 'package:galaxy_flutter/screens/RegisterGalaxy.dart';
import 'package:galaxy_flutter/screens/RegisterOrbit.dart';
import 'package:galaxy_flutter/screens/RegisterSatellite.dart';
import 'package:galaxy_flutter/screens/SatelliteProfile.dart';
import 'package:galaxy_flutter/screens/Satellites.dart';
import 'package:galaxy_flutter/screens/Stars.dart';
import 'package:galaxy_flutter/screens/StarProfile.dart';
import 'package:galaxy_flutter/screens/EditStar.dart';
import 'package:galaxy_flutter/screens/RegisterStar.dart';
import 'package:galaxy_flutter/screens/Signup.dart';
import 'package:galaxy_flutter/screens/RegisterPlanet.dart';
import 'package:galaxy_flutter/screens/Galaxies.dart';
import 'package:galaxy_flutter/screens/PlanetarySystems.dart';
import 'package:galaxy_flutter/screens/RegisterPlanetarySystem.dart';
import 'package:galaxy_flutter/screens/PlanetarySystemProfile.dart';
import 'package:galaxy_flutter/screens/EditPlanetarySystem.dart';

class RouteGenerator {

  static const String INITIAL_ROUTE = "/";
  static const String ROUTE_LOGIN = "/login";
  static const String ROUTE_SIGNUP = "/signup";
  static const String ROUTE_HOME = "/home";
  static const String ROUTE_PLANETS = "/planets";
  static const String ROUTE_PLANET_PROFILE = "/planetProfile";
  static const String ROUTE_EDIT_PLANET = "/editPlanet";
  static const String ROUTE_REGISTER_PLANET = "/registerPlaneta";
  static const String ROUTE_GALAXIES = "/galaxies";
  static const String ROUTE_REGISTER_GALAXY = "/registerGalaxy";
  static const String ROUTE_GALAXY_PROFILE = "/galaxyProfile";
  static const String ROUTE_EDIT_GALAXY = "/editGalaxy";
  static const String ROUTE_PLANETARY_SYSTEMS = "/planetarySystems";
  static const String ROUTE_REGISTER_PLANETARY_SYSTEM = "/registerPlanetarySystem";
  static const String ROUTE_PLANETARY_SYSTEM_PROFILE = "/planetarySystemProfile";
  static const String ROUTE_EDIT_PLANETARY_SYSTEM = "/editPlanetarySystem";
  static const String ROUTE_SATELLITES = "/satellites";
  static const String ROUTE_REGISTER_SATELLITE = "/registerSatellite";
  static const String ROUTE_SATELLITE_PROFILE = "satelliteProfile";
  static const String ROUTE_EDIT_SATELLITE = "/editSatellite";
  static const String ROUTE_STARS = "/stars";
  static const String ROUTE_STAR_PROFILE = "/starProfile";
  static const String ROUTE_EDIT_STAR = "/editStar";
  static const String ROUTE_REGISTER_STAR = "/registerStar";
  static const String ROUTE_ORBITS = "/orbits";
  static const String ROUTE_REGISTER_ORBIT = "/registerOrbit";
  static const String ROUTE_ORBIT_PROFILE = "/orbitProfile";
  static const String ROUTE_EDIT_ORBIT = "/editOrbit";

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

      case ROUTE_PLANETS:
        return MaterialPageRoute(
          builder: (context) => Planets());

      case ROUTE_PLANET_PROFILE:
        return MaterialPageRoute(
          builder: (context) => PlanetProfile(id: arguments));

      case ROUTE_EDIT_PLANET:
        return MaterialPageRoute(
          builder: (_) => EditPlanet(id: arguments));

      case ROUTE_REGISTER_PLANET:
        return MaterialPageRoute(
          builder: (_) => RegisterPlanet());

      case ROUTE_GALAXIES:
        return MaterialPageRoute(
          builder: (_) => Galaxies());

      case ROUTE_REGISTER_GALAXY:
        return MaterialPageRoute(
          builder: (_) => RegisterGalaxy());

      case ROUTE_GALAXY_PROFILE:
        return MaterialPageRoute(
          builder: (_) => GalaxyProfile(id: arguments));

      case ROUTE_EDIT_GALAXY:
        return MaterialPageRoute(
          builder: (_) => EditGalaxy(id: arguments));

      case ROUTE_PLANETARY_SYSTEMS:
        return MaterialPageRoute(
          builder: (_) => PlanetarySystems());

      case ROUTE_REGISTER_PLANETARY_SYSTEM:
        return MaterialPageRoute(
          builder: (_) => RegisterPlanetarySystem());

      case ROUTE_PLANETARY_SYSTEM_PROFILE:
        return MaterialPageRoute(
          builder: (_) => PlanetarySystemProfile(id: arguments));

      case ROUTE_EDIT_PLANETARY_SYSTEM:
        return MaterialPageRoute(
          builder: (_) => EditPlanetarySystem(id: arguments));

      case ROUTE_SATELLITES:
        return MaterialPageRoute(
          builder: (_) => Satellites());

      case ROUTE_REGISTER_SATELLITE:
        return MaterialPageRoute(
          builder: (_) => RegisterSatellite());

      case ROUTE_SATELLITE_PROFILE:
        return MaterialPageRoute(
          builder: (_) => SatelliteProfile(id: arguments));

      case ROUTE_EDIT_SATELLITE:
        return MaterialPageRoute(
          builder: (_) => EditSatellite(id: arguments));

      case ROUTE_STARS:
        return MaterialPageRoute(
          builder: (_) => Stars());

      case ROUTE_STAR_PROFILE:
        return MaterialPageRoute(
          builder: (context) => StarProfile(id: arguments));

      case ROUTE_EDIT_STAR:
        return MaterialPageRoute(
          builder: (_) => EditStar(id: arguments));

      case ROUTE_REGISTER_STAR:
        return MaterialPageRoute(
          builder: (_) => RegisterStar(type: arguments));

      case ROUTE_ORBITS:
        return MaterialPageRoute(
          builder: (_) => Orbits());

      case ROUTE_REGISTER_ORBIT:
        return MaterialPageRoute(
          builder: (_) => RegisterOrbit());

      case ROUTE_ORBIT_PROFILE:
        return MaterialPageRoute(
          builder: (_) => OrbitProfile(id: arguments));

      case ROUTE_EDIT_ORBIT:
        return MaterialPageRoute(
          builder: (_) => EditOrbit(id: arguments));
    }
    
  }

}