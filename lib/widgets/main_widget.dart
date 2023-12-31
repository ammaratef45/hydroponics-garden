import 'package:flutter/material.dart';
import 'package:hydroponic_garden/firebase/auth.dart';
import 'package:hydroponic_garden/widgets/calendar_widget.dart';
import 'package:hydroponic_garden/widgets/device_widget.dart';
import 'package:hydroponic_garden/widgets/login_widget.dart';
import 'package:hydroponic_garden/widgets/pages/admin_widget.dart';
import 'package:hydroponic_garden/widgets/plants_widget.dart';

class MainWidget extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final String title;
  final bool logoutIcon;
  final bool showBottomNavigationMenu;
  final int navigationIndex;
  final List<IconButton> actions;
  const MainWidget(
      {required this.body,
      this.floatingActionButton,
      this.title = 'default-title',
      this.logoutIcon = false,
      this.showBottomNavigationMenu = false,
      this.navigationIndex = 0,
      this.actions = const [],
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
          ...actions,
          if (logoutIcon)
            IconButton(
              onPressed: () {
                Auth.instance().logout().then((value) =>
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginPage.routeName, (route) => false));
              },
              icon: const Icon(Icons.logout),
            ),
        ],
      ),
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: showBottomNavigationMenu
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: navigationIndex,
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.popAndPushNamed(context, PlantsPage.routeName);
                    break;
                  case 1:
                    Navigator.popAndPushNamed(context, CalendarPage.routeName);
                    break;
                  case 2:
                    Navigator.popAndPushNamed(context, DevicePage.routeName);
                    break;
                  case 3:
                    Navigator.popAndPushNamed(context, AdminWidget.routeName);
                    break;
                  default:
                    throw 'invalid page';
                }
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'plants',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.calendar_month),
                  label: 'calendar',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.devices),
                  label: 'Device',
                ),
                if (Auth.instance().isAdmin())
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.devices),
                    label: 'Admin',
                  ),
              ],
            )
          : null,
    );
  }
}
