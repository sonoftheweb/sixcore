import 'package:flutter/material.dart';
import 'package:sixcore/Screens/Auth/Login/index.dart';
import 'package:sixcore/Screens/Auth/Login/reset_password.dart';
import 'package:sixcore/Screens/Auth/Register/confirmation.dart';
import 'package:sixcore/Screens/Auth/Register/index.dart';
import 'package:sixcore/Screens/Auth/Register/social_auth_register.dart';
import 'package:sixcore/Screens/Dashboard/index.dart';
import 'package:sixcore/Screens/Routines/create.dart';
import 'package:sixcore/Screens/Routines/view.dart';
import 'package:sixcore/Screens/Routines/work.dart';
import 'package:sixcore/init_page.dart';
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
    Routes.createRoutineRoute: (context) => const CreateRoutine(),
    Routes.viewRoutineRoute: (context) => const ViewRoutine(),
    Routes.workRoutineRoute: (context) => const WorkRoutine(),
  };
}

class BottomNavMenuItems {
  BottomNavMenuItems({Key? key});

  List<Map<String, dynamic>> menuList() {
    return [
      {
        'title': 'Home',
        'icon': Icons.home_rounded,
        'widget': Container(),
      },
      {
        'title': 'Library',
        'icon': Icons.apps,
        'widget': Container(),
      },
      {
        'title': 'Progress',
        'icon': Icons.multiline_chart,
        'widget': Container(),
      },
      {
        'title': 'Settings',
        'icon': Icons.settings_outlined,
        'widget': Container(),
      },
    ];
  }
}
