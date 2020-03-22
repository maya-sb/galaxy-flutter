import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/models/SatelliteGas.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

import '../RouteGenerator.dart';

class SatelliteProfile extends StatefulWidget {
  SatelliteProfile({this.id});

  final id;
  
  @override
  _SatelliteProfileState createState() => _SatelliteProfileState();
}

class _SatelliteProfileState extends State<SatelliteProfile> {

  final _formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var sizeController = TextEditingController();
  var massController = TextEditingController();

  Api db = Api();

  var _selectedColor = 0;
  
  var gases;  
  Future future;

  _getSatellite() async{

    Map<String, dynamic> data = await db.getbyId("satellite", widget.id);
    nameController.text = data["name"];
    sizeController.text = data["size"];
    massController.text = data["mass"];
    _selectedColor = data["colorId"];
    return widget.id;
  }

  _getGases() async{
    List items = await db.getWhere('satelliteGas', SatelliteGas, 'satelliteId', widget.id);
    List gases = [];
 
    var gas;
    for (SatelliteGas sg in items){
      gas = await db.getbyId('gas', sg.gasId);
      gases.add({"name": gas["name"], "amount": sg.amount});
    }
    return gases;
  }

  @override
  void initState() {
    super.initState();
    future = _getSatellite();
    gases = _getGases();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
       onWillPop: () async {
        Navigator.pushNamed(context, RouteGenerator.ROUTE_SATELLITES);
         return false;
       },
      child: Scaffold(
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
                                              //'assets/animations/pinkPlanet.flr',
                                              'assets/animations/'+ assets[_selectedColor] + 'Satelite.flr',
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
                                        Navigator.pushNamed(context, RouteGenerator.ROUTE_SATELLITES);
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
                                          Navigator.pushNamed(context, RouteGenerator.ROUTE_EDIT_SATELLITE, arguments: widget.id);
                                        },
                                        icon: Icon(Icons.edit, color: Colors.white, size: 25.0),
                                      ),
                                    ),
                            )
                              ],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                            child: Info(nameController: nameController, sizeController: sizeController, massController: massController,)
                        )
                        ),
                        Padding(
                            padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                            child: Text("Composição", style: TextStyle(color: Colors.purple[700], fontSize: 19),),
                          ),      
                        FutureBuilder(
                          future: gases,
                          builder: (context, snapshot){
                            switch (snapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  return Center(
                                    child:  Center(child: CircularProgressIndicator())
                                  );
                                case ConnectionState.active:
                                case ConnectionState.done: 
                                    return Container(
                                    padding: EdgeInsets.only(left:15),
                                      height: 180,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder: (context, index) {                       
                                            return Container(
                                                padding: EdgeInsets.all(10),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: const EdgeInsets.all(0),
                                                      child: Text(snapshot.data[index]['name'], style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
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
                                                      child: Text(snapshot.data[index]['amount'] + '%', style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
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
                                            );
                                        } ,
                                      )
                                      //child: HorizontalList(list: selectedGases, editable: true, isGas: true,)
                                    );

                              }
                            
                          }
                        ), 
                        ]
                      ),
                       );
                }

             }
            )
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

    return Container(
          padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: OutputField(controller: nameController, title: "Nome",)
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(controller: sizeController, title: "Tamanho",),
              ), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutputField(title: "Massa", controller: massController,
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
