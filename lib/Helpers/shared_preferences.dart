import 'package:password_keeper/providers/password.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
//Not used in project
class SharedPref {
  
  // read(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String myPasswordString = prefs.getString(key) ?? '';
  //   return json.decode(myPasswordString);
  // }

  // save(String key, Password password) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setString(key, json.encode(password));
  // }

  // remove(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.remove(key);
  // }

  // readStringList(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List listOfpasswordString = prefs.getStringList(key) ?? [];
  //   List listOfPasswords = [];
  //   listOfpasswordString
  //       .map((stringItem) => listOfPasswords.add(json.decode(stringItem)));
  //   return listOfPasswords;
  // }

  // saveStringList(String key, List listOfPasswords) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   List<String> listOfpasswordString = [];
  //   listOfPasswords
  //       .map((password) => listOfpasswordString.add(json.encode(password)));
  //   prefs.setStringList(key, listOfpasswordString);
  // }
}
