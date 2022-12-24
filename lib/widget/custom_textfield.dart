import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Custom_TextField extends StatelessWidget {
  const Custom_TextField({
    Key? key,
    required this.hinttext,
    required this.labeltext,
    required this.prefixIcon,
    this.inputFormatters,
    this.validator,
    required this.keyboardtype,
    required this.controller,
  }) : super(key: key);

  final String hinttext;
  final String labeltext;
  final Icon prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextInputType keyboardtype;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      validator: validator,
      keyboardType: keyboardtype,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hinttext,
        labelText: labeltext,
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
