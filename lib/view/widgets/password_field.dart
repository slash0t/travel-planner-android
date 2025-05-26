import 'package:flutter/material.dart';

import '../../model/app_colors.dart';

class PasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? label;

  const PasswordField({Key? key, this.onChanged, this.label}) : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  // Initially obscure the text
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      // Toggle obscuring
      obscureText: _obscureText,
      // Pass through onChanged
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
        suffixIcon: IconButton(
          icon: Icon(
            !_obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }
}
