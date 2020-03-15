import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';

Decoration box = BoxDecoration(
  gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [Colors.pink[700], Colors.purple[800]],
)
);

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
    const StaggeredTile.count(2, 3),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(2, 3),
    const StaggeredTile.count(2, 2),
    const StaggeredTile.count(4, 2),
    //const StaggeredTile.count(2, 2),
  ];


  List<Widget> _tiles = const <Widget>[
    const _Card(title: 'Galáxias',asset: 'assets/svg/orbit.svg', type:'Galaxies'),
    const _Card(title: 'Planetas',asset: 'assets/svg/uranus.svg', type: 'Planets',),
    const _Card(title:'  Sistemas\nPlanetários', asset: 'assets/svg/galaxy.svg', type: 'Systems'),
    const _Card(title:'Satélites', asset: 'assets/svg/moon2.svg', type: 'Satellites',),
    const _Card(title:'Estrelas', asset: 'assets/svg/stars.svg', type: 'Stars'),
    //const _Card(title:'Buracos \n Negros', asset:'assets/svg/blackhole.svg')
  ];

  _signOut() async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    await _firebaseAuth.signOut();
   }

   exitApp() {
    _signOut();
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_LOGIN, (_) => false);
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Galaxy Flutter", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app) ,
            onPressed: (){
              showDialog(context: context, builder: (context) {
              return confirmExitRemove(title: "Tem certeza que deseja sair?", action: exitApp);
             });    
            },),
        ],
        backgroundColor: Colors.transparent
       ),
        body: Container(
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
            child: StaggeredGridView.count(
                crossAxisCount: 4,
                staggeredTiles: _staggeredTiles,
                children: _tiles,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
            ));
  }
}

class _Card extends StatelessWidget {
  const _Card({this.title, this.asset, this.type});

  final title; 
  final asset;
  final type;

  @override
  Widget build(BuildContext context) {
    return Card(
        color:Color(0xff380b4c) ,
        clipBehavior: Clip.antiAlias,
          child: Container(
          decoration: box,
          child: InkWell(
            onTap: () {
              if (type == 'Planets'){
                Navigator.pushNamed(context, RouteGenerator.ROUTE_PLANETAS);
              }else if(type == 'Galaxies'){
                Navigator.pushNamed(context, RouteGenerator.ROUTE_GALAXIES);
              }else if(type == 'Systems'){
                Navigator.pushNamed(context, RouteGenerator.ROUTE_PLANETARY_SYSTEMS);
              }else if(type == 'Satellites'){
                Navigator.pushNamed(context, RouteGenerator.ROUTE_SATELLITES);
              }else if(type == 'Stars'){
                Navigator.pushNamed(context, RouteGenerator.ROUTE_STARS);
              }
            },
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox.fromSize(
                child:  SvgPicture.asset(asset,color: Colors.white,),
                size: Size(100.0, 100.0),
              ),   
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Center(child: Text(title,style: TextStyle(fontSize: 18.0,color:Colors.white))),
                )]
              ),
            ),
          ),
      ),
    );
  }
}