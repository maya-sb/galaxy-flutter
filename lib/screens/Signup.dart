import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/RouteGenerator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

class Signup extends StatefulWidget {

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  
  FocusNode myFocusNode = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();

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

  String validatorConfirm (val) {
    if(val.length==0) {
      return "Senha inválida";
    } else if (val != passwordController.text) {
      return "Senhas diferentes";
    } else{
      return null;
    }
  }

  @override
  void initState(){
    super.initState();
    myFocusNode.addListener((){ setState((){}); });
    myFocusNode2.addListener((){ setState((){}); });
    myFocusNode3.addListener((){ setState((){}); });
  }

  @override
  void dispose() {
    super.dispose();
    myFocusNode.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();
  }

  void _signup(String email, String password) {

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.createUserWithEmailAndPassword(
      email: email,
      password: password
    ).then((user) {
      this.loading = false;
      Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_HOME, (_) => false);
    }).catchError((error) {
        setState(() {
          this.loading = false;
          _scaffoldKey2.currentState.showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Colors.pinkAccent[700],
            )
          );
        });
    });

  }
  

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
    key: _scaffoldKey2,
    body: SingleChildScrollView(
      child: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Stack(
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
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(context, RouteGenerator.ROUTE_LOGIN, (_) => false);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 25.0),
                    ),
                  )


                ]
              ),

              // Form

              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 60),
                child: EditField(
                  title: "Seu email",
                  controller: emailController,
                  validator: validatorEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: EditField(
                  title: "Sua senha",
                  controller: passwordController,
                  validator: validatorPassword,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                )
              ),

              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                child: EditField(
                  title: "Confirme sua senha",
                  validator: validatorConfirm,
                  isPassword: true,
                  keyboardType: TextInputType.visiblePassword,
                )
              ),

              Container(
                padding: EdgeInsets.only(left: 15, right: 15, top: 25),
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        this.loading = true;
                        _signup(emailController.text, passwordController.text);
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
                            'Criar conta',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20.0,
                            ),
                          )
                  ),
                ),
                ),
             ),


            ],
          ),
        ),
      )
    ),
    
      );
  }
}
