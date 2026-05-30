import 'package:flutter/material.dart';

class CurvedTextField extends StatelessWidget {
  final String? hint;
  final String? label;
  final Color? focusedColor;
  final Color? disabledColor;
  final Color? enabledColor;
  final Color? iconColor;
  final TextEditingController? controller;
  final TextInputType? type;
  final bool? obsecureText;
  final Icon? icon;
  final Function? onEditingComplete;
  final Function(String)? onChange;
  final int? maxLines;
  final String? Function(String?)? validator;

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
      this.maxLines,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8)),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10, offset: Offset(2, 2))]),
      child: TextFormField(
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
        validator: validator ?? null,
      ),
    );
  }
}
