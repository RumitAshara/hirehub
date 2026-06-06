import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simbiotik/Themes/AppTheme.dart';

class Textcomponent extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final FontWeight weight;
  final TextAlign textAlign;
  final TextOverflow overflow;
  const Textcomponent({required this.text,required this.size, required this.weight,this.color = AppThemes.textcolor,this.textAlign = TextAlign.start , this.overflow = TextOverflow.visible,super.key,});

  @override
  Widget build(BuildContext context) {
    return Text(
      '$text',
      style: GoogleFonts.rubik(
        color: color,
        fontSize: size,
        fontWeight: weight,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );;
  }
}
