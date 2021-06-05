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
        child: Chip(
          label: Text('Password: ${password.password}'),
        ),
      ),
    );
  }
}
