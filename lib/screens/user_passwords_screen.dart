import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:password_keeper/providers/password.dart';
import 'package:password_keeper/widgets/password_card.dart';
import 'package:provider/provider.dart';
import 'package:password_keeper/providers/passwords.dart';

enum FilterOptions { favorites, all, logout }

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

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0), //MediaQuery
        child: AppBar(
          leading: Icon(Icons.account_box_rounded),
          title: Text('Password Keeper'),
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
                  }
                });
              },
              icon: Icon(Icons.more_vert_rounded),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.favorites,
                ),
                PopupMenuItem(
                  child: Text('Show All'),
                  value: FilterOptions.all,
                ),
                PopupMenuItem(
                  child: Text('Log Out'),
                  value: FilterOptions.logout,
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
