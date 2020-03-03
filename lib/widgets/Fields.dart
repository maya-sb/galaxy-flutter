import 'package:flutter/material.dart';

class EditField extends StatelessWidget {

  const EditField(this.title, this.controller, this.validator);

  final title;
  final controller;
  final validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: false,
      decoration: new InputDecoration(
        labelText: title,
        labelStyle: TextStyle(color: Colors.purple[700], fontSize: 18.0),
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
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontFamily: "Poppins",
        color: Colors.white,
        fontSize: 18.0
      ),
    );
  }
}

class OutputField extends StatelessWidget {

  const OutputField(this.title, this.controller);

  final title;
  final controller;

  @override
  Widget build(BuildContext context) {

    return TextFormField(
      controller: controller,
      readOnly: true,
      autofocus: false,
      decoration: new InputDecoration(
        labelText: title,
        labelStyle: TextStyle(color: Colors.purple[700], fontSize: 20.0),
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        fontFamily: "Poppins",
        color: Colors.white,
        fontSize: 20.0
      ),
    );
  }
}