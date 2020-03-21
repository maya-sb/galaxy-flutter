import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Orbit.dart';
import 'package:galaxy_flutter/models/Planet.dart';
import 'package:galaxy_flutter/models/Satellite.dart';
import 'package:galaxy_flutter/models/Star.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Cards.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';

class EditOrbit extends StatefulWidget {
  EditOrbit({this.id});

  final id;

  @override
  _EditOrbitState createState() => _EditOrbitState();
}

class _EditOrbitState extends State<EditOrbit> {

   final _formKey = GlobalKey<FormState>();
  var satelliteController = TextEditingController();
  var planetController = TextEditingController();
  var starController = TextEditingController();

  var planetList; 
  var satelliteList;
  var starList;

  var selectedPlanet;
  var selectedStar;
  var selectedSatellite;

  Future orbit;

  Api db = Api();

   _getOrbit() async{
    try{
      Map<String, dynamic> data = await db.getbyId("orbit", widget.id);
      if (data["planetId"] != ""){
        var planet = await db.getdocbyId('planet', data["planetId"]);
        selectedPlanet = Planet.fromMap(planet);
        planetController.text = selectedPlanet.id;
      }
      if (data["satelliteId"] != ""){
        var satellite = await db.getdocbyId('satellite', data["satelliteId"]);
        selectedSatellite = Satellite.fromMap(satellite);
        satelliteController.text = selectedSatellite.id;
      }
      if (data["starId"] != ""){
        var star = await db.getdocbyId('star', data["starId"]);
        selectedStar = Star.fromMap(star);
        starController.text = selectedStar.id;
      }
    }catch(e){
      print(e);
    }
    return widget.id;
  }

  loadList(String collectionName, var type) async{

    var list = await db.getAll(collectionName, type);
    List<DropdownMenuItem> items = [];

     items.add(DropdownMenuItem(
        child: Text("Nenhum",  style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 18.0,)),
        value: Planet(id: "", name:"Nenhum"),
      ));
    for (var item in list){
      items.add(DropdownMenuItem(
        child: Text(item.name,  style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 18.0,)),
        value: item,
      ));
    }
   

    return items;
  }

  @override
  void initState() {
    super.initState();
    planetList = loadList('planet', Planet);
    satelliteList = loadList('satellite', Satellite);
    starList = loadList('star', Star);
    orbit = _getOrbit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: () async{
            if (_formKey.currentState.validate()) {

              Orbit orbit = Orbit(id: widget.id, satelliteId: satelliteController.text, planetId: planetController.text, starId: starController.text);            
              
              var value = await db.check(orbit, "update");

              if (value){
                await db.update('orbit', orbit);
                Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_ORBIT_PROFILE, arguments: widget.id);
              }else{
                showDialog(
                  context: context,
                  builder: (context){
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      title: Text("Erro ao atualizar órbita"),
                      content: Text("Essa órbita já existe."),
                      contentPadding: EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
                      actions: <Widget>[
                        FlatButton(child: Text("Ok"),onPressed: (){
                          Navigator.pop(context);
                        },)
                      ],
                    );
                }
              );
              }
              
              }
            }
            ),
        body: FutureBuilder(
          future: orbit,
          builder: (context, snapshot){
            switch (snapshot.connectionState){
              case ConnectionState.none:
                case ConnectionState.waiting:
                return Center(
                  child:  Center(child: CircularProgressIndicator())
                );
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
                                      'assets/animations/pinkSystem.flr',
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
                                  title: "Deseja remover a órbita permanentemente?", 
                                  action: () async{ 
                                    db.delete("orbit", widget.id); 
                                    Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_ORBITS);});
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
                          child: Info(satelliteController: satelliteController, starController: starController, planetController: planetController, planetList: planetList, starList: starList, satelliteList: satelliteList, selectedPlanet: selectedPlanet, selectedSatellite: selectedSatellite, selectedStar: selectedStar,)),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        ),
      );
  }
}


class Info extends StatefulWidget {
  Info({this.satelliteController, this.starController, this.planetController, this.satelliteList, this.starList, this.planetList, this.selectedPlanet, this.selectedSatellite, this.selectedStar});

  final satelliteController;
  final starController;
  final planetController;
  final satelliteList;
  final starList;
  final planetList;
  var selectedPlanet;
  var selectedStar;
  var selectedSatellite;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  var selectedPlanet;
  var selectedStar;
  var selectedSatellite;

