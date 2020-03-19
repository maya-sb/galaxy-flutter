import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';
import '../RouteGenerator.dart';

class GalaxyProfile extends StatefulWidget {
  GalaxyProfile({this.id});

  final id;

  @override
  _GalaxyProfileState createState() => _GalaxyProfileState();
}

class _GalaxyProfileState extends State<GalaxyProfile> {

  var nameController = TextEditingController();
  var distanceController = TextEditingController();
  var numSystemsController = TextEditingController();
  int _selectedColor = 0;

  Api db = Api();

  Future future;

  _getGalaxy() async{

    Map<String, dynamic> data = await db.getbyId("galaxy", widget.id);
    nameController.text = data["name"];
    distanceController.text = data["earthDistance"];
    numSystemsController.text = data["numSystems"].toString();
    _selectedColor = data["colorId"];
    return widget.id;
  }

  @override
  void initState() {
    super.initState();
    future = _getGalaxy();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        Navigator.pushNamed(context, RouteGenerator.ROUTE_GALAXIES);
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
                                              'assets/animations/'+ assets[_selectedColor] + 'Galaxy.flr',
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
                                        Navigator.pushNamed(context, RouteGenerator.ROUTE_GALAXIES);
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
                                          Navigator.pushNamed(context, RouteGenerator.ROUTE_EDIT_GALAXY, arguments: widget.id);
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
                            child: Info(nameController: nameController, distanceController: distanceController, numSystemsController: numSystemsController,),
                          ),
                        ),
                        numSystemsController.text == '0' 
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                            child: Text("Sistemas Planetários", style: TextStyle(color: Colors.purple[700], fontSize: 19),),
                          ),      
                        FutureBuilder(
                          future: db.getWhere('system', PlanetarySystem, 'galaxyId', widget.id),
                          builder: (context, snapshot){
                            switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Center(
                                    child:  Center(child: CircularProgressIndicator())
                                  );
                                case ConnectionState.active:
                                case ConnectionState.done:  
                                  return Container(
                                    padding: EdgeInsets.only(left:15),
                                    height: 180, 
                                    child: HorizontalList(list: snapshot.data, asset: 'assets/svg/galaxy.svg',editable: false)
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
  Info({this.nameController, this.distanceController, this.numSystemsController});

  final nameController;
  final distanceController;
  final numSystemsController;

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
                title: "Distância da Terra", 
                controller: distanceController,  
            ),), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(
                title: "Nº de Sistemas Planetários", 
                controller: numSystemsController, 
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