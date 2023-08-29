import 'package:flutter/material.dart';

class YesNoDialog extends AlertDialog {
  final String titleText;
  final String contentText;
  final BuildContext context;
  final String okText;
  final String cancelText;
  YesNoDialog({
    required this.context,
    required this.titleText,
    required this.contentText,
    this.okText = 'Ok',
    this.cancelText = 'Cancel',
    super.key,
  }) : super(
          title: Text(titleText),
          content: Text(contentText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(okText),
            ),
          ],
        );
}
