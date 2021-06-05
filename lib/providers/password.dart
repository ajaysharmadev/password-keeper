import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

var uuid = const Uuid();


class Password with ChangeNotifier {
  String title;
  String email_username;
  String password;
  String passwordType;
  String icon;
  bool isFavorite;
  String id;

  Password(
      {required this.title,
      required this.email_username,
      required this.password,
      required this.passwordType,
      required this.id,
      this.icon = 'others',
      this.isFavorite = false});

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
