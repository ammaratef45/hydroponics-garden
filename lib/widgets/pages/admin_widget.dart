import 'package:flutter/material.dart';
import 'package:hydroponic_garden/widgets/main_widget.dart';

class AdminWidget extends StatelessWidget {
  static const routeName = 'admin';

  const AdminWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return const MainWidget(
        showBottomNavigationMenu: true,
        navigationIndex: 3,
        title: 'Admin',
        body: Center(
          child: Text('to implement'),
        ));
  }
}
