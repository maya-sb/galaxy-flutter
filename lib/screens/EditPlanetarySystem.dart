import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';
import 'package:galaxy_flutter/models/Planet.dart';
import 'package:galaxy_flutter/models/PlanetSystemPlanetary.dart';
import 'package:galaxy_flutter/models/Star.dart';
import 'package:galaxy_flutter/models/StarSystemPlanetary.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import '../RouteGenerator.dart';

class EditPlanetarySystem extends StatefulWidget {
  EditPlanetarySystem({this.id});

  final id;

  @override
  _EditPlanetarySystemState createState() => _EditPlanetarySystemState();
}

class _EditPlanetarySystemState extends State<EditPlanetarySystem> {

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ageController = TextEditingController();
  var galaxyController = TextEditingController();
  int _selectedColor = 0;

  Api db = Api();
  Future future;

  var galaxyList;
  String lastGalaxy;
  var numStars;
  var numPlanets;

  Future selectedPlanets;
  var deletedPlanets = [];
  var addedPlanets = [];
  var listIdPlanets = [];

  Future selectedStars;
  var deletedStars = [];
  var addedStars = [];
  var listIdStars = [];

   _getPlanets() async{
    List items = await db.getWhere('planetSystemPlanetary', PlanetSystemPlanetary, 'systemId', widget.id);
    List planets = [];

    var planet;
    for (PlanetSystemPlanetary psp in items){
      planet = await db.getbyId('planet', psp.planetId);
      planets.add({"name": planet["name"], "planetId": psp.planetId, "id": psp.id});
    }

    return planets;
  }


  var planets;

  getPlanets(var planetasBanco){
    planets = planetasBanco;
    if (planetasBanco != null){
      for (var planet in planetasBanco){
      listIdPlanets.add(planet["planetId"]);
    }
    }
    return planets;
  }

  _getStars() async{
    List items = await db.getWhere('starSystemPlanetary', StarSystemPlanetary, 'systemId', widget.id);
    List stars = [];

    var star;
    for (StarSystemPlanetary ssp in items){
      star = await db.getbyId('star', ssp.starId);
      stars.add({"name": star["name"], "starId": ssp.starId, "id": ssp.id});
    }

    return stars;
  }


  var stars;

  getStars(var starsBanco){
    stars = starsBanco;
    if (starsBanco != null){
      for (var star in starsBanco){
      listIdStars.add(star["starId"]);
    }
    }
    return stars;
  }

   _getSystem() async{

    Map<String, dynamic> data = await db.getbyId("system", widget.id);
    nameController.text = data["name"];
    ageController.text = data["age"];
    galaxyController.text = data["galaxyId"];
    numStars = data["numStars"];
    numPlanets = data["numPlanets"];
    lastGalaxy = data["galaxyId"];
    _selectedColor = data["colorId"];

    return widget.id;
  }

  updateGalaxy(String id, String op) async{
    var data = await db.getbyId('galaxy', id);

    if (data != null){
      int numSystems = data['numSystems'];
      if (op == "+"){
        await db.updateField('galaxy', id, 'numSystems', numSystems+1);
      }else{
        await db.updateField('galaxy', id, 'numSystems', numSystems-1);
      }
    }
  }

