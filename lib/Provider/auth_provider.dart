import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

import '../firebase_options.dart';

class AuthenticationProvider extends ChangeNotifier {
  // Setters
  bool _isLoading = false;
  String _responseMessage = '';

  // Getters
  bool get isLoading => _isLoading;
  String get responseMessage => _responseMessage;

  void loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = FirebaseAuth.instance.currentUser;

      final String navigateTo = (user?.emailVerified ?? false)
          ? Routes.dashboardRoute
          : Routes.confirmRoute;

      _isLoading = false;
      notifyListeners();

      PageNavigator(context: context).nextPageOnly(page: navigateTo);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _isLoading = false;
        _responseMessage = 'No user found for that email.';
        notifyListeners();
      } else if (e.code == 'wrong-password') {
        _isLoading = false;
        _responseMessage = 'Wrong password provided for that user.';
        notifyListeners();
      } else {
        _isLoading = false;
        _responseMessage = 'Something went wrong. Please try again later.';
        notifyListeners();
      }
    }
  }

  void loginWithGoogle({required BuildContext context}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
          .signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);
        PageNavigator(context: context)
            .nextPageOnly(page: Routes.dashboardRoute);
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _responseMessage = e.message!;
      notifyListeners();
    }
  }

  void clearMessage() {
    _responseMessage = "";
    notifyListeners();
  }

  Future<void> sendResetRequest({
    required BuildContext context,
    required String email,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _isLoading = false;
      _responseMessage = 'Password reset email was sent to $email';
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      _responseMessage = e.message!;
      notifyListeners();
    }
  }
}
