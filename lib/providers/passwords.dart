import './password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

var uuid = const Uuid();
Map<String, Icon> iconsMap = {
  'facebook': const Icon(FontAwesome5.facebook, size: 70),
  'twitter': const Icon(FontAwesome5.twitter, size: 70),
  'reddit': const Icon(FontAwesome5.reddit, size: 70),
  'google': const Icon(FontAwesome5.google, size: 70),
  'github': const Icon(FontAwesome5.github, size: 70),
  'microsoft': const Icon(FontAwesome5.microsoft, size: 70),
  'yahoo': const Icon(FontAwesome5.yahoo, size: 70),
  'apple': const Icon(FontAwesome5.apple, size: 70),
  'others': const Icon(FontAwesome5.user, size: 70)
};

class Passwords with ChangeNotifier {
  List<Password> _passwords = [
    Password(
        title: 'Google',
        email_username: 'ajaysharma.13122000@gmail.com',
        password: 'password',
        icon: 'google',
        passwordType: 'Google',
        id: '1'),
    Password(
        title: 'Facebook Password',
        email_username: 'ajaysharma.13122000@gmail.com',
        password: 'password',
        icon: 'facebook',
        passwordType: 'Facebook',
        id: '2'),
    Password(
        title: 'Apple Password',
        email_username: 'callitechnology008@gmail.com',
        password: 'password',
        icon: 'apple',
        passwordType: 'Apple',
        id: '3')
  ];

  List<Password> get items {
    return [..._passwords];
  }

  List<Password> get favoriteItems {
    return _passwords.where((passwordItem) => passwordItem.isFavorite).toList();
  }

  void deletePassword(String id) {
    _passwords.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

  void addPassword(Password password) {
    final newPassword = Password(
        title: password.title,
        email_username: password.email_username,
        password: password.password,
        passwordType: password.passwordType,
        icon: password.icon,
        id: password.id);
    _passwords.add(newPassword);
    notifyListeners();
  }

  Password findById(String id) {
    return _passwords.firstWhere((password) => password.id == id);
  }

  void updatePassword(String id, Password newPassword) {
    final passwordIndex =
        _passwords.indexWhere((password) => password.id == id);
    if (passwordIndex >= 0) {
      _passwords[passwordIndex] = newPassword;
      notifyListeners();
    } else {
      print('Password not Found');
    }
  }
}
