import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Custom_passwordTextField extends StatefulWidget {
  const Custom_passwordTextField(
      {required this.hinttext,
      required this.labeltext,
      required this.prefixIcon,
      this.validator,
      required this.controller,
      super.key});
  final String hinttext;
  final String labeltext;
  final Icon prefixIcon;
  final String? Function(String?)? validator;
  final TextEditingController controller;

  @override
  State<Custom_passwordTextField> createState() =>
      _Custom_passwordTextFieldState();
}

class _Custom_passwordTextFieldState extends State<Custom_passwordTextField> {
  late bool _passwordVisible;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: !_passwordVisible,
      validator: widget.validator,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: widget.prefixIcon,
        hintText: widget.hinttext,
        labelText: widget.labeltext,
        suffixIcon: IconButton(
          icon: Icon(
            _passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
        ),
        labelStyle: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.black,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.black,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
