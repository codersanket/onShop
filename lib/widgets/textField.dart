import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class textField extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function onValueChanged;
  final String hint;
  final bool isPassword;
  final Function validator;
  final bool readOnly;
  final Function onSubmitted;
  final int maxlines;
  final String hint2;
  final int maxLength;
  final TextInputAction textInputAction;

  textField(
      {this.textEditingController,
      this.onValueChanged,
      this.hint,
      this.isPassword = false,
      this.validator,
      this.readOnly = false,
      this.onSubmitted,
      this.maxlines = 1,
      this.maxLength = null,
      this.textInputAction = TextInputAction.next,
      this.hint2 = ""});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: maxlines,
      validator: validator,
      maxLength: maxLength,
      onFieldSubmitted: onSubmitted,
      readOnly: readOnly,
      onChanged: onValueChanged,
      obscureText: isPassword,
      controller: textEditingController,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hint2,
        filled: true,
        labelStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        fillColor: Colors.white,
        labelText: hint,
        border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey, width: 3, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(10)),
      ),
    ).box.padding(EdgeInsets.all(10)).make();
  }
}
