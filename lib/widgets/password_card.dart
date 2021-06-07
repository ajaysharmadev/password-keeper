import 'package:flutter/material.dart';
import 'package:password_keeper/providers/passwords.dart';
import 'package:password_keeper/screens/add_edit_password.dart';
import 'package:password_keeper/screens/view_password.dart';
import 'package:provider/provider.dart';
import '../providers/password.dart';

class PasswordCard extends StatefulWidget {
  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  @override
  Widget build(BuildContext context) {
    final password = Provider.of<Password>(context);
    final passwordsData = Provider.of<Passwords>(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight * 0.3,
      width: double.infinity,
      // color: Colors.black12,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SingleChildScrollView(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: CircleAvatar(
                        radius: 50,
                        child: iconsMap[password.icon],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              tileColor: Theme.of(context).primaryColor,
                              title: Text(
                                password.passwordType,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text(
                              password.title,
                            ),
                            subtitle: Text(password.email_username),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              Row(
                children: [
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(ViewScreen.routeName,
                            arguments: password.id);
                      },
                      icon: const Icon(Icons.preview),
                      label: const Text('VIEW'),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.of(context).pushNamed(AddEditScreen.routeName,
                            arguments: password.id);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('EDIT'),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.tight,
                    child: TextButton.icon(
                      onPressed: () {
                        password.toggleFavoriteStatus();
                        final snackBar = SnackBar(
                          duration: Duration(milliseconds: 500),
                          content: password.isFavorite
                              ? Text('Added as favorite.')
                              : const Text('Removed from favorites.'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: password.isFavorite
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_border_outlined),
                      label: const Text('FAVORITE'),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
