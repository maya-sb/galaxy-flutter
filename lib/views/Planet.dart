import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class Planet extends StatefulWidget {
  @override
  _PlanetState createState() => _PlanetState();
}

class _PlanetState extends State<Planet> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff380b4c),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[

              Stack(
                children: <Widget>[
                  
                  ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.pinkAccent[700], Colors.purple[900] ])
                      ),
                      height: 180,
                      width: 500 ,
                    ),
                  ),

                  Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 45.0, bottom: 0),
                        child: SizedBox(
                          width: 250,
                          height: 250,
                              child: FlareActor(
                                  'assets/animations/pinkPlanet.flr',
                                  animation: 'rotation',
                                  fit: BoxFit.fitWidth,
                                ),
                        ),
                      ),
                  ),
                  
                ],
              ),

              Container(
                padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                child: Card(
                  child: Container(
                    color: Color(0xff280b4d),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Marte', style: TextStyle(
                              color: Colors.white70,
                              fontSize: 30,
                            ),)
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('37413', style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15
                            ),)
                          ],
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Tamanho: 20000 km', style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),)
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Massa: 20000kg', style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),)
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Composição:', style: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                              ),)
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 2, left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Oxigênio: 20%', style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),)
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: 2, left: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text('Gás Carbônico: 70%', style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),)
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                ),
              ),

              Container(
                padding: EdgeInsets.only(top: 20, left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text('Satélites', style: TextStyle(
                      fontSize: 30,
                      color: Colors.white70,
                    
                    ))
                  ],
                ),
              ),

              ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  Card(
                    color: Color(0xff280b4d),
                    child: Text('Lua', style: TextStyle(
                      color: Colors.white70,
                      fontSize: 25
                    )),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}