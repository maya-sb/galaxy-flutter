import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';

class Api {

  static final Api _api = Api._internal();
  Firestore _db;
  Type entityType;

  //Se eu for usar só uma instância então colocar parâmetro na classe logo
  factory Api() => _api;

  Api._internal();

  get db{

    if(_db == null){
      _db = Firestore.instance;
    }

    return _db;

  }

  insert(String collectionName, var object){
    db.collection(collectionName).add(object.toMap());
  }

  update(String collectionName, var object){
    db.collection(collectionName).document(object.id).updateData(object.toMap());
  }

  remove(String collectionName, String id){
    db.collection(collectionName).document(id).delete();
  }

  getbyId(String collectionName, String id) async{
    DocumentSnapshot doc = await db.collection(collectionName).document(id).get();

    Map<String, dynamic> data = doc.data;

    return data;
  }

  getAll(String collectionName, var type) async{

    QuerySnapshot querySnapshot = await db.collection(collectionName).orderBy("name").getDocuments();
    List list = List();
    var item;

    for(DocumentSnapshot doc in querySnapshot.documents){

        switch(type){
          case Galaxy:
            item = Galaxy.fromMap(doc);
            break;
          case PlanetarySystem:
            item = PlanetarySystem.fromMap(doc);
            break;
        }
        
        list.add(item);
      }    

    return list;

  }


}