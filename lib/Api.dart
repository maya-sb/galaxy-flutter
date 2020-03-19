import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';
import 'package:galaxy_flutter/models/Gas.dart';
import 'package:galaxy_flutter/models/Planet.dart';
import 'package:galaxy_flutter/models/PlanetGas.dart';
import 'package:galaxy_flutter/models/PlanetSystemPlanetary.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/models/Satellite.dart';
import 'package:galaxy_flutter/models/SatelliteGas.dart';
import 'package:galaxy_flutter/models/StarSystemPlanetary.dart';

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

  set(String collectionName, var object){
    var ref = db.collection(collectionName).document();
    var id = ref.documentID;
    db.collection(collectionName).document(id).setData(object.toMap());
    return id;
  }

  setId(String collectionName, var object, var id){
    db.collection(collectionName).document(id).setData(object.toMap());
  }

  insert(String collectionName, var object){
    db.collection(collectionName).add(object.toMap());
  }

  update(String collectionName, var object){
    db.collection(collectionName).document(object.id).updateData(object.toMap());
  }

  updateField(String collectionName, String id, String field, dynamic value){
      db.collection(collectionName).document(id).updateData({field:value});
  }

  delete(String collectionName, String id){
    db.collection(collectionName).document(id).delete();
  }

  deleteOnCascade(String collectionName, String field, String value) async{

    await db.collection(collectionName)
    .where(field, isEqualTo: value)
    .getDocuments()
    .then((snapshot){

      for(DocumentSnapshot doc in snapshot.documents){
        String id = doc.documentID;
        delete(collectionName, id);
      }

    });
  }

  getbyId(String collectionName, String id) async{
    
    DocumentSnapshot doc = await db.collection(collectionName).document(id).get();
    Map<String, dynamic> data = doc.data;

    return data;
  }

  getdocbyId(String collectionName, String id) async{
    DocumentSnapshot doc = await db.collection(collectionName).document(id).get();
    return doc;
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
          case Satellite:
            item = Satellite.fromMap(doc);
            break;
          case Gas: 
            item = Gas.fromMap(doc);
            break;
          case Planet:
            item = Planet.fromMap(doc);
          
        }

        list.add(item);
      }    

    return list;

  }

  getWhere(String collectionName, var type, String field, String value) async{

    QuerySnapshot querySnapshot = await db.collection(collectionName).where(field, isEqualTo: value).getDocuments();

    List list = List();
    var item;

    for(DocumentSnapshot doc in querySnapshot.documents){

        switch(type){
          case SatelliteGas:
            item = SatelliteGas.fromMap(doc);
            break;
          case PlanetarySystem:
            item = PlanetarySystem.fromMap(doc);
            break;
          case PlanetGas:
            item = PlanetGas.fromMap(doc);
            break;
          case PlanetSystemPlanetary:
            item = PlanetSystemPlanetary.fromMap(doc);
            break;
          case StarSystemPlanetary:
            item = StarSystemPlanetary.fromMap(doc);
            break;
        }

        list.add(item);
      }    

    return list;

  }


  /*
  getComposition(String id) async{

    Map resul;

    //QuerySnapshot querySnapshot = await db.collection('satelliteGas').where(firestore.FieldPath.documentId, isGreaterThanOrEqual: id).getDocuments();
    //QuerySnapshot querySnapshot = await db.collection('satelliteGas').where(firestore.FieldPath.documentId, isEqual: "BwWY69DKGA36beFcdEsv-FDtGEMhc59SzLSv7Ghvy").getDocuments();
    try {
    //TODO LIKE
    //QuerySnapshot querySnapshot = await db.collection('satelliteGas').where(firestore.FieldPath.documentId, isGreaterThanOrEqualTo: id).getDocuments();
    
    List list = List();
    var item;


    for(DocumentSnapshot doc in querySnapshot.documents){

    
      item = SatelliteGas.fromMap(doc);
      list.add(item);
    
    }

    return list;
    
    
    }catch (e){
      print(e.toString());
    }
    //QuerySnapshot querySnapshot = await db.collection("satelliteGas").whereEqualTo("satelliteGas",id).orderBy("amount").getDocuments();
    //QuerySnapshot querySnapshot = await db.collection("satelliteGas").whereEqualTo("satelliteId",id).getDocuments();


  }
  */
  





}