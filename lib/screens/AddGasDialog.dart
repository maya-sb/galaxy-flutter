import 'package:flutter/material.dart';
import 'package:galaxy_flutter/Api.dart';
import 'package:galaxy_flutter/models/Gas.dart';
import 'package:galaxy_flutter/widgets/Fields.dart';

class AddGasDialog extends StatefulWidget {
  AddGasDialog(this.listId);

  final List listId;

  @override
  _AddGasDialogState createState() => _AddGasDialogState();
}

class _AddGasDialogState extends State<AddGasDialog> {

  var items;

  final _formKey = GlobalKey<FormState>();

  Api db = Api();

  var controllerName = TextEditingController();
  var controllerId = TextEditingController();
  var controllerAmount = TextEditingController();
  
  Gas _selectedGas;

  loadGasesList() async{

    print("socorro");

    var gases = await db.getAll("gas", Gas);
    List<DropdownMenuItem<Gas>> items = [];


    for (Gas item in gases){

      if (!widget.listId.contains(item.id)){
        items.add(new DropdownMenuItem(
        child: Text(item.name,  style: TextStyle(
                                color: Colors.purple[700],
                                fontFamily: "Poppins",
                                fontSize: 18.0,)),
        //value: item.id,
        value: item,  
        ));
      }
    }

    Gas newGas = Gas(id: 'NEW', name: 'NEW');
    items.add(new DropdownMenuItem(
        child: Text("Cadastrar Novo",  style: TextStyle(
                                color: Colors.purple[700],
                                fontFamily: "Poppins",
                                fontSize: 18.0,)),
        value: newGas,
      ));

    return items;
}

  @override
  void initState() {
    super.initState();
    //items = loadGasesList();
  }

  @override
  Widget build(BuildContext context) {

    items = loadGasesList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Adicionar Gás'),
        actions: [
              FlatButton(
              onPressed: () {

                 if (_formKey.currentState.validate()) {
                    Navigator.of(context).pop(
                          {'name': controllerName.text, 
                           'amount': controllerAmount.text,
                           'gasId': controllerId.text,
                          });
                 }
               
              },
              child: Text('SALVAR',style: TextStyle(color: Colors.white),)),
        ],
      ),
      body: 
     FutureBuilder(
        future: items,
        builder: (context, snapshot){
          switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                    case ConnectionState.active:
                    case ConnectionState.done:
                      return Form(
                        key: _formKey,
                        child: Column(
                          children:[
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                                child: DropdownButtonFormField(
                                   items: snapshot.data,
                                      validator: (value) {
                                        if (value == null) {
                                          return 'Selecione uma gás';
                                        }
                                      },
                                      decoration: InputDecoration(
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: Colors.purple[700],
                                            width: 1.5
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: new BorderRadius.circular(25.0),
                                          borderSide: BorderSide(
                                            color: Colors.pink[700],
                                            width: 1.5
                                          ),
                                        )
                                      ),
                                      hint: Text("Selecione o gás",  style: TextStyle(
                                                                          color: Colors.purple[700],
                                                                          fontFamily: "Poppins",
                                                                          fontSize: 18.0,)),
                                      style: TextStyle(
                                        color: Colors.purple[700],
                                        fontFamily: "Poppins",
                                        fontSize: 18.0,),
                                      isDense: true,
                                      isExpanded: true,
                                      value: _selectedGas,
                                      onChanged: (Gas newValue) {
                                  
                                    
                                          if (newValue.id == "NEW"){
                                            showDialog(context: context, builder: (context) {
                                              var gasController = TextEditingController();
                                              final _formKeyDialog = GlobalKey<FormState>();
                                              return AlertDialog(
                                                contentPadding: EdgeInsets.all(15.0),
                                                shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                title: Text("Novo Gás"),
                                                content: SingleChildScrollView(
                                                    child: Form(
                                                      key: _formKeyDialog,
                                                      child: Padding(
                                                          padding: const EdgeInsets.only(top: 10.0, left: 4.0, right: 4.0),
                                                          child: EditField(
                                                            textColor: Colors.purple[700],
                                                            controller: gasController, 
                                                            title: "Nome", 
                                                            validator: (String value) {
                                                                          if (value?.isEmpty ?? true) {
                                                                            return 'Digite o nome do gás';
                                                                          }
                                                                        },),
                                                        )
                                                    
                                                ),
                                              ),
                                              actions: <Widget>[
                                                FlatButton(child: Text("Cancelar"),onPressed: () =>  Navigator.pop(context)
                                                ,),
                                                FlatButton(
                                                  child: Text("Adicionar"),
                                                  onPressed: () async{
                                                    
                                                    controllerName.text = gasController.text;
                                                    if (_formKeyDialog.currentState.validate()) {

                                                    Gas gas = Gas(name: controllerName.text);
                                                    var ref = db.db.collection('gas').document();
                                                    var id = ref.documentID;
                                                    db.db.collection('gas').document(id).setData(gas.toMap());
                                                    setState((){});
                                                    Navigator.pop(context);
                                                    }

                                                  })
                                              ],);
                                          });
                                          
                                        }else{
                                            setState(() {
                                                _selectedGas = newValue;   
                                                controllerId.text = newValue.id;
                                                controllerName.text = newValue.name;  
                                                 
                                            });
                                          }           
                                    },

                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                              child: EditField(
                                title: "Quantidade", 
                                controller: controllerAmount,
                                keyboardType: TextInputType.number,
                                validator: (String value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Digite uma quantidade';
                                  }
                                      },),
                            )
                          ]
                        ),
                      );
          }
        }
      ),
    );
  }
}