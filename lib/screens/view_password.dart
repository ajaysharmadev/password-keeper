import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:provider/provider.dart';
import '../providers/passwords.dart';

import 'package:flutter/material.dart';

class ViewScreen extends StatelessWidget {
  const ViewScreen({Key? key}) : super(key: key);
  static const routeName = 'view-screen';
  @override
  Widget build(BuildContext context) {
    final passwordId = ModalRoute.of(context)!.settings.arguments as String;
    final password = Provider.of<Passwords>(context).findById(passwordId);
    return Scaffold(
      appBar: AppBar(
        title: Text(password.title),
      ),
      body: Center(
          child: Container(
        padding: const EdgeInsets.all(10),
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(FontAwesome5.pen),
                  title: const Text('Title'),
                  subtitle: Text(password.title),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(FontAwesome5.at),
                  title: const Text('Email/Username'),
                  subtitle: Text(password.email_username),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: const Icon(FontAwesome5.key),
                  title: const Text('Password'),
                  subtitle: Text(password.password),
                ),
                const Divider(),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: iconsMapNormal[password.icon],
                  title: const Text('Password Type'),
                  subtitle: Text(password.passwordType),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
