import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Star.dart';
import 'package:galaxy_flutter/models/StarSystemPlanetary.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';

enum DeathState { viva, morta }

class RegisterStar extends StatefulWidget {
  RegisterStar({this.type});

  final type;

  @override
  _RegisterStarState createState() => _RegisterStarState();
}

class _RegisterStarState extends State<RegisterStar> {

  _discardChanges(){
    Navigator.pop(context);
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var sizeController = TextEditingController();
  var massController = TextEditingController();
  var ageController = TextEditingController();
  var distanceController = TextEditingController();
  var deathController = TextEditingController();
  String type;

  Api db = Api();

  var _selectedColor = 0;
  List selectedSystems = [];
  List listIdSystems = [];
  
  var listId = [];

  updateSystem(String id, String op) async{
    var data = await db.getbyId('system', id);

    if (data != null){
      int numStar = data['numStar'];
      if (op == "+"){
        await db.updateField('system', id, 'numStar', numStar+1);
      }else{
        await db.updateField('system', id, 'numStar', numStar-1);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    type = widget.type;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showDialog(context: context, builder: (context) {
            return confirmExitRemove(title: "Descartar Estrela?", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
          });
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: () async{
            if (_formKey.currentState.validate()) {
              
              switch(type) {
                case "Anã branca":
                  _selectedColor = 0;
                  break;
                
                case "Anã vermelha":
                  _selectedColor = 1;
                  break;
                
                case "Gigante azul":
                  _selectedColor = 2;
                  break;
                
                case "Gigante vermelha":
                  if(deathController.text == "true") {
                    _selectedColor = 4;
                  } else {
                    _selectedColor = 3;
                  }
                  break;

                case "Estrela binária":
                  _selectedColor = 4;
                  break;
                
              }
              Star star = Star(name: nameController.text, age: ageController.text, size: sizeController.text, mass: massController.text, distance: distanceController.text, type: type, death: deathController.text, colorId: _selectedColor);

              var id = db.set('star', star);

              for (var system in selectedSystems){
                StarSystemPlanetary stSystem = StarSystemPlanetary(starId: id, systemId: system["id"]);
                db.insert('starSystemPlanetary', stSystem);
                await updateSystem(system["id"], "+");
              }

              Navigator.pop(context);

            }
          }),
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
                                'assets/animations/'+ starAssets[_selectedColor] +'Star.flr',
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
                        showDialog(context: context, builder :(context){
                          return confirmExitRemove(
                            content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?",
                            title: "Descartar Estrela?", 
                            action: _discardChanges
                          );
                        });
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 25.0),
                    ),
                  ),
                  ],
                  ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                          child: 
                            Form(
                              key: _formKey,
                              child: Info(nameController: nameController, sizeController: sizeController, massController: massController, ageController: ageController, distanceController: distanceController, type: type, deathController: deathController),
                            )
                          ),
                      ),
    
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 10.0),
                        child: Text("Sistemas Planetários", style: TextStyle(color: Colors.purple[800], fontSize: 18),),
                      ), 
                      Container(
                        padding: EdgeInsets.only(left: 15),
                        height: 180,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedSystems.length+1,
                          itemBuilder: (context, index) {
                            if (index == 0){
                              return Container(
                                padding: EdgeInsets.all(10),
                                child: InkWell(
                                    onTap: () async{
                                      
                                      var system = await showDialog(context: context, builder: (context) {
                                          return SelectDialog(db.getAll('system', PlanetarySystem), "Adicionar Sistema Planetário",listIdSystems,"sistema");
                                      });

                                      if(system!= null) { 
                                        setState(() {
                                          selectedSystems.add(system);
                                          listIdSystems.add(system["id"]);
                                        });
                                      }

                                    },
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Center(child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Text("+", style: TextStyle(color: Color(0xff380b4c), fontSize: 60),),
                                      ),
                                    ],
                                  )),
                                ),
                                margin: const EdgeInsets.symmetric(
                                vertical: 10.0,
                                horizontal: 5.0,
                              ),
                                width: 140.0,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  shape: BoxShape.rectangle,
                                  borderRadius: new BorderRadius.circular(8.0),
                              ),
                            );

                            } else { 
                              return Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Text(selectedSystems[index-1]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize: selectedSystems[index-1]['name'].length < 23 ? 16 : 13),),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox.fromSize(
                                            child: SvgPicture.asset('assets/svg/galaxy.svg'),
                                            size: Size(70.0, 70.0),
                                          ),
                                      ),
                                    ],
                                    ),
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 10.0,
                                    horizontal: 5.0,
                                  ),
                                  width: 140.0,
                                  decoration: BoxDecoration(
                                    color: Colors.white70,
                                    shape: BoxShape.rectangle,
                                    borderRadius: new BorderRadius.circular(8.0),
                                  ),
                                ),

                                Positioned(top: 7, right: 0, 
                                  child: IconButton(
                                    icon: Icon(Icons.clear,color:Color(0xff380b4c)), 
                                    onPressed: (){
                                      setState(() {
                                        listIdSystems.removeWhere((item) => item == selectedSystems[index-1]["id"]);
                                        selectedSystems.removeAt(index-1);
                                      });
                                    }
                                  )
                                )
                              ]
                            );
                            }
                          }
                        ),
                      )
                    ]
                  )                  
              )
      )
);
  }
}

