import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Satellite.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';

class Satellites extends StatefulWidget {
  @override
  _SatellitesState createState() => _SatellitesState();
}

class _SatellitesState extends State<Satellites> {

  Api db = Api();
  String query = "";
  bool search = false;
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
       onWillPop: () async {
         Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
         return false;
       },
       child: Scaffold(
         appBar: !search ? AppBar(
          title: Text("Satélites", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),

              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    search = true;
                  });
                },
              ),
            )
          ],
         )
         : AppBar(
          backgroundColor: Colors.pink[700],
          title: TextField(
            textInputAction: TextInputAction.search,
            autofocus: true,
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
            cursorColor: Colors.white,
            controller: searchController,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 27,), 
                onPressed: () {
                  setState(() {
                    search = false;
                    searchController.text = "";
                    query = "";
                  });
                }
              ),
              hintText: "Search",
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
         
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add,color: Colors.pink[700],),
          backgroundColor: Colors.white,
          onPressed: (){
             Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_SATELLITE);
        },),
        body: NameList(type: 'Satelite', future: db.getAll("satellite", Satellite), route: RouteGenerator.ROUTE_SATELLITE_PROFILE, query: query)
      ),
    );
  }
}