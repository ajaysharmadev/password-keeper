import './password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

var uuid = const Uuid();
Map<String, Icon> iconsMap = {
  'facebook': const Icon(FontAwesome5.facebook, size: 70,),
  'youtube': const Icon(FontAwesome5.youtube_square, size: 70),
  'others': const Icon(FontAwesome5.user, size: 70)
};

class Passwords with ChangeNotifier {
  List<Password> _passwords = [
    Password(
        title: 'Valorant Password',
        email_username: 'ajaybhaijitega',
        password: 'password',
        passwordType: 'Valorant',
        id: '1'),
    Password(
        title: 'Facebook Password',
        email_username: 'ajaysharma.13122000@gmail.com',
        password: 'password',
        icon: 'facebook',
        passwordType: 'Facebook',
        id: '2'),
    Password(
        title: 'YouTube Password',
        email_username: 'callitechnology008@gmail.com',
        password: 'password',
        icon: 'youtube',
        passwordType: 'YouTube',
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
        id: uuid.v1());
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
