import 'package:flutter/material.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Satellite.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Stars extends StatefulWidget {
  @override
  _StarsState createState() => _StarsState();
}

class _StarsState extends State<Stars> {

  Api db = Api();

  NameList lista;

  @override
  void initState(){
    super.initState();
    lista = NameList(type: 'Star', future: db.getAll('star', Star), route: RouteGenerator.ROUTE_SATELLITE_PROFILE);
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
       onWillPop: () async {
         Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
         return false;
       },
       child: Scaffold(
         appBar: AppBar(
          title: Text("Estrelass", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              //TODO busca por nome
              child: Icon(Icons.search),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: PopupMenuButton(
                icon: Icon(Icons.filter_list),
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return <String>["Todos", "Anã branca", "Anã vermelha", "Gigante azul", "Gigante vermelha", "Estrela binária", "Buraco negro"].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice, style: TextStyle(color: Colors.purple[800]),),
                    );
                  }).toList();
                },
              )
            )
          ],
         ),
        //Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_SATELLITE);
        floatingActionButton: SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          child: Icon(Icons.add),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          // If true user is forced to close dial manually 
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.purple[900],
          overlayOpacity: 0.5,
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.pink[700],
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Anã branca',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => print('FIRST CHILD')
            ),
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Anã vermelha',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => print('FIRST CHILD')
            ),
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Gigante azul',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => print('FIRST CHILD')
            ),
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Gigante vermelha',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => print('FIRST CHILD')
            ),
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Estrela binária',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => print('FIRST CHILD')
            ),
       
          ],
        ),
        body: lista,
      ),
    );
  }


  void choiceAction(String choice) {
    setState(() {
      switch (choice) {
        case "Todos":
          lista = NameList(type: 'Star', future: db.getAll('star', Star), route: RouteGenerator.ROUTE_SATELLITE_PROFILE);
          break;
        
        case "Anã branca":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type', 'Anã branca'), route: RouteGenerator.ROUTE_SATELLITE_PROFILE);
          break;
        
        case "Anã vermelha":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type', 'Anã vermelha'), route: RouteGenerator.ROUTE_SATELLITE_PROFILE);
          break;
        
        case "Gigante azul":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type', 'Gigante azul'), route: RouteGenerator.ROUTE_SATELLITE_PROFILE);
          break;
        
        case "Gigante vermelha":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type', 'Gigante vermelha'), route: RouteGenerator.ROUTE_SATELLITE_PROFILE);
          break;
        
        case "Estrela binária":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type','Estrela binária'), route: RouteGenerator.ROUTE_SATELLITE_PROFILE);
          break;
        
        case "Buraco negro":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'death', true), route: RouteGenerator.ROUTE_SATELLITE_PROFILE);
      }
    });
    
  }
}