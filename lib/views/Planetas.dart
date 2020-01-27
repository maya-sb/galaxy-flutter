import 'package:flutter/material.dart';
import 'package:galaxy_flutter/views/Login.dart';

class Planetas extends StatefulWidget {
  @override
  _PlanetasState createState() => _PlanetasState();
}

class _PlanetasState extends State<Planetas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Galaxy Flutter", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app) ,
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
            },),
        ],
        backgroundColor: Colors.transparent
        //backgroundColor: Colors.purple[900],
       ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add,color: Colors.pink[700],),
        backgroundColor: Colors.white,
        onPressed: (){

      },), 
      backgroundColor: Color(0xff380b4c),
      body: Container(),

    );
  }
}