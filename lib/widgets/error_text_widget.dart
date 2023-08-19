import 'package:flutter/material.dart';

class ErrorTextWidget extends StatelessWidget {
  static const ErrorTextWidget failedToLoad =
      ErrorTextWidget(text: 'Failed to fetch data!!');
  final String text;

  const ErrorTextWidget({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.red, fontSize: 20),
    ));
  }
}
