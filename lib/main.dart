import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hydroponic_garden/firebase/auth.dart';
import 'package:hydroponic_garden/firebase/firebase_options.dart';
import 'package:hydroponic_garden/model/plant.dart';
import 'package:hydroponic_garden/widgets/calendar_widget.dart';
import 'package:hydroponic_garden/widgets/device_widget.dart';
import 'package:hydroponic_garden/widgets/login_widget.dart';
import 'package:hydroponic_garden/widgets/plant_widget.dart';
import 'package:hydroponic_garden/widgets/plants_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Auth.instance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:
          Auth.instance().user != null ? const PlantsPage() : const LoginPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case PlantPage.routeName:
            final args = settings.arguments as Plant;
            return MaterialPageRoute(builder: (context) {
              return PlantPage(plant: args);
            });
          case PlantsPage.routeName:
            return MaterialPageRoute(builder: (contex) {
              return const PlantsPage();
            });
          case LoginPage.routeName:
            return MaterialPageRoute(builder: (contex) {
              return const LoginPage();
            });
          case CalendarPage.routeName:
            return MaterialPageRoute(builder: (context) {
              return CalendarPage();
            });
          case DevicePage.routeName:
            return MaterialPageRoute(builder: (context) {
              return const DevicePage();
            });
          default:
            assert(false, 'Need to implement ${settings.name}');
        }
        return null;
      },
    );
  }
}
