import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:password_keeper/providers/password.dart';
import 'package:password_keeper/screens/add_edit_password.dart';
import 'package:password_keeper/widgets/password_card.dart';
import 'package:provider/provider.dart';
import 'package:password_keeper/providers/passwords.dart';

enum FilterOptions { favorites, all, logout }
// final FirebaseFirestore _firestore = FirebaseFirestore.instance;
// final CollectionReference _maincollectioin = _firestore.collection('users');
// Stream<DocumentSnapshot> readUsers() {
//   return _maincollectioin.doc(FirebaseAuth.instance.currentUser!.uid).snapshots();
// }

class UserPasswordsScreen extends StatefulWidget {
  const UserPasswordsScreen({Key? key}) : super(key: key);

  @override
  State<UserPasswordsScreen> createState() => _UserPasswordsScreenState();
}

class _UserPasswordsScreenState extends State<UserPasswordsScreen> {
  String profileImageUrl = '';

  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    var passwords;
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    if (_showOnlyFavorites) {
      passwords = Provider.of<Passwords>(context).favoriteItems;
    } else {
      passwords = Provider.of<Passwords>(context).items;
    }

    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Scaffold(
              appBar: AppBar(
                leading: Container(
                  padding: EdgeInsets.all(5),
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
                      icon: Icon(Icons.add)),
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
                        child: const Text('Log Out'),
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
          return Text('loading...');
        });
  }
}
