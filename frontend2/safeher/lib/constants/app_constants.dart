import 'package:flutter/material.dart';

Widget getTitleLogo() {
  // Temporary fix: Use text instead of missing image asset
  return Text(
    'SafeHer',
    style: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );
  // TODO: Add actual logo image to assets/icons/titleLogo.png
  // return Image.asset('assets/icons/titleLogo.png', scale: 2.0);
}
