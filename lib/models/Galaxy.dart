import 'package:cloud_firestore/cloud_firestore.dart';

class Galaxy{

  String id;
  String nome;
  String distanciaTerra;
  String numSistemas;

  Galaxy({this.id, this.nome, this.distanciaTerra, this.numSistemas});

  Galaxy.fromMap(DocumentSnapshot document){
    id = document.documentID;

    this.nome = document.data["nome"];
    this.distanciaTerra = document.data["distanciaTerra"];
    this.numSistemas = document.data["numSistemas"];

  }

   toMap(){
    return {
      "nome":this.nome,
      "distanciaTerra":this.distanciaTerra,
      "numSistemas": this.numSistemas};
  }

  register(){
    Firestore db = Firestore.instance;
    db.collection("galaxias").add(this.toMap());
  }

  update(){
    Firestore db = Firestore.instance;
    db.collection("galaxias").document(this.id).updateData(this.toMap());
  }

  remove(){
    Firestore db = Firestore.instance;
    db.collection("galaxias").document(this.id).delete();
  }



}