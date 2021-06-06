import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:password_keeper/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoginForm = true;
  var _isLoading = false;
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(String email, String password, bool isLoginForm,
      BuildContext ctx, File? image) async {
    var authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLoginForm) {
        print('login steps executing');
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        setState(() {
          _isLoading = false;
        });
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(FirebaseAuth.instance.currentUser!.uid + '.jpg');
        await ref.putFile(image!).whenComplete(() async {
          final url = await ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'email': email,
            'image_url': url,
          });
        });

        setState(() {
          isLoginForm = !isLoginForm;
          _isLoading = false;
        });
      }
    } catch (err) {
      var message = err.toString();
      final snackBar = SnackBar(
        content: Text(message),
      );
      print('message' + message);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
            width: deviceWidth,
            height: !isLoginForm ? deviceHeight * 0.92 : deviceHeight * 0.73,
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.05, vertical: deviceHeight * 0.1),
            child: Card(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: FlutterSwitch(
                        activeText: "Log In",
                        inactiveText: "Sign Up",
                        value: isLoginForm,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white,
                        valueFontSize: 25.0,
                        width: deviceWidth * 0.4,
                        height: deviceHeight * 0.06,
                        borderRadius: 30.0,
                        showOnOff: true,
                        toggleSize: 40,
                        inactiveColor: Colors.pink,
                        activeTextFontWeight: FontWeight.w400,
                        inactiveTextFontWeight: FontWeight.w400,
                        onToggle: (val) {
                          setState(() {
                            isLoginForm = val;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: AuthForm(_isLoading, _submitAuthForm, isLoginForm),
                    ),
                  )
                  // Container(6
                  //   alignment: Alignment.centerRight,
                  //   child: Text(
                  //     "Value: $isLoginForm",
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        // color: Colors.blueAccent,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 0.0),
                colors: <Color>[Colors.blueAccent, Colors.purpleAccent])),
      ),
    );
  }
}
