import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

class CadastrarPlaneta extends StatefulWidget {
  @override
  _CadastrarPlanetaState createState() => _CadastrarPlanetaState();
}

class _CadastrarPlanetaState extends State<CadastrarPlaneta> {

  var satelites = [""];
  var gases = [""];
  var estrelas = [""];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
        showDialog(context: context, builder: (context) {
             return descartarAlteracoes(context);
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
                          onPressed: () { showDialog(context: context, builder: (context) {
                            return descartarAlteracoes(context);
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
                child: HorizontalList(lista: gases, tipo:"Gas")),  
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                child: Text("Satélites", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
              ),      
              Container(
                padding: EdgeInsets.only(left:15, right: 10),
                height: 180, 
                child: HorizontalList(lista: satelites, tipo:"Satelite")),  
              Padding(
                padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
                child: Text("Estrelas", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
              ),      
              Container(
                padding: EdgeInsets.only(left:15, right: 10),
                height: 180, 
                child: HorizontalList(lista: estrelas, tipo:"Estrela")),   
               
            ],
          ),
        ),
      ),
    );
  }
}

class HorizontalList extends StatefulWidget {

  final tipo;
  final lista;

  const HorizontalList({Key key, this.lista, this.tipo}): super(key:key);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.lista.length,
      itemBuilder: (context, index) {

        var card;
        if (widget.tipo == "Satelite"){
          card = SateliteCard(widget.lista[index]);
        }else if (widget.tipo == "Gas"){
          card = GasCard(widget.lista[index], index);
        }else if (widget.tipo == "Estrela"){
          card = EstrelaCard(widget.lista[index]);
        }

        if (index == 0){
          return CardAdd();
        }else{
          return card;
        }
      } ,
    );
  }
}

class SateliteCard extends StatelessWidget {
  const SateliteCard (this.title);

  final title;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(title, style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
              ),
              SizedBox.fromSize(
                  child:  SvgPicture.asset('assets/svg/moon2.svg'),
                  size: Size(70.0, 70.0),
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
        Positioned(top: 7, right: 0, child: _Options(),),
        ]
    );
  }
}

class EstrelaCard extends StatelessWidget {
  const EstrelaCard (this.title);

  final title;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(title, style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
              ),
              SizedBox.fromSize(
                  child:  SvgPicture.asset('assets/svg/star4.svg'),
                  size: Size(70.0, 70.0),
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
        Positioned(top: 7, right: 0, child: _Options(),),
        ]
    );
  }
}

class GasCard extends StatelessWidget {
  const GasCard (this.title, this.index);

  final title;
  final index;

  @override
  Widget build(BuildContext context) {

    var quant = [];

    return Stack(
        children: [
          Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(title, style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox.fromSize(
                    child:  SvgPicture.asset('assets/svg/ventoso.svg'),
                    size: Size(45.0, 45.0),
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: Text(quant[index], style: TextStyle(color: Color(0xff380b4c), fontSize: 16),),
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
        Positioned(top: 7, right: 0, child: _Options(),),
        ]
    );
  }
}

class CardAdd extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(10),
          child: InkWell(
              onTap: (){

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
               child: EditField("Nome", nomeController, validatorNome),
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField("Tamanho", tamanhoController, validatorNome),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField("Massa", massaController, validatorNome),
            ),
            Padding(
               padding: const EdgeInsets.all(8.0),
               child: EditField("Velocidade de Rotação", velocidadeController, validatorNome),
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

Widget _Options() => PopupMenuButton<int>(
          itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Text("Editar"),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Text("Remover"),
                ),
              ],
          icon: Icon(Icons.more_vert),
          offset: Offset(0, -100),
          shape: RoundedRectangleBorder(
          side: BorderSide(width: 1.0, style: BorderStyle.none),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
);

Widget descartarAlteracoes(context){
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text("Descartar planeta"),
        content: Text("Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?"),
        actions: <Widget>[
          FlatButton(child: Text("Sim"),onPressed: (){
            Navigator.pop(context);
            Navigator.pop(context);
          },),
          FlatButton(child: Text("Cancelar"),onPressed: (){
              Navigator.pop(context);
          },)
      ],);
  }