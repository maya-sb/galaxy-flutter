import 'package:flutter/material.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class Planetas extends StatefulWidget {
  @override
  _PlanetasState createState() => _PlanetasState();
}

class _PlanetasState extends State<Planetas> {

  // TODO Vai ser uma lista de objetos
 
  var planets = ["Marte","Via láctea","Sistema Solar","Saturno","Netuno","Mercúrio"];
  var cores = ["pinkSatelite.flr","pinkGalaxy.flr","pinkSystem.flr","greenPlanet.flr","bluePlanet.flr","greyPlanet.flr"];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
         Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
         return false;
       },
       child: Scaffold(
         appBar: AppBar(
          title: Text("Planetas", style: TextStyle(color: Colors.white)),
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
             Navigator.pushNamed(context, RouteGenerator.ROUTE_CADASTRAR_PLANETA);
        },),
        body: Container(
          color: Color(0xff380b4c),
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
            itemBuilder: (context, index) => 
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: RowList(
                title: planets[index], 
                asset: 'assets/animations/'+cores[index], 
                action: () => Navigator.pushNamed(context, RouteGenerator.ROUTE_PLANET)
                ),
              //child: PlanetRow(planets[index]),
            ),
            itemCount: planets.length,
          ),
        ),
      ),
    );
  }
}