import 'package:flutter/material.dart';
import 'package:hydroponic_garden/firebase/auth.dart';
import 'package:hydroponic_garden/widgets/plants_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.green,
          Colors.blue,
        ])),
        child: Card(
          margin: const EdgeInsets.only(
            top: 200,
            bottom: 200,
            left: 30,
            right: 30,
          ),
          elevation: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                'Hydroponic Garden',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                ),
                child: MaterialButton(
                  color: Colors.teal[100],
                  elevation: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/google_icon.png'),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      const Text(
                        'Sign In with Google',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Auth.instance().signIn().then(
                      (value) {
                        Navigator.popAndPushNamed(
                            context, PlantsPage.routeName);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
