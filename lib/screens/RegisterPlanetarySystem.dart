import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';
import '../RouteGenerator.dart';

class RegisterPlanetarySystem extends StatefulWidget {
  @override
  _RegisterPlanetarySystemState createState() => _RegisterPlanetarySystemState();
}

class _RegisterPlanetarySystemState extends State<RegisterPlanetarySystem> {

  _discardChanges(){
    Navigator.pop(context);
    Navigator.pop(context);
  }  

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var galaxyController = TextEditingController();

  Api db = Api();

  var galaxyList;

  @override
  void initState() {
    super.initState();
    //galaxyList = loadGalaxyList();
  }

  var galaxySelected;

  updateGalaxy(String id) async{
    var data = await db.getbyId('galaxy', id);

    if (data != null){
      int numSystems = data['numSystems'];
      print(numSystems);
      await db.updateField('galaxy', id, 'numSystems', numSystems+1);
    }
  }

  loadGalaxyList() async{

    var galaxies= await db.getAll("galaxy", Galaxy);
    List<DropdownMenuItem<String>> items = [];

    for (Galaxy item in galaxies){
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

  var selectedColor = 0;
  var allColors = [Colors.pinkAccent[200], Colors.blue[600], Colors.green[400], Colors.amber[700], Colors.deepOrange[500], Colors.grey[500]];

  List<Widget> _colorList() {

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

    galaxyList = loadGalaxyList();

    return WillPopScope(
        onWillPop: () async {
        showDialog(context: context, builder: (context) {
            return confirmExitRemove(title: "Descartar Sistema Planetário", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
          });
         return false;
       },
        child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: () async{
            if (_formKey.currentState.validate()) {
              PlanetarySystem system = PlanetarySystem(name: nameController.text, age:ageController.text, numStars: '0', numPlanets: '0', galaxyId: galaxyController.text, colorId: selectedColor);
              //TODO Transações
              db.insert('system', system);
              await updateGalaxy(galaxyController.text);
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
                                  'assets/animations/'+ assets[selectedColor] +'System.flr',
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
                            return confirmExitRemove(title: "Descartar Sistema Planetário", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
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
                    child: Info(nameController: nameController, ageController: ageController, galaxyController: galaxyController, galaxyList: galaxyList,)),
                ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Info extends StatefulWidget {
  Info({this.nameController, this.ageController, this.galaxyController, this.galaxyList});

  final nameController;
  final ageController;
  final galaxyController;
  final galaxyList;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

   String validatorName (val) {
        if(val.length==0) {
          return "Nome inválido";
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

    String validatorGalaxy (val){
      if (val == null){
        return "Escolha uma galáxia";
      }else{
        return val;
      }
    }

  String _selectedGalaxy;

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
               child: EditField(title: "Nome", controller: widget.nameController, validator: validatorName, fontSize: 18.0,),
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(
                title: "Idade", 
                controller: widget.ageController, 
                validator: validatorAge, 
                fontSize: 18.0,
                keyboardType: TextInputType.number,
            ),), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                    future: widget.galaxyList,
                    builder: (context, snapshot){
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                        return Center(
                          child:  CircularProgressIndicator()
                        );
                        case ConnectionState.active:
                        case ConnectionState.done:  
                          if (snapshot.data.length == 0){
                            return Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                Text("Não há galáxias cadastradas.",
                                    style: TextStyle(
                                      color: Colors.purple[700],
                                      fontFamily: "Poppins",
                                      fontSize: 16.0,),),
                                Row(mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("Por favor, primeiro ", 
                                    style: TextStyle(
                                      color: Colors.purple[700],
                                      fontFamily: "Poppins",
                                      fontSize: 16.0,),),
                                    GestureDetector(
                                      child: Text("cadastre uma galáxia.", 
                                        style: TextStyle(
                                          color: Colors.pink[700],
                                          fontFamily: "Poppins",
                                          fontSize: 16.0,),),
                                        onTap: () {
                                          Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_GALAXY);
                                        },
                                      ),
                                ],)
                              
                                      /*
                                GestureDetector(
                                  child: Text("\nCadastrar Galáxia", 
                                    style: TextStyle(
                                        color: Colors.pink[700],
                                        fontFamily: "Poppins",
                                        fontSize: 18.0,)),
                                  onTap: () {
                                    Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_GALAXY);
                                  }),
                                  */
                              ],
                              ),
                            );
                           
                          }else{ 
                            return DropdownButtonFormField(
                                items: snapshot.data,
                                validator: (String value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Selecione uma galáxia';
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
                                hint: Text("Selecione a galáxia",  style: TextStyle(
                                                                    color: Colors.purple[700],
                                                                    fontFamily: "Poppins",
                                                                    fontSize: 18.0,)),
                                style: TextStyle(
                                  color: Colors.purple[700],
                                  fontFamily: "Poppins",
                                  fontSize: 18.0,),
                                iconSize: 25,
                                isExpanded: true,
                                value: _selectedGalaxy,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedGalaxy = newValue;
                                    widget.galaxyController.text = newValue;
                                  });
                                        },
                              );
                            }

                    }
                    }
                    
                  )
                  )]));
  }
}
