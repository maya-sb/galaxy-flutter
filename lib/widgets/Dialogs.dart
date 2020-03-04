import 'package:flutter/material.dart';

class confirmExit extends StatelessWidget {
  const confirmExit({this.title, this.action});

  final title;
  final action;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(8.0))),
    title: Text("Tem certeza que deseja sair?"),
    actions: <Widget>[
      FlatButton(child: Text("Sim"),onPressed: action
      ,),
      FlatButton(child: Text("Cancelar"),onPressed: (){
          Navigator.pop(context);
      },)
    ],);
  }
}

/*
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
);*/