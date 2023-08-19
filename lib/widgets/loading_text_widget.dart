import 'package:flutter/material.dart';

class LoadingTextWidget extends StatelessWidget {
  static const LoadingTextWidget standard =
      LoadingTextWidget(text: 'Loading.....');
  final String text;

  const LoadingTextWidget({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
    ));
  }
}
