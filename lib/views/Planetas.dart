import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_svg/flutter_svg.dart';


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
      body: Container(
        color: Color(0xff380b4c),
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
         vertical: 16.0,
         horizontal: 24.0,
       ),
      child: new Stack(
        children: <Widget>[
          PlanetCard(),
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
        margin: new EdgeInsets.symmetric(
        vertical: 16.0
     ),
     alignment: FractionalOffset.centerLeft,
     //child: SvgPicture.asset('assets/svg/orbit.svg'),
     child: Padding(
       padding: const EdgeInsets.only(right: 300),
       child: SizedBox(
         child: FlareActor('assets/animations/pinkPlanet.flr',
          animation: 'rotation',
          fit: BoxFit.fitHeight,), 
          height: 250, 
          width: 1000,),
     ),

    );
  }
}

class PlanetCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 124.0,
      //margin: new EdgeInsets.only(left: 40.0),
      margin: EdgeInsets.only(left: 40.0, ),
      decoration:
      BoxDecoration(
        color: new Color(0xFF333366),
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
            BoxShadow(  
            color: Colors.black12,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
        ),
      ],
    ),

    );
  }
}

Decoration box = BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    //stops:[0,0.8],
    //colors: [Colors.purple[400], Colors.purple[800]],
    colors: [Colors.pink[700], Colors.purple[800]],
  ),
        
);