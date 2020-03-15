import 'package:flutter/material.dart';


class EditField extends StatefulWidget {
  /// TextFormField based on the Galaxy theme
  /// 
  /// when [isPassword] is activated, the text is hidden and an icon to show the password is added.
  EditField({
    this.title,
    this.controller,
    this.validator,
    this.fontSize: 18,
    this.isPassword: false,
    this.keyboardType: TextInputType.text,
    this.textColor: Colors.white

  });

  final String title;
  final controller;
  final String Function(String) validator;
  final double fontSize;
  final bool isPassword;
  final TextInputType keyboardType;
  final Color textColor;

  @override
  _EditFieldState createState() => _EditFieldState();
}

class _EditFieldState extends State<EditField> {

  bool _obscureText;

  void _handleOnPressed() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      autofocus: false,
      decoration: new InputDecoration(
        suffixIcon:  widget.isPassword
        ? IconButton(
          icon: _obscureText
          ? Icon(Icons.visibility,  color: Colors.purple[700]) 
          : Icon(Icons.visibility_off, color: Colors.purple[700]),
          onPressed: () => _handleOnPressed(),
        )
        : null,
        labelText: widget.title,
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
        ),
        //fillColor: Colors.green
      ),
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      style: TextStyle(
        fontFamily: "Poppins",
        color: widget.textColor,
        fontSize: widget.fontSize,
      ),
    );
  }
}

class OutputField extends StatelessWidget {

  const OutputField({this.title, this.controller});

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