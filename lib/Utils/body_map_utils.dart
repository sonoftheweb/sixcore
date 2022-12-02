import 'package:flutter/material.dart';

Color pointsColor(int bodyPart) {
  switch (bodyPart) {
    case 1:
    case 2:
    case 3:
      return Colors.green;
    case 4:
    case 5:
    case 6:
      return Colors.orange;
    case 7:
    case 8:
    case 9:
    case 10:
      return Colors.red;
    default:
      return Colors.white;
  }
}
