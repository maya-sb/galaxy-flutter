import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class OrbitingCard extends StatelessWidget {
  const OrbitingCard(this.title, this.svg, this.editable);

  final title;
  final svg;
  final editable;

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
                  child:  SvgPicture.asset(svg),
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
        editable ? Positioned(top: 7, right: 0, 
        child: IconButton(icon: Icon(Icons.clear,color:Color(0xff380b4c),),  
          onPressed: (){
            showDialog(context: context, builder :(context){ return removerCard(context);},);},),) 
        : Positioned(top: 7, right: 0, child: SizedBox.shrink(),)
        ]
    );
  }
}

class GasCard extends StatelessWidget {
  const GasCard (this.title, this.index, this.editable);

  final title;
  final index;
  final editable;

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
         editable 
         ? Positioned(top: 7, right: 0, child: IconButton(
           icon: Icon(Icons.clear,color:Color(0xff380b4c),), 
           onPressed: (){
            showDialog(context: context, builder :(context){ return removerCard(context);},);}
            ))
         : Positioned(top: 7, right: 0, child: SizedBox.shrink(),)
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

Widget removerCard(context){
  return AlertDialog(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0))),
    title: Text("Tem certeza que deseja remover?"),
    actions: <Widget>[
      FlatButton(child: Text("Sim"),onPressed: (){
        //TODO remover;
        Navigator.pop(context);
      },),
      FlatButton(child: Text("Cancelar"),onPressed: (){
          Navigator.pop(context);
      },)
    ],);
}
