import 'package:flutter/material.dart';

class textInputField extends StatelessWidget {
  textInputField({
    this.lebelText,
    this.hintText,
    this.onChanged,
    this.backcolor,
    this.heightTextField,
    this.obscureState = false,
    this.validator,
    this.focusNode,
    this.onSaved,
    this.onFieldSubmitted,
    this.keyboardType,
    this.controller,
  });

  final String lebelText;
  final TextEditingController controller;
  final String hintText;
  final Function(String v) onChanged;
  final Color backcolor;
  final heightTextField;
  final bool obscureState;
  final String Function(String v) validator;
  final Function(String v) onSaved;
  final Function(String v) onFieldSubmitted;
  final FocusNode focusNode;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(
            lebelText,
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
        ),
        Material(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10.0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                boxShadow: [new BoxShadow(color: Colors.grey, blurRadius: 1.0)],
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
                color: backcolor,
                //Color(0xFFEDEDED),
                border: Border.all(
                  color: Colors.white60,
                  width: 2.0,
                  style: BorderStyle.solid,
                )),
            child: TextFormField(
              keyboardType: keyboardType,
              controller: controller,
              onFieldSubmitted: onFieldSubmitted,
              obscureText: obscureState,
              onChanged: onChanged,
              validator: validator,
              onSaved: onSaved,
              focusNode: focusNode,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "$hintText",
                hintStyle: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontFamily: 'open sans regular'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
