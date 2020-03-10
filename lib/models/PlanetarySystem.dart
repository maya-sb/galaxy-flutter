import 'package:cloud_firestore/cloud_firestore.dart';

class PlanetarySystem{

  String id;
  String name;
  String age;
  String numStars;
  String numPlanets;
  Map galaxia;

  PlanetarySystem({this.id, this.name, this.age, this.numStars, this.numPlanets, this.galaxia});

  PlanetarySystem.fromMap(DocumentSnapshot document){
    id = document.documentID;

    this.name = document.data["nome"];
    this.age = document.data["idade"];
    this.numStars = document.data["numEstrelas"];
    this.numPlanets = document.data["numPlanetas"];
    this.galaxia = document.data["galaxia"];
  }

   toMap(){
    return {
      "nome":this.name,
      "idade":this.age,
      "numEstrelas": this.numStars,
      "numPlanetas": this.numPlanets,
      "galaxia": this.galaxia};
  }
 
}