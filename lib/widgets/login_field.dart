import 'package:flutter/material.dart';

class LoginField extends StatelessWidget {
  final bool _isPassword;

  LoginField(this._isPassword);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: TextField(
          obscureText: _isPassword,
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: _isPassword ? "Password" : "E-mail",
          ),
        ),
      ),
    );
  }
}
