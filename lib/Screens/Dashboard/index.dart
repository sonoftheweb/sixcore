import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Provider/user_provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Consumer<UserProvider>(
              builder: (context, user, _) {
                return Text('Welcome back ${user.currentUser?.displayName}');
              },
            ),
          ),
        ),
      ),
    );
  }
}
