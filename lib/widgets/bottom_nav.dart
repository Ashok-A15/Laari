import 'package:flutter/material.dart';
import '../pages/dashboard_page.dart';
import '../pages/drivers_page.dart';
import '../pages/settings_page.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  const BottomNavBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        if (i == 0) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
        if (i == 1) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriversPage()));
        if (i == 2) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Drivers"),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
      ],
    );
  }
}
