import 'package:flutter/material.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:galaxy_flutter/models/Star.dart';
import 'package:galaxy_flutter/widgets/Lists.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Stars extends StatefulWidget {
  @override
  _StarsState createState() => _StarsState();
}

class _StarsState extends State<Stars> {

  Api db = Api();

  NameList lista;
  var searchController = TextEditingController();
  String query = "";
  bool search = false;
  String choiceGlobal;

  @override
  void initState(){
    super.initState();
    lista = NameList(type: 'Star', future: db.getAll('star', Star), route: RouteGenerator.ROUTE_STAR_PROFILE, query: query);
    choiceGlobal = "Todos";
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
       onWillPop: () async {
         Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
         return false;
       },
       child: Scaffold(
         appBar: !search ? AppBar(
          title: Text("Estrelas"),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              //TODO busca por nome
              child: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    search = true;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: PopupMenuButton(
                icon: Icon(Icons.filter_list),
                onSelected: choiceAction,
                itemBuilder: (BuildContext context) {
                  return <String>["Todos", "Anã Branca", "Anã Vermelha", "Gigante Azul", "Gigante Vermelha", "Estrela Binária", "Buraco Negro"].map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice, style: TextStyle(color: Colors.purple[800]),),
                    );
                  }).toList();
                },
              )
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
                choiceAction(choiceGlobal);
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
                    choiceAction(choiceGlobal);
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
        //Navigator.pushNamed(context, RouteGenerator.ROUTE_REGISTER_SATELLITE);
        floatingActionButton: SpeedDial(
          // both default to 16
          marginRight: 18,
          marginBottom: 20,
          child: Icon(Icons.add),
          // this is ignored if animatedIcon is non null
          // child: Icon(Icons.add),
          // If true user is forced to close dial manually 
          // by tapping main button and overlay is not rendered.
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.purple[900],
          overlayOpacity: 0.5,
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Colors.white,
          foregroundColor: Colors.pink[700],
          elevation: 8.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Anã Branca',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => Navigator.pushNamed(
                            context, 
                            RouteGenerator.ROUTE_REGISTER_STAR, 
                            arguments: "Anã branca"
                          )
            ),
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Anã Vermelha',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => Navigator.pushNamed(
                            context, 
                            RouteGenerator.ROUTE_REGISTER_STAR, 
                            arguments: "Anã vermelha"
                          )
            ),
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Gigante Azul',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => Navigator.pushNamed(
                            context, 
                            RouteGenerator.ROUTE_REGISTER_STAR, 
                            arguments: "Gigante azul"
                          )
            ),
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Gigante Vermelha',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => Navigator.pushNamed(
                            context, 
                            RouteGenerator.ROUTE_REGISTER_STAR, 
                            arguments: "Gigante vermelha"
                          )
            ),
            SpeedDialChild(
              child: Icon(Icons.star, color: Colors.pink[700],),
              backgroundColor: Colors.white,
              label: 'Estrela Binária',
              labelStyle: TextStyle(fontSize: 18.0, color: Colors.pink[700]),
              onTap: () => Navigator.pushNamed(
                            context, 
                            RouteGenerator.ROUTE_REGISTER_STAR, 
                            arguments: "Estrela binária"
                          )
            ),
       
          ],
        ),
        body: lista,
      ),
    );
  }


  void choiceAction(String choice) {
    setState(() {
      choiceGlobal = choice;
      switch (choice) {
        case "Todos":
          lista = NameList(type: 'Star', future: db.getAll('star', Star), route: RouteGenerator.ROUTE_STAR_PROFILE, query: query);
          break;
        
        case "Anã Branca":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type', 'Anã branca'), route: RouteGenerator.ROUTE_STAR_PROFILE);
          break;
        
        case "Anã Vermelha":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type', 'Anã vermelha'), route: RouteGenerator.ROUTE_STAR_PROFILE);
          break;
        
        case "Gigante Azul":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type', 'Gigante azul'), route: RouteGenerator.ROUTE_STAR_PROFILE);
          break;
        
        case "Gigante Vermelha":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type', 'Gigante vermelha'), route: RouteGenerator.ROUTE_STAR_PROFILE);
          break;
        
        case "Estrela Binária":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'type','Estrela binária'), route: RouteGenerator.ROUTE_STAR_PROFILE);
          break;
        
        case "Buraco Negro":
          lista = NameList(type: 'Star', future: db.getWhere('star', Star, 'death', 'true'), route: RouteGenerator.ROUTE_STAR_PROFILE);
      }
    });
    
  }
}