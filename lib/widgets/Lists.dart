import 'package:flutter/material.dart';
import 'package:galaxy_flutter/widgets/Cards.dart';
import 'package:galaxy_flutter/widgets/Animations.dart';

class HorizontalList extends StatefulWidget {

    final tipo;
    final lista;
    final editable;

    const HorizontalList({Key key, this.lista, this.tipo, this.editable}): super(key:key);

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
          card = OrbitingCard(title: widget.lista[index], svg:'assets/svg/moon2.svg', editable: widget.editable);
        }else if(widget.tipo == "Gas"){
          card = GasCard(title: widget.lista[index], index: index, editable: widget.editable);
        }else if(widget.tipo == "Estrela"){
          card = OrbitingCard(title: widget.lista[index], svg:'assets/svg/star4.svg', editable: widget.editable);
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
  const NameList({this.type, this.future, this.rota});

  final String type;
  final future;
  final rota;

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
                              rota, 
                              arguments: item.id)
                          ),
                        );
                      }
                    );
                  }
                }
              },          ));
  }
}

/* Lista de Galáxias
Container(
          color: Color(0xff380b4c),
          padding: EdgeInsets.only(top: 20),
          child: FutureBuilder(
            future: getGalaxies(),
            builder: (context, snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                return Center(
                  child:  CircularProgressIndicator()
                );
                case ConnectionState.active:
                case ConnectionState.done:  

                  if (snapshot.data.length == 0){
                    return Center(child: Text("Sem nada por aqui :c", style: TextStyle(color: Colors.white70, fontSize: 25),),);
                  } else { 
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {

                      List<Galaxy> galaxias = snapshot.data;
                      Galaxy galaxia = galaxias[index];
                      return Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: RowList(
                          title: galaxia.nome, 
                          asset: 'assets/animations/planetList.flr', 
                          action: () => Navigator.pushNamed(
                            context, 
                            RouteGenerator.ROUTE_GALAXY_PROFILE, 
                            arguments: galaxia)
                        ),
                      );
                    }
                  );
                 }

              }
            },          ),
        ),



*/