import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:galaxy_flutter/models/PlanetarySystem.dart';
import 'package:galaxy_flutter/widgets/Dialogs.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

class RegisterPlanetarySystem extends StatefulWidget {
  @override
  _RegisterPlanetarySystemState createState() => _RegisterPlanetarySystemState();
}

class _RegisterPlanetarySystemState extends State<RegisterPlanetarySystem> {

  _discardChanges(){
    Navigator.pop(context);
    Navigator.pop(context);
  }  

  final _formKey = GlobalKey<FormState>();
  var nomeController = TextEditingController();
  var idadeController = TextEditingController();
  var galaxiaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
        showDialog(context: context, builder: (context) {
            return confirmExitRemove(title: "Descartar Sistema Planetário", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
          });
         return false;
       },
        child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pink[700],
          child: Icon(Icons.save, color: Colors.white,),
          onPressed: (){
            if (_formKey.currentState.validate()) {
              PlanetarySystem system = PlanetarySystem(name: nomeController.text, age:idadeController.text, numStars: '0', numPlanets: '0');
              //system.register();
              Navigator.pop(context);
            }
            }),
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
               Stack(
                    children: <Widget>[
                      Center(
                        child: ClipPath(
                          clipper: OvalBottomBorderClipper(),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [Colors.pinkAccent[700], Colors.purple[900] ])
                            ),
                            height: 180,
                            width: 1000,
                          ),
                        ),
                      ),
                      Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100.0, bottom: 0),
                        child: SizedBox(
                          width: 150,
                          height: 150,
                              child: FlareActor(
                                  'assets/animations/planetList.flr',
                                  animation: 'rotation',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                  ),
                  Padding(
                        padding: const EdgeInsets.only(top: 25.0),
                        child: IconButton(
                          onPressed: () { showDialog(context: context, builder: (context) {
                            return confirmExitRemove(title: "Descartar Galáxia", content: "Sair da tela descartará informações ainda não salvas. Tem certeza que deseja voltar?", action: _discardChanges);
                          }); },
                          icon: Icon(Icons.arrow_back, color: Colors.white, size: 25.0),
                        ),
                      ),
                    ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: 
                  Form(
                    key: _formKey,
                    child: Info(nomeController: nomeController, idadeController: idadeController, galaxiaController: galaxiaController,)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Info extends StatefulWidget {
  Info({this.nomeController, this.idadeController, this.galaxiaController});

  final nomeController;
  final idadeController;
  final galaxiaController;

  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {

   String validatorNome (val) {
        if(val.length==0) {
          return "Nome inválido";
        }else{
          return null;
        }
    }

    String validatorIdade (val) {
        if(val.length==0) {
          return "Idade inválida";
        }else{
          return null;
        }
    }

  int _selectedGender;


  @override
  Widget build(BuildContext context) {
    return Container(
          padding: EdgeInsets.all(10),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: EditField(title: "Nome", controller: widget.nomeController, validator: validatorNome, fontSize: 18.0,),
             ),  
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: EditField(
                title: "Idade", 
                controller: widget.idadeController, 
                validator: validatorIdade, 
                fontSize: 18.0,
                keyboardType: TextInputType.number,
            ),), 
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InputDecorator(
                  decoration: InputDecoration(
                  //labelStyle: textStyle,
                  labelStyle: TextStyle(color: Colors.purple[700], fontSize: 18.0),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                  //hintText: 'Please select expense',
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
                  ),
                  isEmpty: _selectedGender == 0,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButtonFormField(
                      items: loadGenderList(),
                      hint: Text("Selecione o gênero"),
                      isDense: true,
                      isExpanded: false,
                      value: _selectedGender,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedGender = newValue;
                        });
                      },
                )
                  )))
                /*child: DropdownButton(hint: new Text('Select Gender'),
                  items: loadGenderList(),
                  value: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });},
                  isExpanded: true,),)
                */

              /*
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(10.0, 6.3, 10.0, 6.3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(color: Colors.purple[700], width: 1.5)
                  ),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward, color: Colors.white,),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                  style: TextStyle(
                    color: Colors.purple[700],
                    fontFamily: "Poppins",
                    fontSize: 18.0,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  underline: Container(color: Colors.purple[700],),
                  items: <String>['Selecione a galáxia','One', 'Two', 'Free', 'Four']
                    .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    })
                    .toList(),
                ),
              ),
              */
            
          ],
            ),
          margin: const EdgeInsets.symmetric(
           vertical: 10.0,
           horizontal: 10.0,
         ),
          width: 500.0,
          decoration: BoxDecoration(
            color: Color(0xff380b4c),
            shape: BoxShape.rectangle,
            borderRadius: new BorderRadius.circular(8.0),
            boxShadow: [new BoxShadow(
            color: Color(0xff280538),
            blurRadius: 20.0,)],
          ),
    );
  }
}


loadGenderList() {

    List<DropdownMenuItem<int>> genderList = [];

    genderList = [];
    genderList.add(new DropdownMenuItem(
      child: new Text('Male'),
      value: 0,
    ));
    genderList.add(new DropdownMenuItem(
      child: new Text('Female'),
      value: 1,
    ));
    genderList.add(new DropdownMenuItem(
      child: new Text('Other'),
      value: 2,
    ));
    return genderList;
}