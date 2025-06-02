import 'package:flutter/material.dart';

import '../../model/app_colors.dart';

class BasicTextField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final String? label;

  const BasicTextField({Key? key, this.onChanged, this.label, this.controller}) : super(key: key);

  @override
  _BasicTextFieldState createState() => _BasicTextFieldState();
}

class _BasicTextFieldState extends State<BasicTextField> {
  // Initially obscure the text
  @override
  Widget build(BuildContext context) {
    return TextField(
      // Pass through onChanged
      controller: widget.controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: const TextStyle(
          color: Color(0xFF9A9A9A),
          fontFamily: 'NotoSans',
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD9D9D9),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 2.0,
          ),
        ),
        floatingLabelStyle: const TextStyle(
          color: AppColors.accent,
          fontFamily: 'NotoSans',
        ),
      ),
    );
  }
}
