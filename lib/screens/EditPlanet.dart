import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Planet.dart';
import 'package:galaxy_flutter/models/PlanetGas.dart';
import 'package:galaxy_flutter/models/PlanetSystemPlanetary.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/screens/AddGasDialog.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';

class EditPlanet extends StatefulWidget {
  EditPlanet({this.id});

  final id;

  @override
  _EditPlanetState createState() => _EditPlanetState();
}

class _EditPlanetState extends State<EditPlanet> {

  Future selectedGases;
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var sizeController = TextEditingController();
  var massController = TextEditingController();
  var rotationController = TextEditingController();

  Api db = Api();

  var selectedColor = 0;
  var dadosPlanet;
  var apagados = [];
  var adicionados = [];
  var listId = [];

  Future selectedSystems;
  var deletedSystems = [];
  var addedSystems = [];
  var listIdSystems = [];

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

  _getSystems() async{
    List items = await db.getWhere('planetSystemPlanetary', PlanetSystemPlanetary, 'planetId', widget.id);
    List systems = [];

    var system;
    for (PlanetSystemPlanetary psp in items){
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


   _getPlanet() async{

    Map<String, dynamic> data = await db.getbyId("planet", widget.id);
    nameController.text = data["name"];
    sizeController.text = data["size"];
    massController.text = data["mass"];
    rotationController.text = data["rotationSpeed"];
    selectedColor = data["colorId"];
    return widget.id;
  }

  _getGases() async{
    List items = await db.getWhere('planetGas', PlanetGas, 'planetId', widget.id);
    List gases = [];
    var gas;
    for (PlanetGas sg in items){
      gas = await db.getbyId('gas', sg.gasId);
      gases.add({"name": gas["name"], "amount": sg.amount, "id": sg.id, "gasId": sg.gasId});
    }
    return gases;
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

  var gases;

  getGases(var gasesBanco){
    gases = gasesBanco;
    if (gasesBanco != null){
      for (var gas in gasesBanco){
      listId.add(gas["gasId"]);
    }
    }
    return gases;
  }

  @override
  void initState() {
    super.initState();
    dadosPlanet = _getPlanet();
    selectedGases = _getGases();
    selectedSystems = _getSystems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: () async{
            if (_formKey.currentState.validate()) {
            
              Planet planet = Planet(id: widget.id, name: nameController.text, size: sizeController.text, mass: massController.text, rotationSpeed: rotationController.text, colorId: selectedColor);
              db.update("planet", planet);
                
              for (var plaId in apagados){
                db.delete('planetGas', plaId);
              }

              for (var gas in adicionados){
                PlanetGas planetGas = PlanetGas(gasId: gas["gasId"], planetId: widget.id, amount: gas["amount"]);
                db.insert('planetGas', planetGas);
              }

              for (var plaId in deletedSystems){
                var systemId = plaId.split("-")[0];
                await updateSystem(systemId, "-");
                db.delete('planetSystemPlanetary', plaId);
              }

              for (var system in addedSystems){
                PlanetSystemPlanetary planetSystem = PlanetSystemPlanetary(planetId: widget.id, systemId: system["id"]);
                db.insert('planetSystemPlanetary', planetSystem);
                await updateSystem(system["id"], "+");
              }

              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_PLANET_PROFILE, arguments: widget.id);

            }
            }),
        body: FutureBuilder(
            future: dadosPlanet,
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
                                            content: "A remoção do planeta implicará na remoção das órbitas que ele faz parte.",
                                            title: "Deseja remover planeta permanentemente?", 
                                            action: () async{

                                              for (var sysId in listIdSystems){
                                                await updateSystem(sysId, "-");
                                              }

                                              db.deleteOnCascade('planetSystemPlanetary', 'planetId', widget.id);
                                              db.deleteOnCascade('planetGas', 'planetId', widget.id);
                                              db.deleteOnCascade('orbit', 'planetId', widget.id);
                                              db.delete("planet", widget.id); 
                                              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_PLANETS);});
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
                                child: Info(nameController: nameController, sizeController: sizeController, massController: massController, rotationController: rotationController)),
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
                          FutureBuilder(
                            future: selectedGases,
                            builder: (context, snapshot){

                              switch (snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                case ConnectionState.done:
                                  var aux = getGases(snapshot.data);
                                  
                                  if (aux == null){
                                    return Container(); 
                                  }

                                  return Container(
                                  padding: EdgeInsets.only(left:15),
                                  height: 180,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: gases.length+1,
                                    itemBuilder: (context, index) {
                                      if (index == 0){
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: InkWell(
                                              onTap: () async{
                                                var gas = await _openAddGasDialog();
                                                if(gas != null) { 
                                                  setState(() {
                                                  adicionados.add(gas);
                                                  gases.add(gas);
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
                                                  child: Text(gases[index-1]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
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
                                                  child: Text(gases[index-1]['amount'] + '%', style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
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
                                                  var indexGas;
                                                  for (int i=0; i<adicionados.length; i++){
                                                    if(adicionados[i]["gasId"] == gases[index-1]["gasId"]){
                                                      indexGas = i;
                                                      break;
                                                    }
                                                  }
                                                  if (indexGas != null){
                                                    adicionados.removeAt(indexGas);
                                                  }else{
                                                    apagados.add(gases[index-1]["id"]);
                                                  }
                                                  listId.removeWhere((item) => item == gases[index-1]["gasId"]);
                                                  gases.removeAt(index-1);                  
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
                                  padding: EdgeInsets.only(left:15),
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
                                                    return SelectDialog(db.getAll('system', PlanetarySystem), "Adicionar Sistema Planetário",listIdSystems,"um sistema");
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
                                                  child: Text(systems[index-1]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
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
                                                    deletedSystems.add(systems[index-1]["id"]);
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
