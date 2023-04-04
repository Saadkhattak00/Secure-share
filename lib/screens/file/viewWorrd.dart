import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewWord extends StatefulWidget {
  final String url;
  const ViewWord({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<ViewWord> createState() => _ViewWordState();
}

class _ViewWordState extends State<ViewWord> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'VIEWWORD',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 5,
            ),
          ),
        ),
        centerTitle: true,
      ),
    );
  }
}
