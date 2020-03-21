import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Satellite.dart';
import 'package:galaxy_flutter/models/SatelliteGas.dart';
import 'package:galaxy_flutter/screens/AddGasDialog.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

class EditSatellite extends StatefulWidget {
  EditSatellite({this.id});

  final id;
  
  @override
  _EditSatelliteState createState() => _EditSatelliteState();
}

class _EditSatelliteState extends State<EditSatellite> {


  Future selectedGases;
  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var sizeController = TextEditingController();
  var massController = TextEditingController();

  Api db = Api();

  var selectedColor = 0;
  var dadosSatelite;
  var apagados = [];
  var adicionados = [];
  var listId = [];

  _getSatellite() async{

    Map<String, dynamic> data = await db.getbyId("satellite", widget.id);
    nameController.text = data["name"];
    sizeController.text = data["size"];
    massController.text = data["mass"];
    selectedColor = data["colorId"];
    return widget.id;
  }

  _getGases() async{
    List items = await db.getWhere('satelliteGas', SatelliteGas, 'satelliteId', widget.id);
    List gases = [];
    var gas;
    for (SatelliteGas sg in items){
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
    dadosSatelite = _getSatellite();
    selectedGases = _getGases();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: (){
            if (_formKey.currentState.validate()) {
            
              Satellite satellite = Satellite(id: widget.id, name: nameController.text, size: sizeController.text, mass: massController.text, colorId: selectedColor);
              db.update("satellite", satellite);
                
              for (var satId in apagados){
                db.delete('satelliteGas', satId);
              }

              for (var gas in adicionados){
                SatelliteGas satelliteGas = SatelliteGas(gasId: gas["gasId"], satelliteId: widget.id, amount: gas["amount"]);
                db.insert('satelliteGas', satelliteGas);
              }

              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_SATELLITE_PROFILE, arguments: widget.id);

            }
            }),
        body: FutureBuilder(
            future: dadosSatelite,
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
                                        'assets/animations/'+ assets[selectedColor] +'Satelite.flr',
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
                                            title: "Deseja remover satélite permanentemente?", 
                                            action: (){ 
                                              db.deleteOnCascade('satelliteGas', 'satelliteId', widget.id);
                                              db.deleteOnCascade('orbit', 'satelliteId', widget.id);
                                              db.delete("satellite", widget.id); 
                                              Navigator.popAndPushNamed(context, RouteGenerator.ROUTE_SATELLITES);});
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
                                child: Info(nameController: nameController, sizeController: sizeController, massController: massController,)),
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
                                  padding: EdgeInsets.only(left: 15, right: 10),
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
                                              color: Colors.white,
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
  Info({this.nameController, this.sizeController, this.massController});

  final nameController;
  final sizeController;
  final massController;

  @override
  Widget build(BuildContext context) {

    String validatorName (val) {
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
                title: "Tamanho", 
                controller: sizeController, 
                validator: validatorSize, 
                fontSize: 18.0,
                keyboardType: TextInputType.number,
            ),), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(
                title: "Massa", 
                controller: massController, 
                validator: validatorMass, 
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
