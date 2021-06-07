import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  Password.fromMap(Map<String, dynamic> json)
      : title = json['title'],
        email_username = json['email_username'],
        password = json['password'],
        passwordType = json['passwordType'],
        id = json['id'],
        icon = json['icon'],
        isFavorite = json['isFavorite'];

  Map<String, dynamic> toMap() => {
        'title': title,
        'email_username': email_username,
        'password': password,
        'passwordType': passwordType,
        'icon': icon,
        'isFavorite': isFavorite,
        'id': id
      };

  void toggleFavoriteStatus() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
  
}
