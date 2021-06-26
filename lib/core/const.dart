import 'package:flutter/material.dart';

// used to outline text with a black outline
List<Shadow> textOutline = [
  Shadow(
      // bottomLeft
      offset: Offset(-1.5, -1.5),
      color: Colors.black),
  Shadow(
      // bottomRight
      offset: Offset(1.5, -1.5),
      color: Colors.black),
  Shadow(
      // topRight
      offset: Offset(1.5, 1.5),
      color: Colors.black),
  Shadow(
      // topLeft
      offset: Offset(-1.5, 1.5),
      color: Colors.black),
];
