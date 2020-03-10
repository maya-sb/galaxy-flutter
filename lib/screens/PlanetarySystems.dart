import 'package:flutter/material.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class PlanetarySystems extends StatefulWidget {

  @override
  _PlanetarySystemsState createState() => _PlanetarySystemsState();
}

class _PlanetarySystemsState extends State<PlanetarySystems> {

  Api db = Api();

  @override
  Widget build(BuildContext context) 

  {
    return WillPopScope(
       onWillPop: () async {
         Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
         return false;
       },
       child: Scaffold(
         appBar: AppBar(
          title: Text("Sistemas Planetários", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              //TODO busca por nome
              child: Icon(Icons.search),
            )
          ],
         ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.pink[700],),
          backgroundColor: Colors.white,
          onPressed: (){
             Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_PLANETARY_SYSTEM);
        },),
        body: NameList(asset: 'assets/animations/planetList.flr', future: db.getAll("sistema", PlanetarySystem), rota:  RouteGenerator.ROUTE_PLANETARY_SYSTEM_PROFILE)
      ),
    );

}
}