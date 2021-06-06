import 'package:flutter/material.dart';
import 'package:password_keeper/providers/password.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:provider/provider.dart';
import '../providers/passwords.dart';
import 'package:uuid/uuid.dart';

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
                      hint: Text('Select Password Type'),
                      items: [
                        DropdownMenuItem(
                          child: Text('Others'),
                          value: 'others',
                        ),
                        DropdownMenuItem(
                          child: Text('Facebook'),
                          value: 'Facebook',
                        ),
                        DropdownMenuItem(
                          child: Text('Twitter'),
                          value: 'Twitter',
                        ),
                        DropdownMenuItem(
                          child: Text('Reddit'),
                          value: 'Reddit',
                        ),
                        DropdownMenuItem(
                          child: Text('Google'),
                          value: 'Google',
                        ),
                        DropdownMenuItem(
                          child: Text('Github'),
                          value: 'Github',
                        ),
                        DropdownMenuItem(
                          child: Text('Yahoo'),
                          value: 'Yahoo',
                        ),
                        DropdownMenuItem(
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

                          Navigator.of(context).pop();
                        } else {
                          form.markAllAsTouched();
                        }
                      },
                      child: !isEditScreen
                          ? const Text('Add Product')
                          : const Text('Update Product'),
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
                  ],
                );
              },
              form: buildForm),
        ),
      ),
    );
  }
}
