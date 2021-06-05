import 'package:flutter/material.dart';
import 'package:password_keeper/providers/passwords.dart';
import 'package:password_keeper/screens/view_password.dart';
import 'package:provider/provider.dart';
import '../providers/password.dart';
import 'package:password_keeper/providers/passwords.dart';

class PasswordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final password = Provider.of<Password>(context);
    final passwordsData = Provider.of<Passwords>(context);
    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      height: deviceHeight * 0.26,
      width: double.infinity,
      // color: Colors.black12,
      margin: EdgeInsets.all(20),
      child: Card(
        elevation: 5,
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
                        Chip(
                          label: Text(password.passwordType),
                        ),
                        ListTile(
                          title: Text(password.title),
                          subtitle: Text(password.email_username),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Divider(),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pushNamed(ViewScreen.routeName, arguments: password.id);
                    },
                    icon: const Icon(Icons.preview),
                    label: const Text('VIEW'),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.tight,
                  child: TextButton.icon(
                    onPressed: () {},
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

                      // passwordsData.toggelFavoriteStatus(widget.id);

                      // print(widget.isFavorite);
                      // print('button Pressed');
                    },
                    icon: password.isFavorite
                        ? const Icon(Icons.favorite)
                        : const Icon(Icons.favorite_border_outlined),
                    label: const Text('FAVOURITE'),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
