import 'package:flutter/material.dart';

class SimpleTextFieldWidget extends StatelessWidget {
  String hint;
  TextEditingController controller;
   SimpleTextFieldWidget({Key key,this.hint,this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: EdgeInsets.symmetric(horizontal:10),
      decoration: BoxDecoration(
        
        color: Colors.white,
        borderRadius: BorderRadius.circular(20)
      ),
      child: TextField(
        controller: this.controller,
        decoration: InputDecoration(
         // hintText: this.hint,
          labelText:this.hint ,
          contentPadding: EdgeInsets.symmetric(horizontal:10),
          hintStyle: TextStyle(color: Colors.grey)
        ),
        style: TextStyle(),
      ),
    );
  }
}