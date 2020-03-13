import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

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
  Future _nameGalaxy;

  Api db = Api();

  Future future;

  _getSystem() async{

    Map<String, dynamic> data = await db.getbyId("system", widget.id);
    nameController.text = data["name"];
    ageController.text = data["age"];
    numPlanetsController.text = data["numPlanets"].toString();
    numStarsController.text = data["numStars"].toString();
    _galaxyId = data["galaxyId"];
    _selectedColor = data["colorId"];
    return widget.id;
  }

  @override
  void initState() {
    super.initState();
    future = _getSystem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      ),)
                      ]
                    ),
                     );
              }

           }
          )
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