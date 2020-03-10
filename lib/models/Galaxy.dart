import 'package:cloud_firestore/cloud_firestore.dart';

class Galaxy{

  String id;
  String name;
  String earthDistance;
  String numSystems;

  Galaxy({this.id, this.name, this.earthDistance, this.numSystems});

  Galaxy.fromMap(DocumentSnapshot document){
    id = document.documentID;

    this.name = document.data["nome"];
    this.earthDistance = document.data["distanciaTerra"];
    this.numSystems = document.data["numSistemas"];

  }

   toMap(){
    return {
      "nome":this.name,
      "distanciaTerra":this.earthDistance,
      "numSistemas": this.numSystems};
  }
}