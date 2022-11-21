import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sixcore/Constants/colors.dart';

import '../router/router.dart';
import '../router/routes.dart';

class RegistrationProvider with ChangeNotifier {
  bool _isMale = true;
  double _height = 163;
  int _weight = 27;
  int _age = 30;
  bool _isLoading = false;
  String _name = '';
  String _email = '';
  String _password = '';
  String _responseMessage = '';

  bool get isMale => _isMale;
  double get height => _height;
  int get weight => _weight;
  int get age => _age;
  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  set isMale(bool value) {
    _isMale = value;
    notifyListeners();
  }

  set height(double value) {
    _height = value;
    notifyListeners();
  }

  set weight(int value) {
    _weight = value;
    notifyListeners();
  }

  set age(int value) {
    _age = value;
    notifyListeners();
  }

  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set password(String value) {
    _password = value;
  }

  get color => _isMale ? Colors.blue : Colors.pink;
  get maleColor => _isMale ? Colors.blue : AppColor.greyShade400;
  get femaleColor => _isMale ? AppColor.greyShade400 : Colors.pink;

  signUp({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(_name);
      await FirebaseFirestore.instance.collection('userProfile').add({
        'userId': user?.uid,
        'name': _name,
        'height': _height,
        'weight': _weight,
        'age': _age,
      });
      await user?.sendEmailVerification();
      _isLoading = false;
      notifyListeners();
      PageNavigator(context: context).nextPageOnly(page: Routes.confirmRoute);
    } on FirebaseAuthException catch (e) {
      _responseMessage = e.message!;
      notifyListeners();
    }
  }

  socialSignUp({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(_name);
      await FirebaseFirestore.instance.collection('userProfile').add({
        'userId': user?.uid,
        'name': _name,
        'height': _height,
        'weight': _weight,
        'age': _age,
      });
      _isLoading = false;
      notifyListeners();
      PageNavigator(context: context).nextPageOnly(page: Routes.dashboardRoute);
    } on FirebaseAuthException catch (e) {
      _responseMessage = e.message!;
      notifyListeners();
    }
  }

  void clearMessage() {
    _responseMessage = "";
    notifyListeners();
  }
}
