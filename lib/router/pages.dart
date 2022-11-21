import 'package:flutter/cupertino.dart';
import 'package:sixcore/Screens/Auth/Login/index.dart';
import 'package:sixcore/Screens/Auth/Login/reset_password.dart';
import 'package:sixcore/Screens/Auth/Register/confirmation.dart';
import 'package:sixcore/Screens/Auth/Register/index.dart';
import 'package:sixcore/Screens/Dashboard/index.dart';
import 'package:sixcore/init_page.dart';
import 'package:sixcore/router/routes.dart';

class Pages {
  static const initialRoute = Routes.initRoute;
  static Map<String, WidgetBuilder> routes = {
    Routes.initRoute: (context) => const InitPage(),
    Routes.loginRoute: (context) => const LoginPage(),
    Routes.resetPasswordRoute: (context) => const ResetPasswordPage(),
    Routes.registerRoute: (context) => const RegistrationPage(),
    Routes.confirmRoute: (context) => const ConfirmationPage(),
    Routes.dashboardRoute: (context) => const DashboardPage(),
  };
}
