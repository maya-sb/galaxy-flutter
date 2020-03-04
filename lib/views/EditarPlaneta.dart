import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class EditarPlaneta extends StatefulWidget {
  @override
  _EditarPlanetaState createState() => _EditarPlanetaState();
}

class _EditarPlanetaState extends State<EditarPlaneta> {

  var satelites = ["","Tritão", "Talassa", "Náiade", "Nereida", "Proteu"];
  var gases = ["","Óxido Nítrico", "Nitrogênio", "Argônio", "Oxigênio", "Vapor d'Água"];
  var estrelas = ["", "Sol", "Sol"];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[700],
        child: Icon(Icons.save, color: Colors.white,),
        onPressed: (){
           if (formKey.currentState.validate()) {
             //TODO salvar alterações
          }else{
          }
          
      },),
      backgroundColor: Color(0xff380b4c),
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
                                'assets/animations/planetList.flr',
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
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                title: Text("Deseja remover o planeta permanentemente?"),
                                //content: Text("Deseja remover o planeta permanentemente?"),
                                actions: <Widget>[
                                  FlatButton(child: Text("Sim"),onPressed: (){
                                    //TO DO removerPlaneta();
                                    Navigator.pop(context);
                                  },),
                                  FlatButton(child: Text("Cancelar"),onPressed: (){
                                      Navigator.pop(context);
                                  },)
                                ],);
                            });
                          },
                          icon: Icon(Icons.delete, color: Colors.white, size: 25.0),
                        ),
                      ),
                )

                  ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Info(formKey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,),
              child: Text("Composição", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ), 
            Container(
              padding: EdgeInsets.only(left: 15, right: 10),
              height: 180, 
              child: HorizontalList(lista: gases, tipo:"Gas", editable: true)),  
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
              child: Text("Satélites", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ),      
            Container(
              padding: EdgeInsets.only(left:15, right: 10),
              height: 180, 
              child: HorizontalList(lista: satelites, tipo:"Satelite", editable: true,)),    
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
              child: Text("Estrelas", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ),      
            Container(
              padding: EdgeInsets.only(left:15, right: 10),
              height: 180, 
              child: HorizontalList(lista: estrelas, tipo:"Estrela", editable: true,)),    
             
          ],
        ),
      ),
    );
  }
}

class Info extends StatelessWidget {
  const Info(this.formKey);

  final formKey;

  @override
  Widget build(BuildContext context) {

    var tamanhoController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' Km');
    tamanhoController.updateValue(49244);
    var massaController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' Kg');
    massaController.updateValue(49244);
    var nomeController = TextEditingController(text: "Marte");
    var velocidadeController = MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.', rightSymbol: ' Km/s');
    velocidadeController.updateValue(5.03);

    String validatorNome (val) {
        if(val.length==0) {
          return "Nome inválido";
        }else{
          return null;
        }
    }

    String validatorMassa (val) {
        if(val.length==0) {
          return "Massa inválida";
        }else{
          return null;
        }
    }

    return Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: formKey,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: EditField(title: "Nome", controller: nomeController, validator: validatorNome, fontSize: 18,),
               ),  
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EditField(title: "Tamanho", controller: tamanhoController, validator: validatorMassa, fontSize: 18,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EditField(title: "Massa", controller: massaController, validator: validatorNome, fontSize: 18),
                ), 
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: EditField(title: "Velocidade de Rotação", controller: velocidadeController, validator: validatorNome, fontSize: 18),
                ), 
              
            ],
              ),
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

