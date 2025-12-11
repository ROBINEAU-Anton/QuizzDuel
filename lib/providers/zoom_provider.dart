import 'package:flutter/material.dart';

class ZoomProvider extends ChangeNotifier {
  double _textScaleFactor = 1.0;

  double get textScaleFactor => _textScaleFactor;

  void setScale(double scale) {
    if (scale < 0.8 || scale > 2.0) return;
    _textScaleFactor = scale;
    notifyListeners();
  }
}
