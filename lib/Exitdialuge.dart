import 'package:flutter/material.dart';
import 'package:motiwalajewels/Colors/appcolor.dart';
import 'package:motiwalajewels/test.dart';

import 'package:rflutter_alert/rflutter_alert.dart';

Future<bool> ExitConfirmationDialog(BuildContext context) async {
  bool exit = false; // Default value
  await Alert(
    context: context,
    type: AlertType.warning, // Choose an alert type
    title: "Exit App",
    desc: "          Are you sure you want to exit?",
    buttons: [
      DialogButton(
        onPressed: () {
          exit = false; // Stay in the app
          Navigator.of(context).pop();
        },
        color: Colors.grey, // Button background color
        radius: BorderRadius.circular(10),
        child: Text(
          "Cancel",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ), // Button shape
      ),
      DialogButton(
        onPressed: () {
          exit = true;
          Navigator.of(context).pop(); // Close the dialog
        },
        color: AppColors.theme, // Button background color
        radius: BorderRadius.circular(10),
        child: Text(
          "Exit",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ],
    style: AlertStyle(
      animationType: AnimationType.grow, // Animation type
      isCloseButton: false, // Hide the close button
      isOverlayTapDismiss: false, // Disable dismiss on tap outside
      descStyle: TextStyle(fontSize: 16, color: AppColors.splash),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.redAccent,
      ),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      constraints: BoxConstraints(
        minWidth:
            MediaQuery.of(context).size.width *
            0.7, // Minimum width (70% of screen)
        maxWidth:
            MediaQuery.of(context).size.width *
            0.9, // Maximum width (90% of screen)
      ),
      alertAlignment: Alignment.center,
    ),
  ).show();

  return exit;

  return exit;
}
