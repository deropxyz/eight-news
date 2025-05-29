import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//warna
Color cPrimary = const Color.fromARGB(255, 19, 7, 255);
Color cBg = const Color.fromARGB(255, 40, 39, 39);
Color cTextGrey = const Color.fromARGB(255, 128, 128, 128);
Color cBlack = const Color.fromARGB(255, 0, 0, 0);
Color cWhite = const Color.fromARGB(255, 255, 255, 255);
Color cError = const Color.fromARGB(255, 255, 0, 0);
Color cLinear = const Color.fromARGB(255, 49, 110, 189);

const Widget hsSuperTiny = SizedBox(width: 4.0);
const Widget hsTiny = SizedBox(width: 8.0);
const Widget hsSmall = SizedBox(width: 12.0);
const Widget hsMedium = SizedBox(width: 16.0);
const Widget hsLarge = SizedBox(width: 24.0);
const Widget hsXLarge = SizedBox(width: 36.0);
const Widget hsMassive = SizedBox(width: 120.0);

const Widget vsSuperTiny = SizedBox(height: 4.0);
const Widget vsTiny = SizedBox(height: 8.0);
const Widget vsSmall = SizedBox(height: 12.0);
const Widget vsMedium = SizedBox(height: 16.0);
const Widget vsLarge = SizedBox(height: 24.0);
const Widget vsXLarge = SizedBox(height: 36.0);
const Widget vsMassive = SizedBox(height: 120.0);

//* Font Weight
FontWeight thin = FontWeight.w100;
FontWeight extralight = FontWeight.w200;
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semibold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extrabold = FontWeight.w800;

//* TextStyle
TextStyle headline1 = GoogleFonts.poppins(fontSize: 40);
TextStyle headline2 = GoogleFonts.poppins(fontSize: 34);
TextStyle headline3 = GoogleFonts.poppins(fontSize: 24);
TextStyle headline4 = GoogleFonts.poppins(fontSize: 20);
TextStyle subtitle1 = GoogleFonts.poppins(fontSize: 16);
TextStyle subtitle2 = GoogleFonts.poppins(fontSize: 14);
TextStyle caption = GoogleFonts.poppins(fontSize: 12);
TextStyle overline = GoogleFonts.poppins(fontSize: 10);

OutlineInputBorder enableBorder = OutlineInputBorder(
  borderSide: BorderSide(color: cBlack),
  borderRadius: BorderRadius.circular(5),
);

OutlineInputBorder focusedBorder = OutlineInputBorder(
  borderSide: BorderSide(color: cPrimary),
  borderRadius: BorderRadius.circular(5),
);

OutlineInputBorder errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: cError),
  borderRadius: BorderRadius.circular(5),
);

OutlineInputBorder focusedErrorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: cError),
  borderRadius: BorderRadius.circular(5),
);

//* Box Decorations
BoxDecoration fieldDecortaion = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  color: Colors.grey[200],
);

BoxDecoration disabledFieldDecortaion = BoxDecoration(
  borderRadius: BorderRadius.circular(5),
  color: Colors.grey[100],
);

//* Divider
Widget spacedDivider = Column(
  children: <Widget>[
    vsTiny,
    vsTiny,
    Divider(color: cLinear, height: 4.0),
    vsTiny,
    vsTiny,
  ],
);
