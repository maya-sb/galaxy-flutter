import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:galaxy_flutter/views/Planet.dart';
import 'package:galaxy_flutter/views/EditarPlaneta.dart';

class Planetas extends StatefulWidget {
  @override
  _PlanetasState createState() => _PlanetasState();
}

class _PlanetasState extends State<Planetas> {

  var planets = ["Marte","Vênus","Urano","Saturno","Netuno","Mercúrio"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Planetas", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent
        //backgroundColor: Colors.purple[900],
       ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.pink[700],),
        backgroundColor: Colors.white,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditarPlaneta()));
      },), 
      backgroundColor: Color(0xff380b4c),
      body: Container(
        color: Color(0xff380b4c),
        padding: EdgeInsets.only(top: 20),
        child: ListView.builder(
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(0.0),
            child: PlanetRow(planets[index]),
          ),
          itemCount: planets.length,
          //padding: new EdgeInsets.symmetric(vertical: 16.0)
        ),
      ),

    );
  }
}

class PlanetRow extends StatelessWidget {
  const PlanetRow(this.title);

  final title;

  @override
  Widget build(BuildContext context) {
    return Container(
       height: 120.0,
       margin: const EdgeInsets.symmetric(
         vertical: 10.0,
         //horizontal: 24.0,
       ),
      child: new Stack(
        children: <Widget>[
          PlanetCard(title),
          PlanetAnimation(),
        ],
      )
    );
    
  }
}

class PlanetAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Container(
     alignment: FractionalOffset.centerLeft,
     child: Padding(
       padding: const EdgeInsets.only(right: 285, left:0),
       child: FlareActor('assets/animations/planetList.flr',
          animation: 'rotation',
          ), 
     ),

    );
  }
}

class PlanetCard extends StatelessWidget {
  const PlanetCard(this.title);

  final title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => Planet()));
      },
      child: Container(
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(title, 
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff380b4c), fontSize: 20, ),),
            Text("Tamanho: 49.244 km", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54, fontSize: 15, ),),
            Text("Massa: 1,024 × 10^26 kg", 
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white54, fontSize: 15, ),),
          ],
        )),
        height: 120.0,
        margin: EdgeInsets.only(left: 60.0, right: 20 ),
        decoration:
        BoxDecoration(
          color: Colors.purple[800],
          shape: BoxShape.rectangle,
          borderRadius: new BorderRadius.circular(8.0),
          boxShadow: [new BoxShadow(
            color: Color(0xff280538),
            blurRadius: 20.0,)],
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops:[0,4],
            colors: [Colors.pink[700], Colors.purple[800]],
          ),
      ),

      ),
    );
  }
}