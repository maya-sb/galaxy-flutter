import 'package:flutter/material.dart';
import 'package:galaxy_flutter/widgets/Cards.dart';

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
