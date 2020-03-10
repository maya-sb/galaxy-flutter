import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

import '../RouteGenerator.dart';

class GalaxyProfile extends StatefulWidget {
  GalaxyProfile({this.galaxy});

  final galaxy;

  @override
  _GalaxyProfileState createState() => _GalaxyProfileState();
}

class _GalaxyProfileState extends State<GalaxyProfile> {


  var nomeController = TextEditingController();
  var distanciaController = TextEditingController();
  var numSistemasController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nomeController.text = widget.galaxy.name;
    distanciaController.text = widget.galaxy.earthDistance;
    numSistemasController.text = widget.galaxy.numSystems;
    
    return Scaffold(
      body: SingleChildScrollView(
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
                                'assets/animations/planetList.flr',
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
                            Navigator.pushNamed(context, RouteGenerator.ROUTE_EDIT_GALAXY, arguments: widget.galaxy);
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
                child: Info(nomeController: nomeController, distanciaController: distanciaController, numSistemasController: numSistemasController,),
              ),
            ),
            ]
          )
        )
      );
  }
}


class Info extends StatelessWidget {
  Info({this.nomeController, this.distanciaController, this.numSistemasController});

  final nomeController;
  final distanciaController;
  final numSistemasController;

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
               child: OutputField(title: "Nome", controller: nomeController),
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(
                title: "Distância da Terra", 
                controller: distanciaController,  
            ),), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(
                title: "Nº de Sistemas Planetários", 
                controller: numSistemasController, 
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