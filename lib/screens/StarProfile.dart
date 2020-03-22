import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/StarSystemPlanetary.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class StarProfile extends StatefulWidget {
  StarProfile({this.id});

  final id;

  @override
  _StarProfileState createState() => _StarProfileState();
}

class _StarProfileState extends State<StarProfile > {

  var nameController = TextEditingController();
  var sizeController = TextEditingController();
  var massController = TextEditingController();
  var ageController = TextEditingController();
  var distanceController = TextEditingController();
  var typeController = TextEditingController();
  var death;

  Api db = Api();

  var _selectedColor = 0;
  
  var gases;  
  Future future;
  var systems;

   _getSystems() async{
    List items = await db.getWhere('starSystemPlanetary', StarSystemPlanetary, 'starId', widget.id);
    List systems = [];

    if (items != null){
      var system;
      for (StarSystemPlanetary psp in items){
        system = await db.getdocbyId('system', psp.systemId);
        systems.add(PlanetarySystem.fromMap(system));
      }
    }
    return systems;
  }

  _getStar() async{

    Map<String, dynamic> data = await db.getbyId("star", widget.id);
    nameController.text = data["name"];
    sizeController.text = data["size"];
    massController.text = data["mass"];
    ageController.text = data["age"];
    typeController.text = data["type"];
    _selectedColor = data["colorId"];
    death = data["death"];
    return widget.id;
  }


  @override
  void initState() {
    super.initState();
    future = _getStar();
    systems = _getSystems();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, RouteGenerator.ROUTE_STARS);
         return false;
       },
      child: Scaffold(
        body: FutureBuilder(
                future: future,
                builder: (context, snapshot){
                switch (snapshot.connectionState){
                  case ConnectionState.none:
                    case ConnectionState.waiting:
                    return Center(
                      child:  Center(child: CircularProgressIndicator())
                    );
                    case ConnectionState.active:
                    case ConnectionState.done:  
                      return  SingleChildScrollView(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Stack(
                              children: <Widget>[
                                  Center(
                                    child: ClipPath(
                                      clipper: OvalBottomBorderClipper(),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                            colors: [Colors.pinkAccent[700], Colors.purple[900] ])
                                        ),
                                        height: 180,
                                        width: 1000,
                                      ),
                                    ),
                                  ),
                                  Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 100.0, bottom: 0),
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                          child: FlareActor(
                                              //'assets/animations/pinkPlanet.flr',
                                              'assets/animations/'+ starAssets[_selectedColor] + 'Star.flr',
                                              animation: 'rotation',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                            ),
                            Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, RouteGenerator.ROUTE_STARS);
                                      },
                                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 25.0),
                                    ),
                                  ),
                            Positioned(
                                      right: 5,
                                      child: Padding(
                                      padding: const EdgeInsets.only(top: 25.0),
                                      child: IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, RouteGenerator.ROUTE_EDIT_STAR, arguments: widget.id);
                                        },
                                        icon: Icon(Icons.edit, color: Colors.white, size: 25.0),
                                      ),
                                    ),
                            )
                              ],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                            child: Info(nameController: nameController, sizeController: sizeController, massController: massController, ageController: ageController, distanceController: distanceController, typeController: typeController, death: death)
                        )
                        ),

                        Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                            child: Text("Sistemas Planetários", style: TextStyle(color: Colors.purple[700], fontSize: 19),),
                        ),      
                        FutureBuilder(
                          future: systems,
                          builder: (context, snapshot){
                            switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                case ConnectionState.done:  
                                  if (snapshot.hasData){
                                    if (snapshot.data.length != 0){
                                      return Container(
                                        padding: EdgeInsets.only(left:15),
                                        height: 180, 
                                        child: HorizontalList(list: snapshot.data, asset: 'assets/svg/galaxy.svg',editable: false)
                                      );
                                    }else{
                                      return Padding(
                                      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                      child: Center(child: Text("Não pertence há sistemas", style: TextStyle(color: Colors.white70, fontSize: 16)),),
                                    );
                                    }
                                  }else{
                                    return Container();
                                  }
                              }
                          }
                        ), 

                        ]
                      ),
                       );
                }

             }
            )
      ),
    );
  }
}


class Info extends StatelessWidget {
  Info({this.nameController, this.sizeController, this.massController, this.ageController, this.distanceController, this.typeController, this.death, this.components});

  var nameController;
  var sizeController;
  var massController;
  var ageController;
  var distanceController;
  var typeController;
  var deathController = TextEditingController();
  var death;
  final components;

  @override
  Widget build(BuildContext context) {

    if(death == "true") {
      deathController.text = "Estrela Morta";
    } else {
      deathController.text = "Estrela viva";
    }

    return Container(
          padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
               padding: const EdgeInsets.all(8.0),
               child: OutputField(controller: nameController, title: "Nome",)
            ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(controller: sizeController, title: "Tamanho",),
            ), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(title: "Massa", controller: massController,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(title: "Idade", controller: ageController,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(title: "Tipo", controller: typeController,),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(title: "Morte", controller: deathController,),
            ),
            
          ],
            ),
          margin: const EdgeInsets.symmetric(
           vertical: 10.0,
           horizontal: 10.0,
         ),
          width: 500.0,
          decoration: BoxDecoration(
            color: Color(0xff380b4c),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: [new BoxShadow(
            color: Color(0xff280538),
            blurRadius: 20.0,)],
          ),
    );
  }
}
