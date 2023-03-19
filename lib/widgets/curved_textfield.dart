import 'package:flutter/material.dart';

class CurvedTextField extends StatelessWidget {
  final String? hint;
  String? label;
  Color? focusedColor;
  Color? disabledColor;
  Color? enabledColor;
  Color? iconColor;
  TextEditingController? controller;
  TextInputType? type;
  bool? obsecureText;
  Icon? icon;
  Function? onEditingComplete;
  Function(String)? onChange;
  int? maxLines;

  CurvedTextField(
      {this.controller,
      this.disabledColor,
      this.enabledColor,
      this.focusedColor,
      this.hint,
      this.icon,
      this.iconColor,
      this.label,
      this.obsecureText,
      this.onChange,
      this.onEditingComplete,
      this.type,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 283,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(2, 2))
          ]),
      child: TextField(
        onChanged: (text) {
          //onChange!(text);
        },
        controller: controller,
        keyboardType: type ?? TextInputType.text,
        obscureText: obsecureText ?? false,
        decoration: new InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            alignLabelWithHint: false,
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            hintText: hint ?? 'Your Value',
            labelText: label ?? null,
            labelStyle: TextStyle(
              fontFamily: "Nunito",
            ),
            hintStyle: TextStyle(fontFamily: "Nunito")),
      ),
    );
  }
}
