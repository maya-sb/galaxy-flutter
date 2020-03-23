import 'package:flutter/material.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';
import 'package:galaxy_flutter/models/Orbit.dart';
import 'package:galaxy_flutter/models/Planet.dart';
import 'package:galaxy_flutter/models/Satellite.dart';
import 'package:galaxy_flutter/models/Star.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/widgets/Cards.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';

class HorizontalList extends StatefulWidget {

    final list;
    final editable;
    final asset;
    final isGas;

    const HorizontalList({Key key, this.list, this.editable, this.asset, this.isGas: false}): super(key:key);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {

  @override
  Widget build(BuildContext context) {

    if (widget.list == null){
      return Container();
    }else{
      return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.isGas ? widget.list.length+1 : widget.list.length,
      itemBuilder: (context, index) {

        if (widget.editable == true && index == 0){
          return CardAdd();

        } else { 
          if (widget.isGas){
            return GasCard(title: widget.list[index-1], index: index, editable: widget.editable);
          }else{
            return OrbitingCard(title: widget.list[index].name, svg:widget.asset, editable: widget.editable);
          }
           
        }
        
      } ,
    );
    }

    
  }
}
class RowList extends StatelessWidget {
  const RowList({this.title, this.asset, this.action});

  final title;
  final action;
  final asset;

  @override
  Widget build(BuildContext context) {
    return Container(
       height: 120.0,
       margin: const EdgeInsets.symmetric(
         vertical: 10.0,
       ),
      child: Stack(
        children: <Widget>[
          CardList(title: title, actionOnTap: action),
          Positioned (left: 10, child: Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: AnimationList(asset: asset,),
          )),
        ],
      )
    );
    
  }
}

class OrbitList extends StatelessWidget {
  OrbitList({this.item, this.action, this.asset, this.db});

  final item;
  final action;
  final asset;
  final db;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120.0,
       margin: const EdgeInsets.symmetric(
         vertical: 10.0,
       ),
      child: Stack(
        children: <Widget>[
          CardList(actionOnTap: action, item: item, db: db,),
          Positioned (left: 10, child: Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: AnimationList(asset: asset,),
          )),
        ],
      )
      
    );
  }
}

class NameList extends StatelessWidget {
  NameList({this.type, this.future, this.route, this.db, this.query=""});

  final String type;
  final future;
  final route;
  final db;
  final query;

  List lista;

  List makeList(snapshot) {
    List items = [];

    switch (type) {
      case "Satelite":
        for(var item in snapshot.data) {
          Satellite satellite = Satellite(
            id: item.id,
            name: item.name,
            size: item.size,
            mass: item.mass,
            colorId: item.colorId,
          );
          items.add(satellite);
        }
        return items;
      
      case "Planet":
        for(var item in snapshot.data) {
          Planet planet = Planet(
            id: item.id,
            name: item.name,
            size: item.size,
            mass: item.mass,
            rotationSpeed: item.rotationSpeed,
            colorId: item.colorId,
          );
          items.add(planet);
        }
        return items;
      
      case "Star":
        for(var item in snapshot.data) {
          Star star = Star(
            id: item.id,
            name: item.name,
            age: item.age,
            size: item.size,
            mass: item.mass,
            distance: item.distance,
            type: item.type,
            death: item.death,
            colorId: item.colorId,
          );
          items.add(star);
        }
        return items;
      
      case "System":
        for(var item in snapshot.data) {
          PlanetarySystem planetarySystem = PlanetarySystem(
            id: item.id,
            name: item.name,
            age: item.age,
            numStars: item.numStars,
            numPlanets: item.numPlanets,
            galaxyId: item.galaxyId,
            colorId: item.colorId,
          );
          items.add(planetarySystem);
        }
        return items;

      case "Galaxy":
        for(var item in snapshot.data) {
          Galaxy galaxy = Galaxy(
            id: item.id,
            name: item.name,
            earthDistance: item.earthDistance,
            numSystems: item.numSystems,
            colorId: item.colorId,
          );
          items.add(galaxy);
        }
        return items;
      
      case "Orbit":
        for(var item in snapshot.data) {
          Orbit orbit = Orbit(
            id: item.id,
            satelliteId: item.satelliteId,
            planetId: item.planetId,
            starId: item.starId,
          );
          items.add(orbit);
        }
        return items;
    }
  }

  @override
  Widget build(BuildContext context) {

  return Container(
          color: Color(0xff380b4c),
          padding: EdgeInsets.only(top: 20),
          child: FutureBuilder(
              future: future,
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  return Center(
                    child:  CircularProgressIndicator()
                  );
                  case ConnectionState.active:
                  case ConnectionState.done:  
                    if (snapshot.hasError){
                      return Center(child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Text("Algo de errado aconteceu.", style: TextStyle(color: Colors.white70, fontSize: 20),),
                           Text("Tente novamente mais tarde.", style: TextStyle(color: Colors.white70, fontSize: 20),),
                         ],
                       ),);                    
                    }else{
                      if (snapshot.data.length == 0){
                        return Center(child: Text("Nada por aqui :c", style: TextStyle(color: Colors.white70, fontSize: 25),),);
                      } else {
                      
                      List items = makeList(snapshot);
                      List lista = items;

                      if(type != 'Orbit') {
                        lista = query.isEmpty? items : items.where((check) => check.name.toLowerCase().contains(query.toLowerCase())).toList();
                      } 

                      return ListView.builder(
                        itemCount: lista.length,
                        itemBuilder: (context, index) {
                          List itens = lista;
                          var item = itens[index];
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: type != 'Orbit'
                            ? RowList(
                              title: item.name, 
                              asset: type == "Star" ?
                                'assets/animations/'+ starAssets[item.colorId] + type + '.flr'
                                :'assets/animations/'+ assets[item.colorId] + type + '.flr'
                              ,
                              action: () => Navigator.pushNamed(
                                context, 
                                route, 
                                arguments: item.id)
                            )
                            : OrbitList(
                              item: item,
                              action:  () => Navigator.pushNamed(
                                context, 
                                route, 
                                arguments: item.id),
                              asset:'assets/animations/'+orbitsAssets[item.orbitColor],
                              db: db,
                            ),
                          );
                        }
                      );
                    }
                }
                }
              },          ));
  }
}