class Info extends StatefulWidget {

  Info({this.nameController, this.sizeController, this.massController, this.ageController, this.distanceController, this.type, this.deathController});

  final nameController;
  final sizeController;
  final massController;
  final ageController;
  final distanceController;
  final type;
  final deathController;
  DeathState _deathState;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  DeathState deathState;

  @override
  Widget build(BuildContext context) {


    if(widget.deathController.text == "true") {
      widget._deathState = DeathState.morta;
    } else {
      widget._deathState = DeathState.viva;
    }
    
    String validatorNome (val) {
        if(val.length==0) {
          return "Nome inválido";
        }else{
          return null;
        }
    }

    String validatorSize (val) {
        if(val.length==0) {
          return "Tamanho inválido";
        }else{
          return null;
        }
    }

    String validatorMass (val) {
        if(val.length==0) {
          return "Massa inválida";
        }else{
          return null;
        }
    }

     String validatorAge (val) {
        if(val.length==0) {
          return "Idade inválida";
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

    return Theme(
          data: ThemeData(
            unselectedWidgetColor: Colors.pink[700],
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: EditField(title: "Nome", controller: widget.nameController, validator: validatorNome, fontSize: 18.0,),
               ),  
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EditField(title: "Tamanho", controller: widget.sizeController, validator: validatorSize, fontSize: 18.0, keyboardType: TextInputType.number),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EditField(title: "Massa", controller: widget.massController, validator: validatorMass, fontSize: 18.0, keyboardType: TextInputType.number ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EditField(title: "Idade", controller: widget.ageController, validator: validatorAge, fontSize: 18.0, keyboardType: TextInputType.number ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EditField(title: "Distância", controller: widget.distanceController, validator: validatorDistance, fontSize: 18.0, keyboardType: TextInputType.number ,),
              ),

              widget.type == "Gigante vermelha"
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Situação", style: TextStyle(color: Colors.purple[700]),),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget> [
                        Row(
                          children: <Widget>[
                            Radio(
                              activeColor: Colors.pink[700],
                              focusColor: Colors.pink[700],
                              hoverColor: Colors.pink[700],
                              value: DeathState.viva,
                              groupValue: widget._deathState,
                              onChanged: (DeathState value) {
                                setState(() { widget.deathController.text = "false"; });
                              },
                            ),
                            Text("Viva", style: TextStyle(color: Colors.pink[700], fontSize: 18),)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Radio(
                              activeColor: Colors.pink[700],

                              value: DeathState.morta,
                              groupValue: widget._deathState,
                              onChanged: (DeathState value) {
                                setState(() { widget.deathController.text = "true"; });
                              },
                            ),
                            Text("Morta", style: TextStyle(color: Colors.pink[700], fontSize: 18),)
                          ],
                        ),
                      ]
                    )
                  ],
                ),
              )
              : Container(),

              
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
    );
  }

}