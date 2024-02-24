import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color purpleColor = const Color(0xff5843BE);
Color orangeColor = const Color(0xffFF9376);
Color blackColor = Colors.grey[800]!;
Color whiteColor = const Color(0xffFFFFFF);
Color greyColor = Colors.grey[800]!;

double edge = 24;

TextStyle blackTextStyle({double? fontSize = 14}) =>
    GoogleFonts.poppins().copyWith(
      fontWeight: FontWeight.bold,
      color: blackColor,
      fontSize: fontSize,
      height: 1.5,
    );

TextStyle whiteTextStyle({double? fontSize = 14}) =>
    GoogleFonts.poppins().copyWith(
      fontWeight: FontWeight.w600,
      color: whiteColor,
      fontSize: fontSize,
      height: 1.5,
    );

TextStyle greyTextStyle({double? fontSize = 14}) =>
    GoogleFonts.poppins().copyWith(
      fontWeight: FontWeight.w800,
      color: Colors.grey[500],
      fontSize: fontSize,
      height: 1.5,
    );

TextStyle purpleTextStyle({double? fontSize = 14}) =>
    GoogleFonts.poppins().copyWith(
      fontWeight: FontWeight.w500,
      color: purpleColor,
      fontSize: fontSize,
      height: 1.5,
    );

TextStyle hintTextStyle({double? fontSize = 14}) =>
    GoogleFonts.poppins().copyWith(
      fontWeight: FontWeight.w500,
      color: Colors.grey[800],
      fontSize: fontSize,
      height: 1.5,
    );
