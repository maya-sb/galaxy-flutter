import 'package:flutter/material.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/models/Satellite.dart';
import 'package:galaxy_flutter/models/Star.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

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
          title: Text("Estrelas", style: TextStyle(color: Colors.white)),
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
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.pink[700],),
          backgroundColor: Colors.white,
          onPressed: (){
             Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_SATELLITE);
        },),
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