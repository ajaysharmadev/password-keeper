import 'package:flutter/material.dart';
import 'package:password_keeper/providers/password.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:provider/provider.dart';
import '../providers/passwords.dart';
import 'package:uuid/uuid.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

var uuid = const Uuid();

class AddEditScreen extends StatelessWidget {
  AddEditScreen({Key? key}) : super(key: key);
  var isEditScreen = true;
  static const routeName = 'add-edit-screen';

  @override
  Widget build(BuildContext context) {
    final passwordId = ModalRoute.of(context)!.settings.arguments.toString();
    final passwordsData = Provider.of<Passwords>(context);
    final deviceHeight = MediaQuery.of(context).size.height;
    Password password;
    String email_username = '';
    String passwordValue = '';
    String title = '';
    String passwordType = '';
    if (passwordId == 'null') {
      isEditScreen = false;
    }
    if (isEditScreen) {
      password = Provider.of<Passwords>(context).findById(passwordId);
      email_username = password.email_username;
      passwordValue = password.password;
      title = password.title;
      passwordType = password.passwordType;
    }

    //Form Builder
    FormGroup buildForm() => fb.group(<String, Object>{
          'email_username': [
            email_username,
            Validators.required,
          ],
          'password': [
            passwordValue,
            Validators.required,
          ],
          'title': [
            title,
            Validators.required,
          ],
          'passwordType': [
            passwordType,
            Validators.required,
          ],
        });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Screen'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: ReactiveFormBuilder(
              builder: (context, form, child) {
                return Column(
                  children: <Widget>[
                    //Title Field
                    ReactiveTextField<String>(
                      formControlName: 'title',
                      obscureText: false,
                      validationMessages: (control) => {
                        ValidationMessage.required:
                            'The title must not be empty',
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        helperText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    //Email Field
                    ReactiveTextField<String>(
                      formControlName: 'email_username',
                      validationMessages: (control) => {
                        ValidationMessage.required:
                            'The email/username must not be empty',
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Email/Username',
                        helperText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    //Password Field

                    ReactiveTextField<String>(
                      formControlName: 'password',
                      obscureText: true,
                      validationMessages: (control) => {
                        ValidationMessage.required:
                            'The password must not be empty',
                        ValidationMessage.minLength:
                            'The password must be at least 8 characters',
                      },
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        helperText: '',
                        helperStyle: TextStyle(height: 0.7),
                        errorStyle: TextStyle(height: 0.7),
                      ),
                    ),
                    //PasswordType Field
                    ReactiveDropdownField<String>(
                      formControlName: 'passwordType',
                      hint: const Text('Select Password Type'),
                      // ignore: prefer_const_literals_to_create_immutables
                      items: [
                        const DropdownMenuItem(
                          child: Text('Others'),
                          value: 'others',
                        ),
                        const DropdownMenuItem(
                          child: Text('Facebook'),
                          value: 'Facebook',
                        ),
                        const DropdownMenuItem(
                          child: Text('Twitter'),
                          value: 'Twitter',
                        ),
                        const DropdownMenuItem(
                          child: Text('Reddit'),
                          value: 'Reddit',
                        ),
                        const DropdownMenuItem(
                          child: Text('Google'),
                          value: 'Google',
                        ),
                        const DropdownMenuItem(
                          child: Text('Github'),
                          value: 'Github',
                        ),
                        const DropdownMenuItem(
                          child: Text('Yahoo'),
                          value: 'Yahoo',
                        ),
                        const DropdownMenuItem(
                          child: Text('Apple'),
                          value: 'Apple',
                        )
                      ],
                    ),

                    //Buttons
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity,
                              MediaQuery.of(context).size.height * 0.06)),
                      onPressed: () {
                        if (form.valid) {
                          Map<String, dynamic> passwordData = form.value;

                          Password password = Password(
                              title: passwordData['title'].toString(),
                              email_username:
                                  passwordData['email_username'].toString(),
                              password: passwordData['password'].toString(),
                              passwordType:
                                  passwordData['passwordType'].toString(),
                              icon: passwordData['passwordType']
                                  .toString()
                                  .toLowerCase(),
                              id: uuid.v1().toString());

                          !isEditScreen
                              ? passwordsData.addPassword(password)
                              : passwordsData.updatePassword(
                                  passwordId, password);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.SUCCES,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Succes',
                            desc: isEditScreen
                                ? 'Your password has been updated.'
                                : 'New password has been added.',
                            btnOkOnPress: () {
                              Navigator.of(context).pop();
                            },
                          )..show();
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                      child: !isEditScreen
                          ? const Text('Add Password')
                          : const Text('Update Password'),
                    ),
                    SizedBox(
                      height: deviceHeight * 0.02,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.pink,
                          minimumSize:
                              Size(double.infinity, deviceHeight * 0.06)),
                      onPressed: () => form.resetState({
                        'email': ControlState<String>(value: null),
                        'password': ControlState<String>(value: null),
                        'title': ControlState<String>(value: null),
                        'passwordType': ControlState<String>(value: null),
                      }, removeFocus: true),
                      child: const Text('Reset all'),
                    ),
                    if (isEditScreen)
                      SizedBox(
                        height: deviceHeight * 0.02,
                      ),
                    if (isEditScreen)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                            minimumSize:
                                Size(double.infinity, deviceHeight * 0.06)),
                        onPressed: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.ERROR,
                            animType: AnimType.BOTTOMSLIDE,
                            title: 'Are You Sure?',
                            desc: 'This action can not be reversed.',
                            btnCancelOnPress: () {},
                            btnOkOnPress: () {
                              passwordsData.deletePassword(passwordId);
                              Navigator.of(context).pop();
                            },
                          )..show();
                        },
                        child: const Text('Delete'),
                      ),
                  ],
                );
              },
              form: buildForm),
        ),
      ),
    );
  }
}
