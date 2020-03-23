import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';
import 'package:galaxy_flutter/models/Planet.dart';

class Planets extends StatefulWidget {
  @override
  _PlanetsState createState() => _PlanetsState();
}

class _PlanetsState extends State<Planets> {

  Api db = Api();
  var galaxies;
  String query = "";
  bool search = false;
  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) 

  {
    return WillPopScope(
       onWillPop: () async {
         Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
         return false;
       },
       child: Scaffold(
         appBar: !search ? AppBar(
          title: Text("Planetas", style: TextStyle(color: Colors.white)),
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
             Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_PLANET);
        },),
        body: NameList(type: 'Planet', future: db.getAll("planet", Planet), route: RouteGenerator.ROUTE_PLANET_PROFILE, query: query,)
      ),
    );

}
}