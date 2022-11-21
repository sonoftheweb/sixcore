import 'package:flutter/material.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

class ConfirmationPage extends StatelessWidget {
  const ConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm account'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Icon(
                Icons.mark_email_unread,
                size: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'A message has been sent to the email address you provided. Please confirm the email.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  height: 1.8,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Confirmed account?',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  PageNavigator(context: context)
                      .nextPageOnly(page: Routes.loginRoute);
                },
                label: const Text('Return to Login'),
                icon: const Icon(Icons.key),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
