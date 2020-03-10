import 'package:cloud_firestore/cloud_firestore.dart';

class PlanetarySystem{

  String id;
  String name;
  String age;
  String numStars;
  String numPlanets;
  String galaxyId;
  int colorId;

  PlanetarySystem({this.id, this.name, this.age, this.numStars, this.numPlanets, this.galaxyId, this.colorId});

  PlanetarySystem.fromMap(DocumentSnapshot document){
    id = document.documentID;

    this.name = document.data["name"];
    this.age = document.data["age"];
    this.numStars = document.data["numStars"];
    this.numPlanets = document.data["numPlanets"];
    this.galaxyId = document.data["galaxyId"];
    this.colorId = document.data["colorId"];
  }

   toMap(){
    return {
      "nome":this.name,
      "idade":this.age,
      "numEstrelas": this.numStars,
      "numPlanetas": this.numPlanets,
      "colorId" : this.colorId,
      "galaxyId": this.galaxyId};
  }
 
}