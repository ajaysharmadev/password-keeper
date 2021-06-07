import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:uuid/uuid.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:password_keeper/providers/password.dart';

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
Map<String, Icon> iconsMapNormal = {
  'facebook': const Icon(
    FontAwesome5.facebook,
  ),
  'twitter': const Icon(
    FontAwesome5.twitter,
  ),
  'reddit': const Icon(
    FontAwesome5.reddit,
  ),
  'google': const Icon(
    FontAwesome5.google,
  ),
  'github': const Icon(
    FontAwesome5.github,
  ),
  'microsoft': const Icon(
    FontAwesome5.microsoft,
  ),
  'yahoo': const Icon(
    FontAwesome5.yahoo,
  ),
  'apple': const Icon(
    FontAwesome5.apple,
  ),
  'others': const Icon(
    FontAwesome5.user,
  )
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
  Passwords() {
    _passwords = [];
    loadData();
  }

  List<Password> get items {
    return [..._passwords];
  }

  set setPasswordsList(List<Password> list) {
    this._passwords = list;
  }

  List<Password> get favoriteItems {
    return _passwords.where((passwordItem) => passwordItem.isFavorite).toList();
  }

  void deletePassword(String id) {
    _passwords.removeWhere((prod) => prod.id == id);
    saveData();
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
    saveData();
    notifyListeners();
  }

  Password findById(String id) {
    return _passwords.firstWhere((password) => password.id == id,
        orElse: () => Password(
            title: 'Loading...',
            email_username: 'Loading...',
            password: 'Loading...',
            passwordType: 'Loading...',
            id: 'Loading...'));
  }

  void updatePassword(String id, Password newPassword) async {
    final passwordIndex =
        _passwords.indexWhere((password) => password.id == id);
    if (passwordIndex >= 0) {
      _passwords[passwordIndex] = newPassword;
      saveData();
      notifyListeners();
    } else {
      print('Password not Found');
    }
  }
//merged in  saveData()
  // saveDataToCloud() async {
  //   final docUserPasswords = FirebaseFirestore.instance
  //       .collection('userPasswords')
  //       .doc(FirebaseAuth.instance.currentUser!.uid);
  //   List<String> spList =
  //       _passwords.map((item) => jsonEncode(item.toMap())).toList();
  //   String joinedSpList = spList.join("!\"@");
  //   await docUserPasswords.set({
  //     "passwordString": joinedSpList,
  //   });
  // }

  void saveData() async {
    final docUserPasswords = FirebaseFirestore.instance
        .collection('userPasswords')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    List<String> spList =
        _passwords.map((item) => jsonEncode(item.toMap())).toList();
    String joinedSpList = spList.join("!\"@");
    await docUserPasswords.set({
      "passwordString": joinedSpList,
    });

    // List<String> stringList =
    //     joinedList.split("!@#%^&*()").map((e) => e.trim()).toList();
    // print(stringList[0]);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('passwordList', spList);
  }

  Future<String> loadDataFromCloud() async {
    var data = await FirebaseFirestore.instance
        .collection('userPasswords')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) => value.data());
    return data!['passwordString'];
  }

  void loadData() async {
    String passwordString =
        await loadDataFromCloud().onError((error, stackTrace) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> spList = prefs.getStringList('passwordList') as List<String>;
      _passwords =
          spList.map((item) => Password.fromMap(json.decode(item))).toList();
      notifyListeners();
      return '';
    }).timeout(const Duration(seconds: 5));
    if (passwordString != '') {
      List<String> stringList = [];
      stringList = passwordString.split("!\"@").map((e) => e.trim()).toList();
      _passwords = stringList
          .map((item) => Password.fromMap(json.decode(item)))
          .toList();
    }
    notifyListeners();
  }
}
