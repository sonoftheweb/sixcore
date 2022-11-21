import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Provider/app_provider.dart';
import 'package:sixcore/Provider/user_provider.dart';
import 'package:sixcore/Widgets/appbar.dart';

import '../../Widgets/navigation_menu.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AnimatedAppbar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Consumer<UserProvider>(
              builder: (context, user, _) {
                return Text('Welcome, ${user.currentUser?.displayName}');
              },
            ),
          ),
        ),
      ),
      drawer: const NavigationDrawer(),
      onDrawerChanged: (isOpened) {
        if (!isOpened) {
          Provider.of<AppProvider>(context, listen: false).isDrawerOpen = false;
        }
      },
    );
  }
}
