import 'package:flutter/material.dart';

class CustomSize {
  double getWidth(int percent, context) {
    return MediaQuery.of(context).size.width * percent / 100;
  }

  double getHeight(int percent, context) {
    return MediaQuery.of(context).size.height * percent / 100;
  }
}
