// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

class ViewPhoto extends StatelessWidget {
  final String image;
  const ViewPhoto({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Text(
          'PHOTO',
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
      body: PhotoView(
        imageProvider: NetworkImage(image),
      ),
    );
  }
}
