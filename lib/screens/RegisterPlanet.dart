import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/models/Planet.dart';
import 'package:galaxy_flutter/models/PlanetGas.dart';
import 'package:galaxy_flutter/models/PlanetSystemPlanetary.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/screens/AddGasDialog.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

class RegisterPlanet extends StatefulWidget {
  @override
  _RegisterPlanetState createState() => _RegisterPlanetState();
}

class _RegisterPlanetState extends State<RegisterPlanet> {

  _discardChanges(){
    Navigator.pop(context);
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var sizeController = TextEditingController();
  var massController = TextEditingController();
  var rotationController = TextEditingController();

  Api db = Api();

  var selectedColor = 0;
  List selectedGases = [];
  List selectedSystems = [];
  List listIdSystems = [];

  var listId = [];

  updateSystem(String id, String op) async{
    var data = await db.getbyId('system', id);

    if (data != null){
      int numPlanets = data['numPlanets'];
      if (op == "+"){
        await db.updateField('system', id, 'numPlanets', numPlanets+1);
      }else{
        await db.updateField('system', id, 'numPlanets', numPlanets-1);
      }
    }
  }

  Future _openAddGasDialog() async {
    var gas = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) {
          return AddGasDialog(listId);
        },
      fullscreenDialog: true
      ));

    if (gas != null){
      return gas;
    }
  }

  List<Widget> _colorList() {
    var allColors = [Colors.pinkAccent[200], Colors.blue[600], Colors.green[400], Colors.amber[700], Colors.deepOrange[500], Colors.grey[500]];

    List<Widget> colors = []; // this will hold Rows according to available lines
    for (int i = 0; i < 6; i++) {    
      colors.add(
        GestureDetector(
            onTap: () {
              setState(() {
                selectedColor = i;
              });
            },
            child: CircleAvatar(
              backgroundColor: allColors[i],
              child: selectedColor == i
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
    return WillPopScope(
        onWillPop: () async {
        showDialog(context: context, builder: (context) {
            return confirmExitRemove(title: "Descartar Planeta", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
          });
         return false;
       },
        child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: () async{
            
            if (_formKey.currentState.validate()) {
            
              Planet planet = Planet(name: nameController.text, size: sizeController.text, mass: massController.text, rotationSpeed: rotationController.text, colorId: selectedColor);
              var id = db.set('planet', planet);

              for (var gas in selectedGases){
                PlanetGas planetGas = PlanetGas(gasId: gas["gasId"], planetId: id, amount: gas["amount"]);
                var idPlanetGas = id+"-"+gas["gasId"];
                db.setId('planetGas', planetGas, idPlanetGas);
              }

              for (var system in selectedSystems){
                PlanetSystemPlanetary plaSystem = PlanetSystemPlanetary(planetId: id, systemId: system["id"]);
                var idPlaSystem = system["id"] + "-"+ id;
                db.setId('planetSystemPlanetary', plaSystem, idPlaSystem);
                await updateSystem(system["id"], "+");
              }
              
              Navigator.pop(context);

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
                                 'assets/animations/'+ assets[selectedColor] +'Planet.flr',
                                  animation: 'rotation',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                  ),
                  Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: IconButton(
                          onPressed: () { showDialog(context: context, builder: (context) {
                            return confirmExitRemove(title: "Descartar Planeta", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
                          }); },
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
                    child: Info(nameController: nameController, sizeController: sizeController, massController: massController, rotationController: rotationController,),
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                child: Text("Cor", style: TextStyle(color: Colors.purple[800], fontSize: 18),),
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
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,),
                child: Text("Composição", style: TextStyle(color: Colors.purple[800], fontSize: 18),),
              ), 
                Container(
                  padding: EdgeInsets.only(left: 15, right: 10),
                  height: 180,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedGases.length+1,
                    itemBuilder: (context, index) {
                      if (index == 0){
                        return Container(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                              onTap: () async{
                                var gas = await _openAddGasDialog();
                                if(gas != null) { 
                                  setState(() {
                                  selectedGases.add(gas);
                                  listId.add(gas["gasId"]);
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
                                  child: Text(selectedGases[index-1]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox.fromSize(
                                      child: SvgPicture.asset('assets/svg/ventoso.svg'),
                                      size: Size(45.0, 45.0),
                                    ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Text(selectedGases[index-1]['amount'] + '%', style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
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
                                  listId.removeWhere((item) => item == selectedGases[index-1]["gasId"]);
                                  selectedGases.removeAt(index-1);
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
                ),
                Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 20.0, bottom: 10.0,),
                child: Text("Sistemas Planetários", style: TextStyle(color: Colors.purple[800], fontSize: 18),),
              ), 
                Container(
                  padding: EdgeInsets.only(left: 15, right: 10),
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
                                    return SelectDialog(db.getAll('system', PlanetarySystem), "Adicionar Sistema Planetário",listIdSystems, "sistema");
                                });

                                if(system != null) { 
                                  setState(() {
                                  selectedSystems.add(system);
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
                                  child: Text(selectedSystems[index-1]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SizedBox.fromSize(
                                      child: SvgPicture.asset('assets/svg/uranus.svg'),
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
                                  listIdSystems.removeWhere((item) => item == selectedSystems[index-1]["id"]);
                                  selectedSystems.removeAt(index-1);
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
                ),

            ],
          ),
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  Info({this.nameController, this.sizeController, this.massController, this.rotationController});

  final nameController;
  final sizeController;
  final massController;
  final rotationController;

  @override
  Widget build(BuildContext context) {

    
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

     String validatorRotation (val) {
        if(val.length==0) {
          return "Velocidade inválida";
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
               child: EditField(title: "Nome", controller: nameController, validator: validatorNome, fontSize: 18.0,),
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(title: "Tamanho", controller: sizeController, validator: validatorSize, fontSize: 18.0, keyboardType: TextInputType.number),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(title: "Massa", controller: massController, validator: validatorMass, fontSize: 18.0, keyboardType: TextInputType.number ,),
            ),
            Padding(
               padding: const EdgeInsets.all(8.0),
               child: EditField(title: "Velocidade de Rotação", controller: rotationController, validator: validatorRotation, fontSize: 18.0, keyboardType: TextInputType.number),
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
