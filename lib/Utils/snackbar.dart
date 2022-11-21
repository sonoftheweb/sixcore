import 'package:flutter/material.dart';

import '../Constants/colors.dart';

void showMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(
        message!,
      ),
    ),
  );
}

void successMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(
        message!,
        style: TextStyle(
          color: AppColor.white,
        ),
      ),
      backgroundColor: AppColor.teal,
    ),
  );
}

void errorMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(
        message!,
        style: TextStyle(
          color: AppColor.white,
        ),
      ),
      backgroundColor: AppColor.error,
    ),
  );
}

void warningMessage({String? message, BuildContext? context}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      content: Text(
        message!,
        style: TextStyle(
          color: AppColor.grey,
        ),
      ),
      elevation: 0,
      backgroundColor: AppColor.warning,
      behavior: SnackBarBehavior.floating,
    ),
  );
}
