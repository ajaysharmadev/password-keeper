import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:password_keeper/providers/password.dart';
import 'package:password_keeper/screens/add_edit_password.dart';
import 'package:password_keeper/screens/view_password.dart';
import 'package:provider/provider.dart';

import 'package:password_keeper/screens/auth_screen.dart';
import 'package:password_keeper/screens/user_passwords_screen.dart';

import 'providers/passwords.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Passwords()),
        
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const UserPasswordsScreen();
          }
          return const AuthScreen();
        },
      ),
      routes: {
        ViewScreen.routeName: (ctx) => ViewScreen(),
        AddEditScreen.routeName: (ctx) => AddEditScreen(),

      },
    );
  }
}
