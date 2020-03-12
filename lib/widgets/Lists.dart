import 'package:flutter/material.dart';
import 'package:galaxy_flutter/widgets/Cards.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';

class HorizontalList extends StatefulWidget {

    final type;
    final list;
    final editable;

    const HorizontalList({Key key, this.list, this.type, this.editable}): super(key:key);

  @override
  _HorizontalListState createState() => _HorizontalListState();
}

class _HorizontalListState extends State<HorizontalList> {

  @override
  Widget build(BuildContext context) {

    if (widget.list == null){
      return Container();
    }else{
      return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        var card;
        if (widget.type == "Satellite"){
          card = OrbitingCard(title: widget.list[index], svg:'assets/svg/moon2.svg', editable: widget.editable);
        }else if(widget.type == "Gas"){
          card = GasCard(title: widget.list[index], index: index, editable: widget.editable);
        }else if(widget.type == "Star"){
          card = OrbitingCard(title: widget.list[index], svg:'assets/svg/star4.svg', editable: widget.editable);
        }else if(widget.type == "System"){
          card = OrbitingCard(title: widget.list[index].name, svg:'assets/svg/galaxy.svg', editable: widget.editable);
        }

        if (widget.editable == true && index == 0){
          return CardAdd();
        }else{
          return card;
        }
      } ,
    );
    }

    
  }
}


class RowList extends StatelessWidget {
  const RowList({this.title, this.asset, this.action});

  final title;
  final action;
  final asset;

  @override
  Widget build(BuildContext context) {
    return Container(
       height: 120.0,
       margin: const EdgeInsets.symmetric(
         vertical: 10.0,
       ),
      child: Stack(
        children: <Widget>[
          CardList(title: title, actionOnTap: action),
          Positioned (left: 10, child: Padding(
            padding: const EdgeInsets.only(top:5.0),
            child: AnimationList(asset: asset,),
          )),
        ],
      )
    );
    
  }
}

class NameList extends StatelessWidget {
  const NameList({this.type, this.future, this.route});

  final String type;
  final future;
  final route;

  @override
  Widget build(BuildContext context) {

  return Container(
          color: Color(0xff380b4c),
          padding: EdgeInsets.only(top: 20),
          child: FutureBuilder(
              future: future,
              builder: (context, snapshot){
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  return Center(
                    child:  CircularProgressIndicator()
                  );
                  case ConnectionState.active:
                  case ConnectionState.done:  
                    if (snapshot.hasError){
                      return Center(child: Column(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Text("Algo de errado aconteceu.", style: TextStyle(color: Colors.white70, fontSize: 20),),
                           Text("Tente novamente mais tarde.", style: TextStyle(color: Colors.white70, fontSize: 20),),
                         ],
                       ),);                    }else{
                    if (snapshot.data.length == 0){
                      return Center(child: Text("Nada por aqui :c", style: TextStyle(color: Colors.white70, fontSize: 25),),);
                    } else {
                    return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List itens = snapshot.data;
                        var item = itens[index];
                        return Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: RowList(
                            title: item.name, 
                            asset: 'assets/animations/'+ assets[item.colorId] + type + '.flr', 
                            action: () => Navigator.pushNamed(
                              context, 
                              route, 
                              arguments: item.id)
                          ),
                        );
                      }
                    );
                  }
                }
                }
              },          ));
  }
}
