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