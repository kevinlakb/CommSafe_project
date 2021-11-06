import 'package:flutter/material.dart';

class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackBar = new SnackBar(
      content:
          Text(message, style: TextStyle(color: Colors.white, fontSize: 20)),
    );

    messengerKey.currentState.showSnackBar(snackBar);
  }
}
