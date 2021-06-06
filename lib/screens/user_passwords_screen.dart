import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_keeper/providers/password.dart';
import 'package:password_keeper/screens/add_edit_password.dart';
import 'package:password_keeper/widgets/password_card.dart';
import 'package:provider/provider.dart';
import 'package:password_keeper/providers/passwords.dart';

enum FilterOptions { favorites, all, add, logout }

class UserPasswordsScreen extends StatefulWidget {
  const UserPasswordsScreen({Key? key}) : super(key: key);

  @override
  State<UserPasswordsScreen> createState() => _UserPasswordsScreenState();
}

class _UserPasswordsScreenState extends State<UserPasswordsScreen> {
  var _showOnlyFavorites = false;
  @override
  Widget build(BuildContext context) {
    var passwords;

    
    if (_showOnlyFavorites) {
      passwords = Provider.of<Passwords>(context).favoriteItems;
    } else {
      passwords = Provider.of<Passwords>(context).items;
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0), //MediaQuery
        child: AppBar(
          leading: const Icon(Icons.account_box_rounded),
          title: const Text('Password Keeper'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(35), //MediaQuery
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: <Widget>[
            PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.favorites) {
                    _showOnlyFavorites = true;
                  } else if (selectedValue == FilterOptions.all) {
                    _showOnlyFavorites = false;
                  } else if (selectedValue == FilterOptions.logout) {
                    FirebaseAuth.instance.signOut();
                  } else if (selectedValue == FilterOptions.add) {
                    Navigator.of(context).pushNamed(AddEditScreen.routeName);
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
                const PopupMenuItem(
                  child: const Text('Add New Password'),
                  value: FilterOptions.add,
                )
              ],
            )
          ],
        ),
      ),
      body: ListView.builder(
          itemCount: passwords.length,
          itemBuilder: (ctx, i) => ChangeNotifierProvider<Password>.value(
                value: passwords[i],
                child: PasswordCard(),
              )),
    );
  }
}
