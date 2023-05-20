import 'package:flutter/material.dart';

const MaterialColor blueprimary = MaterialColor(_blueprimaryPrimaryValue, <int, Color>{
  50: Color(0xFFE3EDF2),
  100: Color(0xFFB9D3DF),
  200: Color(0xFF8AB6CA),
  300: Color(0xFF5B98B4),
  400: Color(0xFF3782A4),
  500: Color(_blueprimaryPrimaryValue),
  600: Color(0xFF12648C),
  700: Color(0xFF0E5981),
  800: Color(0xFF0B4F77),
  900: Color(0xFF063D65),
});
const int _blueprimaryPrimaryValue = 0xFF146C94;

const MaterialColor blueprimaryAccent = MaterialColor(_blueprimaryAccentValue, <int, Color>{
  100: Color(0xFF96CDFF),
  200: Color(_blueprimaryAccentValue),
  400: Color(0xFF309CFF),
  700: Color(0xFF1690FF),
});
const int _blueprimaryAccentValue = 0xFF63B4FF;
