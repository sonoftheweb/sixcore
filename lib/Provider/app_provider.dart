import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isDrawerOpen = false;

  bool get isLoading => _isLoading;
  bool get isDrawerOpen => _isDrawerOpen;

  set isDrawerOpen(bool value) {
    _isDrawerOpen = value;
    notifyListeners();
  }
}
