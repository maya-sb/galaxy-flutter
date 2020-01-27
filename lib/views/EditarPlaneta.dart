import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:galaxy_flutter/views/Planetas.dart';
import 'package:intl/intl.dart';

class EditarPlaneta extends StatefulWidget {
  @override
  _EditarPlanetaState createState() => _EditarPlanetaState();
}

class _EditarPlanetaState extends State<EditarPlaneta> {

  var satelites = ["","Tritão", "Talassa", "Náiade", "Nereida", "Proteu"];
  var gases = ["","Óxido Nítrico", "Nitrogênio", "Argônio", "Oxigênio", "Vapor d'Água"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              /*
              showDialog(context: context, builder :(context){
                return AlertDialog(
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
            },),
        ],
  
       ),
       */
      backgroundColor: Color(0xff380b4c),
      body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Stack(
                  children: <Widget>[
                    ClipPath(
                      clipper: OvalBottomBorderClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [Colors.pinkAccent[700], Colors.purple[900] ])
                        ),
                        height: 180,
                        width: 500 ,
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
                    )

                  ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Info(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,),
              child: Text("Composição", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ), 
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 180, 
              child: HorizontalList(lista: gases, tipo:"Gas")),  
            Padding(
              padding: const EdgeInsets.only(left: 20.0, bottom: 10.0,  top:10.0),
              child: Text("Satélites", style: TextStyle(color: Colors.pink[800], fontSize: 18),),
            ),      
            Container(
              padding: EdgeInsets.only(left:10, right: 10),
              height: 180, 
              child: HorizontalList(lista: satelites, tipo:"Satelite")),    
             
          ],
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
        }else{
          card = GasCard(widget.lista[index], index);
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
        Positioned(top: 7, right: 5, child: IconButton(onPressed: (){
            
        },
        icon: Icon(Icons.more_vert,color: Color(0xff380b4c),),)),
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

    var quant = ["95,33%", "2,7%","1,6%","0,13%","0,07%","0,03%"];

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
        Positioned(top: 7, right: 5, child: IconButton(onPressed: (){
            
        },
        icon: Icon(Icons.more_vert,color: Color(0xff380b4c),),)),
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

    var tamanhoFormat = NumberFormat("###,###.00#", "pt_BR");

    return Container(
          padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: TextFormField(
                      initialValue: "Marte",
                      //focusNode: myFocusNode,
                      autofocus: false,
                      decoration: new InputDecoration(
                        labelText: "Nome",
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.purple[700],
                            width: 3
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.purple[700],
                            width: 1.5
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.pink[700],
                            width: 3
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.pink[700],
                            width: 1.5
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.pink[700],
                        )

                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Nome inválido";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                      ),
                    ),
             ),  
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      initialValue: tamanhoFormat.format(5496666244).toString(),
                      //focusNode: myFocusNode,
                      autofocus: false,
                      decoration: new InputDecoration(
                        labelText: "Tamanho",
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.purple[700],
                            width: 3
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.purple[700],
                            width: 1.5
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.pink[700],
                            width: 3
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.pink[700],
                            width: 1.5
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.pink[700],
                        )

                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Tamanho inválido";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                      ),
                    ),
                ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      //focusNode: myFocusNode,
                      autofocus: false,
                      decoration: new InputDecoration(
                        labelText: "Massa",
                        labelStyle: TextStyle(color: Colors.purple[700]),
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.purple[700],
                            width: 3
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.purple[700],
                            width: 1.5
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.pink[700],
                            width: 3
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                            color: Colors.pink[700],
                            width: 1.5
                          ),
                        ),
                        errorStyle: TextStyle(
                          color: Colors.pink[700],
                        )

                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if(val.length==0) {
                          return "Massa inválida";
                        }else{
                          return null;
                        }
                      },
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                      ),
                    ),
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