import 'package:flutter/material.dart';

import '../Screens/Dashboard/index.dart';

class NavigationConstants {
  static List menuPages = [
    {
      'icon': Icons.home,
      'label': 'Home',
      'widget': const DashboardPage(),
    },
    {
      'icon': Icons.explore,
      'label': 'Explore',
      'widget': const DashboardPage(),
    },
    {
      'icon': Icons.chat_bubble_outline,
      'label': 'Messages',
      'widget': const DashboardPage(),
    },
    {
      'icon': Icons.settings,
      'label': 'Settings',
      'widget': const DashboardPage(),
    },
  ];
}
