import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sixcore/Screens/Auth/Login/index.dart';
import 'package:sixcore/Screens/Auth/Login/reset_password.dart';
import 'package:sixcore/Screens/Auth/Register/confirmation.dart';
import 'package:sixcore/Screens/Auth/Register/index.dart';
import 'package:sixcore/Screens/Auth/Register/social_auth_register.dart';
import 'package:sixcore/Screens/Dashboard/index.dart';
import 'package:sixcore/init_page.dart';
import 'package:sixcore/router/router.dart';
import 'package:sixcore/router/routes.dart';

class Pages {
  static const initialRoute = Routes.initRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.initRoute: (context) => const InitPage(),
    Routes.loginRoute: (context) => const LoginPage(),
    Routes.resetPasswordRoute: (context) => const ResetPasswordPage(),
    Routes.registerRoute: (context) => const RegistrationPage(),
    Routes.socialAuthRegisterRoute: (context) =>
        const SocialAuthRegistrationPage(),
    Routes.confirmRoute: (context) => const ConfirmationPage(),
    Routes.dashboardRoute: (context) => const DashboardPage(),
  };
}

class SideNavMenuItems {
  BuildContext context;

  SideNavMenuItems({Key? key, required this.context});

  List<Widget> menuList() {
    return [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: Text('home'.toUpperCase()),
        onTap: () => {},
      ),
      ListTile(
        leading: const Icon(Icons.timelapse_rounded),
        title: Text('history'.toUpperCase()),
        onTap: () => {},
      ),
      ListTile(
        leading: const Icon(Icons.auto_graph_outlined),
        title: Text('stats'.toUpperCase()),
        onTap: () => {},
      ),
      ListTile(
        leading: const Icon(Icons.edit_note_outlined),
        title: Text('library'.toUpperCase()),
        onTap: () => {},
      ),
      ListTile(
        leading: const Icon(Icons.settings_outlined),
        title: Text('settings'.toUpperCase()),
        onTap: () => {},
      ),
      Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height - 600,
            ),
            child: ListTile(
              leading: const Icon(Icons.upload),
              title: Text('share'.toUpperCase()),
              onTap: () => {},
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text('logout'.toUpperCase()),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              PageNavigator(context: context)
                  .nextPageOnly(page: Routes.loginRoute);
            },
          ),
        ],
      ),
    ];
  }
}
