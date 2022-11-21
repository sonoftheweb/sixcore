import 'package:flutter/cupertino.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;
}
