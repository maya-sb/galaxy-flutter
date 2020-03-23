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

class EditStar extends StatefulWidget {
  EditStar({this.id});

  final id;

  @override
  _EditStarState createState() => _EditStarState();
}

class _EditStarState extends State<EditStar> {

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var sizeController = TextEditingController();
  var massController = TextEditingController();
  var ageController = TextEditingController();
  var distanceController = TextEditingController();
  var deathController = TextEditingController();
  var colorController = TextEditingController();
  String type;

  Api db = Api();

  var dadosStar;

  Future selectedSystems;
  var deletedSystems = [];
  var addedSystems = [];
  var listIdSystems = [];

  updateSystem(String id, String op) async{
    var data = await db.getbyId('system', id);

    if (data != null){
      int numStars = data['numStars'];
      if (op == "+"){
        await db.updateField('system', id, 'numStars', numStars+1);
      }else{
        await db.updateField('system', id, 'numStars', numStars-1);
      }
    }
  }

  _getSystems() async{
    List items = await db.getWhere('starSystemPlanetary', StarSystemPlanetary, 'starId', widget.id);
    List systems = [];

    var system;
    for (StarSystemPlanetary psp in items){
      system = await db.getbyId('system', psp.systemId);
      systems.add({"name": system["name"], "systemId": psp.systemId, "id": psp.id});
    }

    return systems;
  }


  var systems;

  getSystems(var systemsBanco){
    systems = systemsBanco;
    if (systemsBanco != null){
      for (var system in systemsBanco){
      listIdSystems.add(system["systemId"]);
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
    distanceController.text = data["distance"];
    type = data["type"];
    colorController.text = data["colorId"].toString();
    deathController.text = data["death"];
    return widget.id;
  }


  @override
  void initState() {
    super.initState();
    dadosStar = _getStar();
    selectedSystems = _getSystems();
  }

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: () async{
            if (_formKey.currentState.validate()) {
            
              Star star = Star(id: widget.id, name: nameController.text, age: ageController.text, size: sizeController.text, mass: massController.text, distance: distanceController.text, type: type, death: deathController.text, colorId: int.parse(colorController.text));

              db.update("star", star);

              for (var stId in deletedSystems){
                await updateSystem(stId["systemId"], "-");
                db.delete('starSystemPlanetary', stId["id"]);
              }

              for (var system in addedSystems){
                StarSystemPlanetary starSystem = StarSystemPlanetary(starId: widget.id, systemId: system["id"]);
                db.insert('starSystemPlanetary', starSystem);
                await updateSystem(system["id"], "+");
              }
            
              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_STAR_PROFILE, arguments: widget.id);

            }
            }),
        body: FutureBuilder(
            future: dadosStar,
            builder: (context,snapshot){

              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return Center(
                    child:  Center(child: CircularProgressIndicator())
                  );
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.done:
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
                                        'assets/animations/'+ starAssets[int.parse(colorController.text)] +'Star.flr',
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
                                            content: "A remoção da estrela implicará na remoção das órbitas que ela faz parte.",
                                            title: "Deseja remover estrela permanentemente?", 
                                            action: () async{

                                              for (var sysId in listIdSystems){
                                                await updateSystem(sysId, "-");
                                              }

                                              db.deleteOnCascade('starSystemPlanetary', 'starId', widget.id);
                                              db.deleteOnCascade('orbit', 'starId', widget.id);
                                              db.delete("star", widget.id); 
                                              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_STARS);});
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
                              child: 
                              Form(
                                key: _formKey,
                                child: Info(nameController: nameController, sizeController: sizeController, massController: massController, ageController: ageController, distanceController: distanceController, type: type, deathController: deathController, colorController: colorController, notifyParent: refresh),
                              )),
                          ),
        
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0, top: 10.0),
                            child: Text("Sistemas Planetários", style: TextStyle(color: Colors.purple[800], fontSize: 18),),
                          ), 
                          FutureBuilder(
                            future: selectedSystems,
                            builder: (context, snapshot){

                              switch (snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                case ConnectionState.done:
                                  var aux = getSystems(snapshot.data);
                                  
                                  if (aux == null){
                                    return Container(); 
                                  }

                                  return Container(
                                  padding: EdgeInsets.only(left: 15),
                                  height: 180,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: systems.length+1,
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
                                                  addedSystems.add(system);
                                                  systems.add(system);
                                                  listIdSystems.add(system["id"]);
                                                });}

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
                                                  child: Text(systems[index-1]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize: systems[index-1]['name'].length < 23 ? 16 : 13),),
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
                                          Positioned(top: 7, right: 0, child: IconButton(
                                            icon: Icon(Icons.clear,color:Color(0xff380b4c),), 
                                            onPressed: (){
                                                setState(() {
                                                  var indexPlanet;
                                                  for (int i=0; i<addedSystems.length; i++){
                                                    if(addedSystems[i]["id"] == systems[index-1]["systemId"]){
                                                      indexPlanet = i;
                                                      break;
                                                    }
                                                  }
                                                  if (indexPlanet != null){
                                                    addedSystems.removeAt(indexPlanet);
                                                  }else{
                                                    deletedSystems.add(systems[index-1]);
                                                  }
                                                  listIdSystems.removeWhere((item) => item == systems[index-1]["systemId"]);
                                                 systems.removeAt(index-1);                  
                                                });
                                              }
                                              ))
                                          ]
                                      );
                                        //return GasCard(title: widget.list[index-1], index: index, editable: widget.editable);
                                      }
                                      
                                    } ,
                                  )
                                  //child: HorizontalList(list: selectedGases, editable: true, isGas: true,)
                                );
                                }
                            },
                            ),
                          
                        ],
                      ),
                    );

              }

              
            },
        ),
          );
  }
}

class Info extends StatefulWidget {

  Info({this.nameController, this.sizeController, this.massController, this.ageController, this.distanceController, this.type, this.deathController, this.colorController, @required this.notifyParent});

  final nameController;
  final sizeController;
  final massController;
  final ageController;
  final distanceController;
  final type;
  final deathController;
  final colorController;
  DeathState _deathState;
  final Function() notifyParent;

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
                child: EditField(title: "Tamanho", controller: widget.sizeController, validator: validatorSize, suffixText:"Km" , fontSize: 18.0, keyboardType: TextInputType.number),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EditField(title: "Massa", controller: widget.massController, validator: validatorMass, suffixText: "massas solares", fontSize: 18.0, keyboardType: TextInputType.number ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EditField(title: "Idade", controller: widget.ageController, validator: validatorAge, suffixText: "bilhões de anos",fontSize: 18.0, keyboardType: TextInputType.number ,),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: EditField(title: "Distância da Terra", controller: widget.distanceController, validator: validatorDistance, suffixText: "anos-luz",fontSize: 18.0, keyboardType: TextInputType.number ,),
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
                                setState(() { 
                                  widget.deathController.text = "false"; 
                                  widget.colorController.text = 3.toString();
                                  widget.notifyParent();
                                  });
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
                                setState(() { 
                                  widget.deathController.text = "true";
                                  widget.colorController.text = 5.toString(); 
                                  widget.notifyParent();
                                });
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