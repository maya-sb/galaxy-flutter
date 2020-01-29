import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  
  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState(){
    super.initState();
    myFocusNode.addListener((){ setState((){}); });
    myFocusNode2.addListener((){ setState((){}); });
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    myFocusNode2.dispose();
  }

  bool _obscureText = true;


  void _handleOnPressed() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xff380b4c),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[

                ClipPath(
                  clipper: WaveClipperTwo(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.pinkAccent[700], Colors.purple[900] ])
                    ),
                    height: 250,
                    width: 500 ,
                    child: Center(
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
                ),

                // Form

                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 60),
                  child: TextFormField(
                    focusNode: myFocusNode,
                    decoration: new InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(color: Colors.purple[700]),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.purple[700],
                          width: 3
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.purple[700],
                          width: 1.5
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.pink[700],
                          width: 3
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.pink[700],
                          width: 1.5
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.pink[700],
                      )

                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        return "Email inválido";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: TextFormField(
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                    ),
                    focusNode: myFocusNode2,
                    obscureText: _obscureText,
                    decoration: new InputDecoration(
                      suffixIcon: IconButton(
                        icon: _obscureText
                        ? Icon(Icons.visibility,  color: Colors.purple[700]) 
                        : Icon(Icons.visibility_off, color: Colors.purple[700]),
                        onPressed: () => _handleOnPressed(),
                      ),
                      labelText: "Senha",
                      labelStyle: TextStyle(color: Colors.purple[700]),
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.purple[700],
                          width: 3
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.purple[700],
                          width: 1.5
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.pink[700],
                          width: 3
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.pink[700],
                          width: 1.5
                        ),
                      ),
                      errorStyle: TextStyle(
                        color: Colors.pink[700],
                      )
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if(val.length==0) {
                        return "Senha inválida";
                      }else{
                        return null;
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Navigator.pushReplacementNamed(context, RouteGenerator.ROUTE_HOME);
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [Colors.pinkAccent[700], Colors.purple[900] ]),
                        borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 100.0, minHeight: 55.0), // min sizes for Material buttons
                        alignment: Alignment.center,
                        child: Text(
                          'Entrar',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  ),
               ),

               Container(
                 padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                 child: Center(
                   child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, RouteGenerator.ROUTE_SIGNUP);
                      },
                      child: Text('Criar uma conta', style: TextStyle(
                        color: Colors.pink[700],
                        fontSize: 17.0
                        ),
                      ),
                   ),
                 ),
               )


              ],
            ),
          ),
        )
      ),
      
    );
  }
}
