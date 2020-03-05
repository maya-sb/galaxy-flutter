import 'package:flutter/material.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:galaxy_flutter/models/Galaxy.dart';

class Galaxies extends StatefulWidget {
  @override
  _GalaxiesState createState() => _GalaxiesState();
}

class _GalaxiesState extends State<Galaxies> {

  @override
  Widget build(BuildContext context) 

  {
    return WillPopScope(
       onWillPop: () async {
         Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
         return false;
       },
       child: Scaffold(
         appBar: AppBar(
          title: Text("Galáxias", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              //TODO busca por nome
              child: Icon(Icons.search),
            )
          ],
         ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.pink[700],),
          backgroundColor: Colors.white,
          onPressed: (){
             Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_GALAXY);
        },),
        body: Container(
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
                            RouteGenerator.ROUTE_GALAXY, 
                            arguments: galaxia)
                        ),
                      );
                    }
                  );

              }
            },          ),
        ),
      ),
    );

}
}

getGalaxies() async{
  Firestore db = Firestore.instance;

  QuerySnapshot querySnapshot = await db.collection("galaxias").orderBy("nome").getDocuments();
  List<Galaxy> listaGalaxias = List();

  for( DocumentSnapshot item in querySnapshot.documents){
      var dados = item.data;

      Galaxy galaxia = Galaxy.fromMap(item);

      listaGalaxias.add(galaxia);
    
    }    

  return listaGalaxias;

}