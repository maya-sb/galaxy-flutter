import 'package:flutter/material.dart';

class CadastroPlaneta extends StatefulWidget {
  @override
  _CadastroPlanetaState createState() => _CadastroPlanetaState();
}

class _CadastroPlanetaState extends State<CadastroPlaneta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Planeta", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete) ,
            onPressed: (){
              showDialog(context: context, builder :(context){
                return AlertDialog(
                  title: Text("Deseja remover o planeta permanentemente?"),
                  //content: Text("Deseja remover o planeta permanentemente?"),
                  actions: <Widget>[
                    FlatButton(child: Text("Sim"),onPressed: (){
                      //TO DO removerPlaneta();
                    },),
                    FlatButton(child: Text("Cancelar"),onPressed: (){
                        Navigator.pop(context);
                    },)
                  ],);
              });
            },),
        ],
        backgroundColor: Colors.transparent
        //backgroundColor: Colors.purple[900],
       ),
      backgroundColor: Color(0xff380b4c),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          ExpansionPanelList(body: )
        ],),
      ),

      );
  }
}