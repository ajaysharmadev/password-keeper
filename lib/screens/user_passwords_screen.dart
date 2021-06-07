import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_keeper/providers/password.dart';
import 'package:password_keeper/screens/add_edit_password.dart';
import 'package:password_keeper/widgets/password_card.dart';
import 'package:provider/provider.dart';
import 'package:password_keeper/providers/passwords.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Helpers/shared_preferences.dart';
import 'dart:io';

enum FilterOptions { favorites, all, logout }

class UserPasswordsScreen extends StatefulWidget {
  const UserPasswordsScreen({Key? key}) : super(key: key);

  @override
  State<UserPasswordsScreen> createState() => _UserPasswordsScreenState();
}

class _UserPasswordsScreenState extends State<UserPasswordsScreen> {
  String profileImageUrl = '';
  var _showOnlyFavorites = false;
  //ROLLING BACK
  // List<Password> newList = [];

  @override
  @override
  Widget build(BuildContext context) {
    var passwords;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final passwordsData = Provider.of<Passwords>(context);

    if (_showOnlyFavorites) {
      passwords = passwordsData.favoriteItems;
    } else {
      passwords = passwordsData.items;
    }

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              appBar: AppBar(
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      maxRadius: 22,
                      backgroundImage: NetworkImage(data['image_url']),
                    ),
                  ),
                ),
                title: const Text('Password Keeper'),
                backgroundColor: Theme.of(context).primaryColor,
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(AddEditScreen.routeName);
                      },
                      icon: const Icon(Icons.add)),
                  PopupMenuButton(
                    onSelected: (FilterOptions selectedValue) {
                      setState(() {
                        if (selectedValue == FilterOptions.favorites) {
                          _showOnlyFavorites = true;
                        } else if (selectedValue == FilterOptions.all) {
                          _showOnlyFavorites = false;
                        } else if (selectedValue == FilterOptions.logout) {
                          FirebaseAuth.instance.signOut();
                        }
                      });
                    },
                    icon: const Icon(Icons.more_vert_rounded),
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        child: Text('Only Favorites'),
                        value: FilterOptions.favorites,
                      ),
                      const PopupMenuItem(
                        child: Text('Show All'),
                        value: FilterOptions.all,
                      ),
                      const PopupMenuItem(
                        child: Text('Log Out'),
                        value: FilterOptions.logout,
                      ),
                    ],
                  )
                ],
              ),
              body: ListView.builder(
                itemCount: passwords.length,
                itemBuilder: (ctx, i) => ChangeNotifierProvider<Password>.value(
                  value: passwords[i],
                  child: PasswordCard(),
                ),
              ),
            );
          }
          return const Text('loading...');
        });
  }
}
