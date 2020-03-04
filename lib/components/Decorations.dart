import 'package:flutter/material.dart';

/// Decoration based on the Galaxy theme
/// 
/// when [password] is activated, the text is hidden and an icon to show the password is added.
InputDecoration GalaxyFieldDecoration({ String labelText, bool password: false, bool readOnly: false }) {
  
  bool _obscureText = true;

  void _handleOnPressed() {
    //setState(() {
    _obscureText = !_obscureText;
    //});
  }

  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(color: Colors.purple[700]),
    focusedBorder: OutlineInputBorder(
      borderRadius: new BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.purple[700],
        width: readOnly ? 1.5 : 3.0
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

    suffixIcon: password
      ? IconButton(
          icon: _obscureText
          ? Icon(Icons.visibility,  color: Colors.purple[700]) 
          : Icon(Icons.visibility_off, color: Colors.purple[700]),
          onPressed: () => _handleOnPressed(),
        )
      : null

  );

}