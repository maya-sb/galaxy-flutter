import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';

Decoration box = BoxDecoration(
  gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  //stops:[0,0.8],
  //colors: [Colors.purple[400], Colors.purple[800]],
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
  ];


  List<Widget> _tiles = const <Widget>[
    const _Card('Galáxias','assets/svg/orbit.svg'),
    const _Card('Planetas','assets/svg/uranus.svg'),
    const _Card('  Sistemas\nPlanetários','assets/svg/galaxy.svg'),
    const _Card('Satélites','assets/svg/moon2.svg'),
    const _Card('Estrelas','assets/svg/stars.svg'),
  ];

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
              Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_LOGIN, (_) => false);
            },),
        ],

        backgroundColor: Colors.transparent
        //backgroundColor: Colors.purple[900],
       ),
      backgroundColor: Color(0xff380b4c),
        //backgroundColor: Colors.white,
        body: Container(
            //decoration: box,
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
            child: StaggeredGridView.count(
                crossAxisCount: 4,
                staggeredTiles: _staggeredTiles,
                children: _tiles,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                //padding: const EdgeInsets.all(4.0),
              ),
            ));
  }
}

class _Card extends StatelessWidget {
  const _Card(this.title, this.asset);

  final title; 
  final asset;

  @override
  Widget build(BuildContext context) {
    return Card(
        //color:Color(0xff730b38),
        color:Color(0xff380b4c) ,
        clipBehavior: Clip.antiAlias,
          child: Container(
          decoration: box,
          child: InkWell(
            onTap: () {
              if (title == 'Planetas'){
                Navigator.pushNamed(context, RouteGenerator.ROUTE_PLANETAS);
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