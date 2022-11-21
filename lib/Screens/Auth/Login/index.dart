import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Provider/auth_provider.dart';
import 'package:sixcore/Widgets/button.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

import '../../../Utils/snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: _loginForm(),
        ),
      ),
    );
  }

  _loginForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 30.0),
            _emailField(),
            const SizedBox(height: 20.0),
            _passwordField(),
            const SizedBox(height: 20.0),
            Consumer<AuthenticationProvider>(builder: (context, auth, _) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (auth.responseMessage != '') {
                  warningMessage(
                    message: auth.responseMessage,
                    context: context,
                  );
                  auth.clearMessage();
                }
              });
              return StatefulButton(
                onTap: () {
                  if (_email.text.isEmpty || _password.text.isEmpty) {
                    errorMessage(
                      message: 'All fields are required',
                      context: context,
                    );
                  } else {
                    auth.loginUser(
                      context: context,
                      email: _email.text.trim(),
                      password: _password.text.trim(),
                    );
                  }
                },
                isLoading: auth.isLoading,
                label: 'Login',
              );
            }),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () {
                PageNavigator(context: context)
                    .nextPage(page: Routes.resetPasswordRoute);
              },
              child: const Text(
                'Forgot password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(height: 50.0),
            const Text('Or login with social accounts'),
            const SizedBox(height: 30.0),
            Consumer<AuthenticationProvider>(builder: (context, auth, _) {
              return SignInButton(
                Buttons.Google,
                onPressed: () {
                  auth.loginWithGoogle(context: context);
                },
              );
            }),
            const SizedBox(height: 30.0),
            GestureDetector(
              onTap: () {
                PageNavigator(context: context)
                    .nextPageOnly(page: Routes.registerRoute);
              },
              child: const Text(
                'Don\'t have an account? Create one now!',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _emailField() {
    return TextFormField(
      controller: _email,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: 'Enter your registered email',
      ),
    );
  }

  TextFormField _passwordField() {
    return TextFormField(
      controller: _password,
      obscureText: true,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.security),
        hintText: 'Enter a password',
      ),
    );
  }
}