  @override
  Widget build(BuildContext context) {

    selectedPlanet = widget.selectedPlanet;
    selectedStar = widget.selectedStar;
    selectedSatellite = widget.selectedSatellite;

    return  Column(
      children: <Widget>[
        Container(
              padding: EdgeInsets.all(10),
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                 Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: FutureBuilder(
                    future: widget.planetList,
                    builder: (context, snapshot){
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                        case ConnectionState.done:  
                        if (snapshot.hasData){
                          return Theme(
                            data: Theme.of(context).copyWith(
                            canvasColor: Color(0xff380b4c)),
                            child: DropdownButtonFormField(
                                items: snapshot.data,
                                validator: (var value) {
                                  if (value == null) {
                                    return 'Selecione um planeta';
                                  }else{
                                    if (value.name == "Nenhum"){
                                      var cont = 3;
                                      if (widget.planetController.text == ""){
                                        cont--;
                                      }
                                      if (widget.starController.text == ""){
                                        cont--;
                                      }
                                      if (widget.satelliteController.text == ""){
                                        cont--;
                                      }
                                      if(cont<2){
                                        return "Selecione pelo menos dois elementos";
                                      }
                                    }else{
                                      return null; 
                                    }
                                  }
                                },
                                //decoration: InputDecoration.collapsed(hintText: ''),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.purple[700],
                                      width: 1.5
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.pink[700],
                                      width: 1.5
                                    ),
                                  )
                                ),
                                hint: Text("Selecione o planeta",  style: TextStyle(
                                                                    color: Colors.purple[700],
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 18.0,)),
                                style: TextStyle(
                                  color: Colors.purple[700],
                                  fontFamily: "Poppins",
                                  fontSize: 18.0,),
                                iconSize: 25,
                                isExpanded: true,
                                isDense: true,
                                value: selectedPlanet,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selectedPlanet = newValue;
                                    widget.planetController.text = newValue.id;
                                  });
                                        },
                              ),
                          );
                          
                        }else{
                          return Container();
                        }
                      }
                    }
                   )
                 ),  
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: widget.satelliteList,
                    builder: (context, snapshot){
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                        case ConnectionState.done:  
                        if (snapshot.hasData){
                          return Theme(
                            data: Theme.of(context).copyWith(
                            canvasColor: Color(0xff380b4c)),
                            child: DropdownButtonFormField(
                                items: snapshot.data,
                                validator: (var value) {
                                  if (value == null) {
                                    return 'Selecione um satélite';
                                  }else{
                                    if (value.name == "Nenhum"){
                                      var cont = 3;
                                      if (widget.planetController.text == ""){
                                        cont--;
                                      }
                                      if (widget.starController.text == ""){
                                        cont--;
                                      }
                                      if (widget.satelliteController.text == ""){
                                        cont--;
                                      }
                                      if(cont<2){
                                        return "Selecione pelo menos dois elementos";
                                      }
                                    }else{
                                      return null; 
                                    }
                                  }
                                },
                                //decoration: InputDecoration.collapsed(hintText: ''),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.purple[700],
                                      width: 1.5
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.pink[700],
                                      width: 1.5
                                    ),
                                  )
                                ),
                                hint: Text("Selecione o satélite",  style: TextStyle(
                                                                    color: Colors.purple[700],
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 18.0,)),
                                style: TextStyle(
                                  color: Colors.purple[700],
                                  fontFamily: "Poppins",
                                  fontSize: 18.0,),
                                iconSize: 25,
                                isExpanded: true,
                                isDense: true,
                                value: selectedSatellite,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selectedSatellite = newValue;
                                    widget.satelliteController.text = newValue.id;
                                  });
                                        },
                              ),
                            );
                          
                        }else{
                          return Container();
                        }
                      }
                    }
                   )
                ), 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FutureBuilder(
                    future: widget.starList,
                    builder: (context, snapshot){
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                        case ConnectionState.done:  
                        if (snapshot.hasData){
                          return Theme(
                            data: Theme.of(context).copyWith(
                            canvasColor: Color(0xff380b4c)),
                            child: DropdownButtonFormField(
                                items: snapshot.data,
                                validator: (value) {
                                  if (value == null) {
                                    return 'Selecione uma estrela';
                                  }else{
                                    if (value.name == "Nenhum"){
                                      var cont = 3;
                                      if (widget.planetController.text == ""){
                                        cont--;
                                      }
                                      if (widget.starController.text == ""){
                                        cont--;
                                      }
                                      if (widget.satelliteController.text == ""){
                                        cont--;
                                      }
                                      if(cont<2){
                                        return "Selecione pelo menos dois elementos";
                                      }
                                    }else{
                                      return null; 
                                    }
                                  }
                                },
                                //decoration: InputDecoration.collapsed(hintText: ''),
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.purple[700],
                                      width: 1.5
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                      color: Colors.pink[700],
                                      width: 1.5
                                    ),
                                  )
                                ),
                                hint: Text("Selecione a estrela",  style: TextStyle(
                                                                    color: Colors.purple[800],
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 18.0,)),
                                style: TextStyle(
                                  color: Colors.purple[700],
                                  fontFamily: "Poppins",
                                  fontSize: 18.0,),
                                iconSize: 25,
                                isExpanded: true,
                                isDense: true,
                                value: selectedStar,
                                onChanged: (newValue) {
                                  setState(() {
                                    widget.selectedStar = newValue;
                                    widget.starController.text = newValue.id;
                                  });
                                        },
                              ),
                            );
                          
                        }else{
                          return Container();
                        }
                      }
                        }
                   )
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
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              selectedPlanet != null ? 
                selectedPlanet.id != "" ?
                Column(
                  children: <Widget>[
                    Text("Planeta", style: TextStyle(
                                        color: Colors.purple[700],
                                        fontFamily: "Poppins",
                                        fontSize: 18.0,),),
                    OrbitCard(title: selectedPlanet.name, asset: 'assets/animations/'+assets[selectedPlanet.colorId]+'Planet.flr' ,),
                  ],
                ) : Container() : Container(),
              selectedSatellite != null ? 
               selectedSatellite.id != "" ? 
                Column(
                  children: <Widget>[
                    Text("Satélite", style: TextStyle(
                                        color: Colors.purple[700],
                                        fontFamily: "Poppins",
                                        fontSize: 18.0,),),
                    OrbitCard(title: selectedSatellite.name, asset: 'assets/animations/'+assets[selectedSatellite.colorId]+'Satelite.flr' ,),
                  ],
                ) : Container() : Container(),
              selectedStar != null ? 
                selectedStar.id != "" ?
                Column(
                  children: <Widget>[
                    Text("Estrela", style: TextStyle(
                                        color: Colors.purple[700],
                                        fontFamily: "Poppins",
                                        fontSize: 18.0,),),
                    OrbitCard(title: selectedStar.name, asset: 'assets/animations/'+assets[selectedStar.colorId]+'Star.flr'),
                  ],
                ) : Container() : Container(),
          ],)
          )
      ],
    );
  }
}

