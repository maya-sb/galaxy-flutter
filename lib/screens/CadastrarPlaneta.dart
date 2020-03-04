import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class CadastrarPlaneta extends StatefulWidget {
  @override
  _CadastrarPlanetaState createState() => _CadastrarPlanetaState();
}

class _CadastrarPlanetaState extends State<CadastrarPlaneta> {

  var satelites = [""];
  var gases = [""];
  var estrelas = [""];

  _discardChanges(){
    Navigator.pop(context);
    Navigator.pop(context);
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
          onPressed: (){
            //Cadastrar o planeta
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
                  child: Info(),
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
                child: HorizontalList(lista: satelites, tipo:"Satelite", editable: true)),  
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
      ),
    );
  }
}

class Info extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var tamanhoController;
    var massaController;
    var nomeController;
    var velocidadeController;

    String validatorNome (val) {
        if(val.length==0) {
          return "Nome inválido";
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
               child: EditField(title: "Nome", controller: nomeController, validator: validatorNome, fontSize: 18.0,),
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(title: "Tamanho", controller: tamanhoController, validator: validatorNome, fontSize: 18.0
            ),),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(title: "Massa", controller: massaController, validator: validatorNome, fontSize: 18.0),
            ),
            Padding(
               padding: const EdgeInsets.all(8.0),
               child: EditField(title: "Velocidade de Rotação", controller: velocidadeController, validator: validatorNome, fontSize: 18.0,),
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
