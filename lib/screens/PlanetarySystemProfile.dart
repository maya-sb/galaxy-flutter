import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Planet.dart';
import 'package:galaxy_flutter/models/PlanetSystemPlanetary.dart';
import 'package:galaxy_flutter/models/Star.dart';
import 'package:galaxy_flutter/models/StarSystemPlanetary.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class PlanetarySystemProfile extends StatefulWidget {
  PlanetarySystemProfile({this.id});

  final id;

  @override
  _PlanetarySystemProfileState createState() => _PlanetarySystemProfileState();
}

class _PlanetarySystemProfileState extends State<PlanetarySystemProfile> {

  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var numPlanetsController = TextEditingController();
  var numStarsController = TextEditingController();
  var galaxyController = TextEditingController();
  int _selectedColor = 0;
  String _galaxyId;
  var planets;
  var stars;

  Api db = Api();

  Future future;

  _getSystem() async{

    Map<String, dynamic> data = await db.getbyId("system", widget.id);
    nameController.text = data["name"];
    ageController.text = data["age"] + " bilhões de anos";
    numPlanetsController.text = data["numPlanets"].toString();
    numStarsController.text = data["numStars"].toString();
    _galaxyId = data["galaxyId"];
    _selectedColor = data["colorId"];
    return widget.id;
  }


  _getPlanets() async{
    List items = await db.getWhere('planetSystemPlanetary', PlanetSystemPlanetary, 'systemId', widget.id);
    List planets = [];

    if (items != null){
      var planet;
      for (PlanetSystemPlanetary psp in items){
        planet = await db.getdocbyId('planet', psp.planetId);
        planets.add(Planet.fromMap(planet));
      }
    }
    return planets;
  }

  _getStars() async{
    List items = await db.getWhere('starSystemPlanetary', StarSystemPlanetary, 'systemId', widget.id);
    List stars = [];

    if (items != null){
      var star;
      for (StarSystemPlanetary ssp in items){
        star = await db.getdocbyId('star', ssp.starId);
        stars.add(Star.fromMap(star));
      }
    }
    return stars;
  }

  @override
  void initState() {
    super.initState();
    future = _getSystem();
    planets = _getPlanets();
    stars = _getStars();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        Navigator.pushNamed(context, RouteGenerator.ROUTE_PLANETARY_SYSTEMS);
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
                                              'assets/animations/'+ assets[_selectedColor] + 'System.flr',
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
                                        Navigator.pushNamed(context, RouteGenerator.ROUTE_PLANETARY_SYSTEMS);
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
                                          Navigator.pushNamed(context, RouteGenerator.ROUTE_EDIT_PLANETARY_SYSTEM, arguments: widget.id);
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
                            child: FutureBuilder(
                              future: db.getbyId('galaxy', _galaxyId),
                              builder: (context, snapshot){
                                switch(snapshot.connectionState){
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return Center(child: CircularProgressIndicator());
                                  case ConnectionState.active:
                                  case ConnectionState.done:  
                                    galaxyController.text = snapshot.data["name"];
                                    return Info(nameController: nameController, ageController: ageController, numStarsController: numStarsController, numPlanetsController: numPlanetsController, galaxyController: galaxyController,);
                                }
                              },
                              
                          ),
                        ),),
                        numPlanetsController.text == '0' 
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0, right: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Planetas", style: TextStyle(color: Colors.purple[700], fontSize: 19),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: Center(child: Text("Não há planetas", style: TextStyle(color: Colors.white70, fontSize: 16)),),
                                )
                              
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                            child: Text("Planetas", style: TextStyle(color: Colors.purple[700], fontSize: 19),),
                          ),     
                         numPlanetsController.text == '0' 
                         ? Container() 
                         : FutureBuilder(
                          future: planets,
                          builder: (context, snapshot){
                            switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                case ConnectionState.done:  
                                  return Container(
                                    padding: EdgeInsets.only(left:15),
                                    height: 180, 
                                    child: HorizontalList(list: snapshot.data, asset: 'assets/svg/uranus.svg',editable: false)
                                  );
                              }
                          }
                        ),
                        numStarsController.text == '0' 
                        ? Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0, right: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text("Estrelas", style: TextStyle(color: Colors.purple[700], fontSize: 19),),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                                  child: Center(child: Text("Não há estrelas", style: TextStyle(color: Colors.white70, fontSize: 16)),),
                                )
                              
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                            child: Text("Estrelas", style: TextStyle(color: Colors.purple[700], fontSize: 19),),
                          ),   
                        numStarsController.text == '0' 
                        ? Container()
                        : FutureBuilder(
                          future: stars,
                          builder: (context, snapshot){
                            switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                case ConnectionState.active:
                                case ConnectionState.done:  
                                  return Container(
                                    padding: EdgeInsets.only(left:15),
                                    height: 180, 
                                    child: HorizontalList(list: snapshot.data, asset: 'assets/svg/stars.svg',editable: false)
                                  );
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
  Info({this.nameController, this.ageController, this.numStarsController, this.numPlanetsController, this.galaxyController});

  final nameController;
  final ageController;
  final numStarsController;
  final numPlanetsController;
  final galaxyController;

  @override
  Widget build(BuildContext context) {

    return Container(
          padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: OutputField(title: "Nome", controller: nameController),
             ), 
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(
                title: "Galáxia", 
                controller: galaxyController, 
            ),), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(
                title: "Idade", 
                suffixText: "bilhões de anos",
                controller: ageController,  
            ),), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(
                title: "Nº de Planetas", 
                controller: numPlanetsController, 
            ),),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(
                title: "Nº de Estrelas", 
                controller: numStarsController, 
            ),),
            
            
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