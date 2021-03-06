import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';

class OrbitingCard extends StatelessWidget {
  const OrbitingCard({this.title, this.svg, this.editable: false});

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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(title, style: TextStyle(color: Color(0xff380b4c), fontSize: title.length < 23 ? 16 : 13),),
              ),
              SizedBox.fromSize(
                  child:  SvgPicture.asset(svg, color: Color(0xff380b4c)),
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
            color: Colors.white70,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
        ),
        ),
        editable ? Positioned(top: 7, right: 0, 
        child: IconButton(icon: Icon(Icons.clear,color:Color(0xff380b4c),),  
          onPressed: (){
            showDialog(context: context, builder :(context){ 
              return confirmExitRemove(title: "Tem certeza que deseja remover?", action: () => Navigator.pop(context));},);},),) 
        : Positioned(top: 7, right: 0, child: SizedBox.shrink(),)
        ]
    );
  }
}

class OrbitCard extends StatelessWidget {
  const OrbitCard({this.title, this.asset});

  final title;
  final asset;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              this.asset != null ?
              SizedBox.fromSize(
                  child: FlareActor(
                                  this.asset,
                                  animation: 'rotation',
                                  fit: BoxFit.cover,
                                ),
                  size: Size(80.0, 80.0),
                ) : Container(height: 80.0, width: 80.0,),
                this.title != null ?
                Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(title, style: TextStyle(color: Color(0xff380b4c), fontSize: title.length < 23 ? 16 : 12),),
              ) : Container(padding: EdgeInsets.only(top:30.0),)
            ],
          ),
          margin: const EdgeInsets.symmetric(
           vertical: 10.0,
           horizontal: 5.0,
         ),
          width: 116.0,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white70,
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
        ),
        ),
        ]
    );
  }
}

class GasCard extends StatelessWidget {
  const GasCard ({this.title, this.index, this.editable: false});

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
            showDialog(context: context, builder :(context){ 
              return confirmExitRemove(title: "Tem certeza que deseja remover?", action: () => Navigator.pop(context));},);}
            ))
         : Positioned(top: 7, right: 0, child: SizedBox.shrink(),)
        ]
    );
  }
}

class CardAdd extends StatelessWidget {
  const CardAdd({this.isGas:false});

  final isGas;

  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(10),
          child: InkWell(
              onTap: (){
                showDialog(context: context, builder: (context){

                    if (this.isGas){

                    }else{
                      return addHorizontalList(list: ["Sol", "Sol", "Sol", "Sol", "Sol", "Sol", "Sol", "Marte", "Vênus", "Sol", "Terra"],title: "Adicionar Satélite", create: () => null, save: () => null,);
                    }

                });
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

class CardList extends StatelessWidget {
  const CardList({this.title, this.actionOnTap, this.item, this.db});

  final title;
  final actionOnTap;
  final item;
  final db;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: actionOnTap,
      child: Container(
        child: Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title != null 
            ? Padding(
              padding: title.length < 23 ? const EdgeInsets.only(left: 16.0) : const EdgeInsets.only(left: 44.0) ,
              child: (Text(title, 
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff380b4c), fontSize: 20, ),)),
            )
            : FutureBuilder(
              future: db.getbyId('planet',item.planetId),
              builder: (context,snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  case ConnectionState.done:  
                    if (snapshot.hasData){
                      return Text(snapshot.data["name"], style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff380b4c), fontSize: snapshot.data["name"].length < 26 ? 20 : 15, ));
                    }else{
                      return Container();
                    }
                }
              },),
              title != null 
              ? Container ()
              : FutureBuilder(
              future: db.getbyId('satellite',item.satelliteId),
              builder: (context,snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                  case ConnectionState.done:  
                    if (snapshot.hasData){
                      return Text(snapshot.data["name"], style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff380b4c), fontSize: snapshot.data["name"].length < 26 ? 20 : 15, ));
                    }else{
                      return Container();
                    }
                }
              },
            ),
              title != null 
              ? Container ()
              :FutureBuilder(
                future: db.getbyId('star',item.starId),
                builder: (context,snapshot){
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:  
                      if (snapshot.hasData){
                        return Text(snapshot.data["name"], style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff380b4c), fontSize: snapshot.data["name"].length < 26 ? 20 : 15, ));
                      }else{
                        return Container();
                      }
                  }
                },
              )
          ],
        )),
        height: 120.0,
        margin: EdgeInsets.only(left: 60.0, right: 20 ),
        decoration:
        BoxDecoration(
          color: Colors.purple[800],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [BoxShadow(
            color: Color(0xff280538),
            blurRadius: 20.0,)],
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops:[0,4],
            colors: [Colors.pink[700], Colors.purple[800]],
          ),
      ),

      ),
    );
  }
}
