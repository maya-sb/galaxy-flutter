import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  
  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool loading = false;

  String validatorEmail (val) {
    if(val.length==0) {
      return "Nome inválido";
    }else{
      return null;
    }
  }

  String validatorPassword (val) {
    if(val.length==0) {
      return "Nome inválido";
    }else{
      return null;
    }
  }

  @override
  void initState(){
    super.initState();
    _checkLogged();
    myFocusNode.addListener((){ setState((){}); });
    myFocusNode2.addListener((){ setState((){}); });
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    myFocusNode2.dispose();
  }

  void _login(String email, String password) {

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(email: email, password: password)
      .then((user) {
        this.loading = false;
        Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
      }).catchError((error) {
          setState(() {
            this.loading = false;
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                content: Text(error.message),
                backgroundColor: Colors.pinkAccent[700],
              )
            );
          });
      });
  }


  Future _checkLogged() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    
    if (await auth.currentUser() != null){
      Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
    }

  }
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldKey,
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
                                'assets/animations/pinkPlanetBig.flr',
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
                  child: EditField(
                    title: "Email", 
                    controller: emailController,
                    validator: validatorEmail,
                    keyboardType: TextInputType.emailAddress,

                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: EditField(
                    title: "Password",
                    controller: passwordController,
                    validator: validatorPassword,
                    isPassword: true,
                    keyboardType: TextInputType.visiblePassword,
                  ), 
                ),

                Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          this.loading = true;
                          this._login(emailController.text, passwordController.text);
                        });
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
                        child: loading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff380b4c)),
                            )

                          : Text(
                              'Entrar',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 20.0,
                              ),
                            )
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
