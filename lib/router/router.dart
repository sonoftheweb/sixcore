import 'package:flutter/material.dart';

class PageNavigator {
  BuildContext context;
  PageNavigator({required this.context});

  Future nextPage({required String page}) {
    return Navigator.pushNamed(context, page);
  }

  void nextPageOnly({required String page}) {
    Navigator.pushNamedAndRemoveUntil(context, page, (route) => false);
  }
}