  loadGalaxyList() async{

    var galaxies= await db.getAll("galaxy", Galaxy);
    List<DropdownMenuItem<String>> items = [];

    for (Galaxy item in galaxies){
      items.add(DropdownMenuItem(
        child: Text(item.name,  style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Poppins",
                                fontSize: 15.0,)),
        value: item.id,
      ));
    }
    return items;
  }

  var allColors = [Colors.pinkAccent[200], Colors.blue[600], Colors.green[400], Colors.amber[700], Colors.deepOrange[500], Colors.grey[500]];

   List<Widget> _colorList() {

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
              backgroundColor: allColors[i],
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
  void initState() {
    super.initState();
    future = _getSystem();
    galaxyList = loadGalaxyList();
    selectedPlanets = _getPlanets();
    selectedStars = _getStars();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: () async{

            if (_formKey.currentState.validate()) {
              numPlanets = planets.length;
              numStars = stars.length;
              PlanetarySystem system = PlanetarySystem(id:widget.id, name: nameController.text, age:ageController.text, numStars: numStars, numPlanets: numPlanets, galaxyId: galaxyController.text, colorId: _selectedColor);
              //TODO Transações
              db.update('system', system);
              if (galaxyController.text != lastGalaxy){
                await updateGalaxy(galaxyController.text, "+");
                await updateGalaxy(lastGalaxy, "-");
              }

              for (var plaId in deletedPlanets){
                db.delete('planetSystemPlanetary', plaId);
              }

              for (var planet in addedPlanets){
                PlanetSystemPlanetary planetSystem = PlanetSystemPlanetary(planetId: planet["id"], systemId: widget.id);
                db.insert('planetSystemPlanetary', planetSystem);
              }

              for (var starId in deletedStars){
                db.delete('starSystemPlanetary', starId);
              }

              for (var star in addedStars){
                StarSystemPlanetary starSystem = StarSystemPlanetary(starId: star["id"], systemId: widget.id);
                db.insert('starSystemPlanetary', starSystem);
              }

              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_PLANETARY_SYSTEM_PROFILE, arguments: widget.id);
            }
            }),
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
                                              'assets/animations/'+ assets[_selectedColor] +'System.flr',
                                              animation: 'rotation',
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                              ),
                              Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: IconButton(
                                      onPressed: () => Navigator.pop(context),
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
                                            //content: "A remoção da galáxia implica na remoção dos sistemas planetários pertencentes a ela.",
                                            title: "Deseja remover o sistema planetário de forma permanente?", 
                                            action: () async{ 
                                              await updateGalaxy(lastGalaxy, "-");

                                              db.deleteOnCascade('planetSystemPlanetary', 'systemId', widget.id);
                                              db.deleteOnCascade('starSystemPlanetary', 'systemId', widget.id);
                                              db.delete("system", widget.id); 
                                              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_PLANETARY_SYSTEMS);});
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
                                child: Info(nameController: nameController, ageController: ageController, galaxyController: galaxyController, galaxyList: galaxyList,)),
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
                            child: Text("Planetas", style: TextStyle(color: Colors.purple[800], fontSize: 18),),
                          ), 
                          FutureBuilder(
                            future: selectedPlanets,
                            builder: (context, snapshot){

                              switch (snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                case ConnectionState.done:
                                  var aux = getPlanets(snapshot.data);
                                  
                                  if (aux == null){
                                    return Container(); 
                                  }

                                  return Container(
                                  padding: EdgeInsets.only(left:15),
                                  height: 180,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: planets.length+1,
                                    itemBuilder: (context, index) {
                                      if (index == 0){
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: InkWell(
                                              onTap: () async{
                                               
                                                var planet = await showDialog(context: context, builder: (context) {
                                                    return SelectDialog(db.getAll('planet', Planet), "Adicionar Planeta",listIdPlanets,"um planeta");
                                                });

                                                if(planet != null) { 
                                                  setState(() {
                                                  addedPlanets.add(planet);
                                                  planets.add(planet);
                                                  listIdPlanets.add(planet["id"]);
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
                                                  child: Text(planets[index-1]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize: planets[index-1]['name'].length < 23 ? 16 : 13),),
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
                                                  var indexPlanet;
                                                  for (int i=0; i<addedPlanets.length; i++){
                                                    if(addedPlanets[i]["id"] == planets[index-1]["planetId"]){
                                                      indexPlanet = i;
                                                      break;
                                                    }
                                                  }
                                                  if (indexPlanet != null){
                                                    addedPlanets.removeAt(indexPlanet);
                                                  }else{
                                                    deletedPlanets.add(planets[index-1]["id"]);
                                                  }
                                                  listIdPlanets.removeWhere((item) => item == planets[index-1]["planetId"]);
                                                  planets.removeAt(index-1);                  
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
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,),
                            child: Text("Estrelas", style: TextStyle(color: Colors.purple[800], fontSize: 18),),
                          ), 
                          FutureBuilder(
                            future: selectedStars,
                            builder: (context, snapshot){

                              switch (snapshot.connectionState){
                                case ConnectionState.none:
                                case ConnectionState.active:
                                case ConnectionState.waiting:
                                case ConnectionState.done:
                                  var aux = getStars(snapshot.data);
                                  
                                  if (aux == null){
                                    return Container(); 
                                  }

                                  return Container(
                                  padding: EdgeInsets.only(left:15),
                                  height: 180,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: stars.length+1,
                                    itemBuilder: (context, index) {
                                      if (index == 0){
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          child: InkWell(
                                              onTap: () async{
                                               
                                                var star = await showDialog(context: context, builder: (context) {
                                                    return SelectDialog(db.getAll('star', Star), "Adicionar Estrela",listIdStars,"uma estrela");
                                                });

                                                if(star != null) { 
                                                  setState(() {
                                                  addedStars.add(star);
                                                  stars.add(star);
                                                  listIdStars.add(star["id"]);
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
                                                  child: Text(stars[index-1]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize:  stars[index-1]['name'].length < 23 ? 16 : 13),),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: SizedBox.fromSize(
                                                      child: SvgPicture.asset('assets/svg/stars.svg', color: Color(0xff380b4c)),
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
                                                  var indexStar;
                                                  for (int i=0; i<addedStars.length; i++){
                                                    if(addedStars[i]["id"] == stars[index-1]["starId"]){
                                                      indexStar = i;
                                                      break;
                                                    }
                                                  }
                                                  if (indexStar != null){
                                                    addedStars.removeAt(indexStar);
                                                  }else{
                                                    deletedStars.add(stars[index-1]["id"]);
                                                  }
                                                  listIdStars.removeWhere((item) => item == stars[index-1]["starId"]);
                                                  stars.removeAt(index-1);                  
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
          }
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

  @override
  Widget build(BuildContext context) {

    var _selectedGalaxy =  widget.galaxyController.text;
    
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
                suffixText: "bilhões de anos",
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
                            return Theme(
                                data: Theme.of(context).copyWith(canvasColor: Color(0xff380b4c)),
                                child: DropdownButtonFormField(
                                  items: snapshot.data,
                                  validator: (var value) {
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
                                  isDense: true,
                                  isExpanded: true,
                                  value: _selectedGalaxy,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _selectedGalaxy = newValue;
                                      widget.galaxyController.text = newValue;
                                    });
                                          },
                                ),
                            );
                            }
                    }
                   
                  ))]));
  }
}