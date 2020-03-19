import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/models/Planet.dart';
import 'package:galaxy_flutter/models/Satellite.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';

class RegisterOrbit extends StatefulWidget {
  @override
  _RegisterOrbitState createState() => _RegisterOrbitState();
}

class _RegisterOrbitState extends State<RegisterOrbit> {

  _discardChanges(){
    Navigator.pop(context);
    Navigator.pop(context);
  }

  final _formKey = GlobalKey<FormState>();
  var satelliteController = TextEditingController();
  var planetController = TextEditingController();
  var starController = TextEditingController();

  var planetList; 
  var satelliteList;
  var starList;

  Api db = Api();

  loadList(String collectionName, var type) async{

    var list = await db.getAll(collectionName, type);
    List<DropdownMenuItem<String>> items = [];

    for (var item in list){
      items.add(DropdownMenuItem(
        child: Text(item.name,  style: TextStyle(
                                color: Colors.purple[700],
                                fontFamily: "Poppins",
                                fontSize: 18.0,)),
        value: item.id,
      ));
    }

    return items;
  }

  @override
  void initState() {
    super.initState();
    planetList = loadList('planet', Planet);
    satelliteList = loadList('satellite', Satellite);
    starList = loadList('planet', Planet);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
        showDialog(context: context, builder: (context) {
            return confirmExitRemove(title: "Descartar Órbita", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
          });
         return false;
       },
        child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: (){
            if (_formKey.currentState.validate()) {
              //TODO cadastrar órbita

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
                                 'assets/animations/pinkGalaxy.flr',
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
                            return confirmExitRemove(title: "Descartar Órbita", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
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
                    child: Info(satelliteController: satelliteController, starController: starController, planetController: planetController, planetList: planetList, starList: starList, satelliteList: satelliteList)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Info extends StatefulWidget {
  Info({this.satelliteController, this.starController, this.planetController, this.satelliteList, this.starList, this.planetList});

  final satelliteController;
  final starController;
  final planetController;
  final satelliteList;
  final starList;
  final planetList;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

  var selectedPlanet;
  var selectedStar;
  var selectedSatellite;

  @override
  Widget build(BuildContext context) {
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
                               return DropdownButtonFormField(
                                    items: snapshot.data,
                                    validator: (var value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Selecione um planeta';
                                      }
                                      return null;
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
                                        selectedPlanet = newValue;
                                        widget.planetController.text = newValue;
                                      });
                                            },
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
                               return DropdownButtonFormField(
                                    items: snapshot.data,
                                    validator: (var value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Selecione um satélite';
                                      }
                                      return null;
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
                                        selectedSatellite = newValue;
                                        widget.satelliteController.text = newValue;
                                      });
                                            },
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
                               return DropdownButtonFormField(
                                    items: snapshot.data,
                                    validator: (var value) {
                                      if (value?.isEmpty ?? true) {
                                        return 'Selecione uma estrela';
                                      }
                                      return null;
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
                                    value: selectedStar,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedStar = newValue;
                                        widget.starController.text = newValue;
                                      });
                                            },
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
          padding: EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text("Planeta", style: TextStyle(
                                      color: Colors.purple[700],
                                      fontFamily: "Poppins",
                                      fontSize: 18.0,),),
              Text("Satélite", style: TextStyle(
                                      color: Colors.purple[700],
                                      fontFamily: "Poppins",
                                      fontSize: 18.0,),),
              Text("Estrela", style: TextStyle(
                                      color: Colors.purple[700],
                                      fontFamily: "Poppins",
                                      fontSize: 18.0,),),
            ],),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              
            Text(""),
          ],)
          )
      ],
    );
  }
}

