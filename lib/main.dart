import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sixcore/Constants/styles.dart';
import 'package:sixcore/Provider/app_provider.dart';
import 'package:sixcore/Provider/auth_provider.dart';
import 'package:sixcore/Provider/registration_provider.dart';
import 'package:sixcore/Provider/routine_provider.dart';
import 'package:sixcore/Provider/user_provider.dart';
import 'package:sixcore/router/pages.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => RegistrationProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => AppProvider()),
        ChangeNotifierProvider(create: (context) => RoutineProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Sixcore App',
        theme: appThemeData[AppTheme.lightTheme],
        darkTheme: appThemeData[AppTheme.darkTheme],
        initialRoute: Pages.initialRoute,
        routes: Pages.routes,
      ),
    );
  }
}
