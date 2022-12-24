import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Custom_button extends StatelessWidget {
  const Custom_button({
    Key? key,
    required this.width,
    required this.height,
    required this.onpressed,
    required this.title,
  }) : super(key: key);

  final double width;
  final double height;
  final VoidCallback onpressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Container(
        width: width * 0.9,
        height: height * 0.07,
        child: ElevatedButton(
          onPressed: onpressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide(color: Colors.white),
            ),
            elevation: 0,
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
