import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class Planet extends StatefulWidget {
  @override
  _PlanetState createState() => _PlanetState();
}

class _PlanetState extends State<Planet> {

  //Vai estar dentro da classe
  var satelites = ["Tritão", "Talassa", "Náiade", "Nereida", "Proteu"];
  var gases = ["Óxido Nítrico", "Nitrogênio", "Argônio", "Oxigênio", "Vapor d'Água"];
  var estrelas = ["Sol", "Sol"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            child: Text("oi"),
                      ),
                    ),
                ),
                Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteGenerator.ROUTE_PLANETAS);
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
                             Navigator.pushNamed(context, RouteGenerator.ROUTE_EDITAR_PLANETA);
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
                child: Info(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,),
              child: Text("Composição", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ), 
            Container(
              padding: EdgeInsets.only(left: 15),
              height: 180, 
              child: HorizontalList(lista: gases, tipo:"Gas", editable: false)),  
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
              child: Text("Satélites", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ),      
            Container(
              padding: EdgeInsets.only(),
              height: 180, 
              child: HorizontalList(lista: satelites, tipo:"Satelite", editable: false)
            ), 
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
              child: Text("Estrelas", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ),      
            Container(
              padding: EdgeInsets.only(left:15),
              height: 180, 
              child: HorizontalList(lista: estrelas, tipo:"Estrela", editable: false)
            ),

            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
              child: Text("Corrr", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ),      

            Container(
              padding: EdgeInsets.only(left:15),
              child: Row(
                children: <Widget>[
                  
                  RawMaterialButton(
                    onPressed: () {},
                    child: new Icon(
                      Icons.pause,
                      color: Colors.blue,
                      size: 35.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.white,
                    padding: const EdgeInsets.all(15.0),
                  ),

                ],
              ),
            ),
             
          ],
        ),
      ),
      
    );
  }
}


//TODO Dá pra otimizar isso também
class Info extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var tamanhoController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' Km');
    tamanhoController.updateValue(49244);
    var massaController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' Kg');
    massaController.updateValue(49244);
    var nomeController = TextEditingController(text: "Marte");
    var velocidadeController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' Km/s');
    velocidadeController.updateValue(5.03);

    return Container(
          padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Padding(
               padding: const EdgeInsets.only(top: 25.0, bottom: 2.0),
               child: OutputField(title: "Nome", controller: nomeController),
             ),  
            Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child:  OutputField(title: "Tamanho",controller: tamanhoController)
                ),
            Padding(
                  padding: const EdgeInsets.only(bottom: 2.0),
                  child: OutputField(title: "Massa",controller: massaController)
                  ), 
             Padding(
                  padding: const EdgeInsets.only(bottom: 0.0),
                  child: OutputField(title: "Velocidade de Rotação", controller: velocidadeController)
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