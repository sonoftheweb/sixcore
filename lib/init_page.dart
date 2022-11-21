import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sixcore/Constants/colors.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
    figureOutAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AppColor.teal,
        ),
      ),
    );
  }

  Future<void> figureOutAuth(context) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user?.reload();

    if (user == null) {
      PageNavigator(context: context).nextPageOnly(page: Paths.loginPath);
    } else {
      PageNavigator(context: context).nextPageOnly(page: Paths.dashboardPath);
    }
  }
}
