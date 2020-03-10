import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';

class EditGalaxy extends StatefulWidget {
  EditGalaxy({this.galaxy});

  final galaxy;

  @override
  _EditGalaxyState createState() => _EditGalaxyState();
}

class _EditGalaxyState extends State<EditGalaxy> {
  
  final _formKey = GlobalKey<FormState>();
  var nomeController = TextEditingController();
  var distanciaController = TextEditingController();
  var numSistemasController = TextEditingController();

  Api bd = Api();

  @override
  Widget build(BuildContext context) {
    nomeController.text = widget.galaxy.name;
    distanciaController.text = widget.galaxy.earthDistance;
    numSistemasController.text = widget.galaxy.numSystems;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[700],
        child: Icon(Icons.save, color: Colors.white,),
        onPressed: (){
          if (_formKey.currentState.validate()) {
            Galaxy galaxy = Galaxy(name: nomeController.text, earthDistance:distanciaController.text, id: widget.galaxy.id, numSystems: widget.galaxy.numSystems);
            bd.update("galaxia", galaxy);
            Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_GALAXY_PROFILE, arguments: galaxy);
          }
          
      },),
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
                                'assets/animations/'+ assets[widget.galaxy.colorId] + 'Galaxy.flr',
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
                          Navigator.pop(context);
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
                            
                             showDialog(context: context, builder :(context){
                              return confirmExitRemove(
                                title: "Deseja remover galáxia permanentemente?", 
                                action: (){ bd.remove("galaxia", widget.galaxy.id); 
                                  Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_GALAXIES);});
                            });
                            
                          },
                          icon: Icon(Icons.delete, color: Colors.white, size: 25.0),
                        ),
                      ),
                )
                ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Form(
                  key: _formKey, 
                  child: Info(nomeController: nomeController, distanciaController: distanciaController, numSistemasController: numSistemasController,))),
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

    String validatorNome (val) {
        if(val.length==0) {
          return "Nome inválido";
        }else{
          return null;
        }
    }

    String validatorDistancia (val) {
        if(val.length==0) {
          return "Distância inválida";
        }else{
          return null;
        }
    }

    return Container(
          padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: EditField(title: "Nome", controller: nomeController, validator: validatorNome, fontSize: 18.0,),
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(
                title: "Distância da Terra", 
                controller: distanciaController, 
                validator: validatorDistancia, 
                fontSize: 18.0,
                keyboardType: TextInputType.number,
            ),), 
             /*Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(
                title: "Nº de Sistemas Planetários", 
                controller: numSistemasController, 
            ),),
            */
            
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
