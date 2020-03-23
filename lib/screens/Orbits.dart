import 'package:flutter/material.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Orbit.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class Orbits extends StatefulWidget {
  @override
  _OrbitsState createState() => _OrbitsState();
}

class _OrbitsState extends State<Orbits> {

  Api db = Api();
  var orbits;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
         Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
         return false;
       },
       child: Scaffold(
         appBar: AppBar(
          title: Text("Órbitas", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
         ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.pink[700],),
          backgroundColor: Colors.white,
          onPressed: (){
             Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_ORBIT);
        },),
        body: NameList(type: 'Orbit', future: db.getAll("orbit", Orbit), route: RouteGenerator.ROUTE_ORBIT_PROFILE, db: db)
      ),
    );
  }
}