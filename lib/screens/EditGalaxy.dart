import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';

class EditGalaxy extends StatefulWidget {
  EditGalaxy({this.id});

  final id;

  @override
  _EditGalaxyState createState() => _EditGalaxyState();
}

class _EditGalaxyState extends State<EditGalaxy> {
  
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var distanceController = TextEditingController();
  var numSystemsController = TextEditingController();
  int _selectedColor = 0;

  Api db = Api();
  Future future;

  _getGalaxy() async{

    Map<String, dynamic> dados = await db.getbyId("galaxy", widget.id);
    nameController.text = dados["name"];
    distanceController.text = dados["earthDistance"];
    numSystemsController.text = dados["numSystems"].toString();
    _selectedColor = dados["colorId"];
    return widget.id;
  }

  @override
  void initState() {
    super.initState();
    future = _getGalaxy();
  }

  List<Widget> _colorList() {
    var cores = [Colors.pinkAccent[200], Colors.blue[600], Colors.green[400], Colors.amber[700], Colors.deepOrange[500], Colors.grey[500]];

    List<Widget> colors = []; // this will hold Rows according to available lines
    for (int i = 0; i < 6; i++) {    
      colors.add(
        GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = i;
              });
            },
            child: CircleAvatar(
              backgroundColor: cores[i],
              child: _selectedColor == i
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : null
            ),
          ),
      );
    }
    return colors;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[700],
        child: Icon(Icons.save, color: Colors.white,),
        onPressed: (){
          if (_formKey.currentState.validate()) {
            Galaxy galaxy = Galaxy(name: nameController.text, earthDistance:distanceController.text, id: widget.id, numSystems: int.parse(numSystemsController.text), colorId: _selectedColor);
            db.update("galaxy", galaxy);
            Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_GALAXY_PROFILE, arguments: widget.id);
          }
          
      },),
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
                                            content: "A remoção da galáxia implica na remoção dos sistemas planetários pertencentes a ela.",
                                            title: "Deseja remover galáxia permanentemente?", 
                                            action: (){ 
                                              db.deleteOnCascade('system', 'galaxyId', widget.id);
                                              db.delete("galaxy", widget.id); 
                                              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_GALAXIES);});
                                        });
                                        
                                      },
                                      icon: Icon(Icons.delete, color: Colors.white, size: 25.0),
                                    ),
                                  ),
                            ),
                            ],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                            child: Form(
                              key: _formKey, 
                              child: Info(nameController: nameController, distanceController: distanceController, numSystemsController: numSystemsController,))),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                          child: Text("Cor", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: _colorList(),
                              ),
                            )        
                        ),
                        ]
                        )
          );
              }
            }
    ));
  }
}


class Info extends StatelessWidget {
  Info({this.nameController, this.distanceController, this.numSystemsController});

  final nameController;
  final distanceController;
  final numSystemsController;

  @override
  Widget build(BuildContext context) {

    String validatorName (val) {
        if(val.length==0) {
          return "Nome inválido";
        }else{
          return null;
        }
    }

    String validatorDistance (val) {
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
               child: EditField(title: "Nome", controller: nameController, validator: validatorName, fontSize: 18.0,),
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(
                title: "Distância da Terra", 
                controller: distanceController, 
                validator: validatorDistance, 
                fontSize: 18.0,
                keyboardType: TextInputType.number,
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
