import 'package:flutter/material.dart';

class Dialogues {
  static void showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.blueGrey.shade700.withOpacity(.5),
      behavior: SnackBarBehavior.floating,
    ));
  }

  // Progress bar
  static void showProgressbar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => const Center(child: CircularProgressIndicator()));
  }
}
