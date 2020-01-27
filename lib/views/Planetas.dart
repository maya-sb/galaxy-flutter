import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_svg/flutter_svg.dart';


class Planetas extends StatefulWidget {
  @override
  _PlanetasState createState() => _PlanetasState();
}

class _PlanetasState extends State<Planetas> {

  var planets = ["Marte","Vênus","Urano","Saturno"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Galaxy Flutter", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent
        //backgroundColor: Colors.purple[900],
       ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.pink[700],),
        backgroundColor: Colors.white,
        onPressed: (){

      },), 
      backgroundColor: Color(0xff380b4c),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
            itemCount: planets.length,
            itemBuilder: (context, index) => PlanetRow(planets[index]),
            padding: EdgeInsets.symmetric(vertical: 4.0)
              ),
          ),
        ],
      ),

    );
  }
}

class PlanetRow extends StatelessWidget {
  const PlanetRow(this.title);

  final title;
  
  final animation = Container(
     margin: EdgeInsets.symmetric(
       vertical: 16.0
     ),
     alignment: FractionalOffset.centerLeft,
     child: 
  );

  @override
  Widget build(BuildContext context) {
    return Container(
       height: 120.0,
       margin: const EdgeInsets.symmetric(
         vertical: 16.0,
         horizontal: 24.0,
       ),
       //color: Colors.white,
      child: Stack(
        children: <Widget>[
          SizedBox(
            width: 92,
            height: 92,
            child: FlareActor('assets/animations/pinkPlanet.flr',
              animation: 'rotation',
              fit: BoxFit.fitWidth,
            ),
          ),
          //planetCard,
          //planetThumbnail,
        ],
      )
      
    );
  }
}