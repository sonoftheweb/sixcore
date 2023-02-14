import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Constants/colors.dart';
import '../../../Provider/auth_provider.dart';
import '../../../Utils/snackbar.dart';
import '../../../Widgets/button.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset password'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 30,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Fill in the email which was used to create your account to initiate password reset.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.8,
              ),
            ),
            const SizedBox(height: 20),
            _emailField(),
            const SizedBox(height: 20),
            Consumer<AuthenticationProvider>(
              builder: (context, auth, _) {
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
                    if (_email.text.isEmpty) {
                      errorMessage(
                        message: 'Please enter a valid email.',
                        context: context,
                      );
                    } else {
                      auth.sendResetRequest(
                        context: context,
                        email: _email.text.trim(),
                      );
                    }
                  },
                  isLoading: auth.isLoading,
                  label: 'Reset Password',
                );
              },
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
      style: TextStyle(color: AppColor.blue),
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.email),
        hintText: 'Enter your registered email',
      ),
    );
  }
}
