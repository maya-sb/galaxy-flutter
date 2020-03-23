import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Cards.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

class OrbitProfile extends StatefulWidget {
  OrbitProfile({this.id});

  final id;

  @override
  _OrbitProfileState createState() => _OrbitProfileState();
}

class _OrbitProfileState extends State<OrbitProfile> {

  var satelliteController = TextEditingController();
  var planetController = TextEditingController();
  var starController = TextEditingController();

  var orbitColor = 0;
  var selectedPlanet;
  var selectedStar;
  var selectedSatellite;
  
  var orbit;

  Api db = Api();

  _getOrbit() async{
    try{
      Map<String, dynamic> data = await db.getbyId("orbit", widget.id);
      if (data["planetId"] != ""){
        selectedPlanet = await db.getbyId('planet', data["planetId"]);
        planetController.text = selectedPlanet["name"];
      }
      if (data["satelliteId"] != ""){
        selectedSatellite = await db.getbyId('satellite', data["satelliteId"]);
        satelliteController.text = selectedSatellite["name"];
      }
      if (data["starId"] != ""){
        selectedStar = await db.getbyId('star', data["starId"]);
        starController.text = selectedStar["name"];
      }
      orbitColor = data["orbitColor"];
    }catch(e){
      print(e);
    }
    return widget.id;
  }

  @override
  void initState() {
    super.initState();
    orbit = _getOrbit();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
        Navigator.pushNamed(context, RouteGenerator.ROUTE_ORBITS);
         return false;
       },
        child: Scaffold(
        body: FutureBuilder(
          future: orbit,
          builder: (context,snapshot){
             switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                    child:  Center(child: CircularProgressIndicator())
                  );
              case ConnectionState.active:
              case ConnectionState.done:  
              if (snapshot.hasData && !snapshot.hasError){
                return SingleChildScrollView(
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
                                'assets/animations/'+orbitsAssets[orbitColor],
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
                            Navigator.pushNamed(context, RouteGenerator.ROUTE_ORBITS);
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
                              Navigator.pushNamed(context, RouteGenerator.ROUTE_EDIT_ORBIT, arguments: widget.id);
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
                      child: 
                      Form(
                        child: Info(
                          satelliteController: satelliteController, 
                          starController: starController, 
                          planetController: planetController,
                          selectedPlanet: selectedPlanet,
                          selectedSatellite: selectedSatellite,
                          selectedStar: selectedStar,)),
                    ),
                  ),
                ],
              ),
            );
              }else{
                return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Algo de errado aconteceu.", style: TextStyle(color: Colors.white70, fontSize: 20),),
                    Text("Tente novamente mais tarde.", style: TextStyle(color: Colors.white70, fontSize: 20),),
                  ],
                ),); 
               }
            }
          },
        ),
      ),
    );
  }
}


class Info extends StatefulWidget {
  Info({this.satelliteController, this.starController, this.planetController, this.selectedPlanet, this.selectedSatellite, this.selectedStar});

  final satelliteController;
  final starController;
  final planetController;
  final selectedPlanet;
  final selectedStar;
  final selectedSatellite;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: <Widget>[
        Container(
              padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
              widget.selectedPlanet != null 
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutputField(title: "Planeta", controller: widget.planetController),
              ) : Container(), 
              widget.selectedSatellite != null 
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutputField(
                  title: "Satélite", 
                  controller: widget.satelliteController,  
              ),) : Container(), 
              widget.selectedStar != null 
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutputField(
                  title: "Estrela", 
                  controller: widget.starController, 
              ),) : Container(),
                
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
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              widget.selectedPlanet != null ? 
                Column(
                  children: <Widget>[
                    Text("Planeta", style: TextStyle(
                                        color: Colors.purple[700],
                                        fontFamily: "Poppins",
                                        fontSize: 18.0,),),
                    OrbitCard(title: widget.selectedPlanet["name"], asset: 'assets/animations/'+assets[widget.selectedPlanet["colorId"]]+'Planet.flr' ,),
                  ],
                ) : Container(),
              widget.selectedSatellite != null ? 
                Column(
                  children: <Widget>[
                    Text("Satélite", style: TextStyle(
                                        color: Colors.purple[700],
                                        fontFamily: "Poppins",
                                        fontSize: 18.0,),),
                  OrbitCard(title: widget.selectedSatellite["name"], asset: 'assets/animations/'+assets[widget.selectedSatellite["colorId"]]+'Satelite.flr' ,),
                  ],
                ) : Container(),
              widget.selectedStar != null ? 
                Column(
                  children: <Widget>[
                    Text("Estrela", style: TextStyle(
                                        color: Colors.purple[700],
                                        fontFamily: "Poppins",
                                        fontSize: 18.0,),),
                    OrbitCard(title: widget.selectedStar["name"], asset: 'assets/animations/'+ starAssets[widget.selectedStar["colorId"]]+'Star.flr'),
                  ],
                ) : Container() ,
          ],)
          )
      ],
    );
  }
}

