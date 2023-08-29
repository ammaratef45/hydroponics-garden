import 'package:flutter/material.dart';
import 'package:hydroponic_garden/firebase/auth.dart';
import 'package:hydroponic_garden/widgets/login_widget.dart';

class MainWidget extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;
  final String title;
  final bool logoutIcon;
  const MainWidget(
      {required this.body,
      this.floatingActionButton,
      this.title = 'default-title',
      this.logoutIcon = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        actions: [
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
    );
  }
}
