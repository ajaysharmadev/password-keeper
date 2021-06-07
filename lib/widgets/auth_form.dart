import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:password_keeper/widgets/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.isLoading, this.sumbitFn, this.isLoginForm);
  final bool isLoading;
  final bool isLoginForm;
  final void Function(String email, String password, bool isLoginForm,
      BuildContext ctx, File? image) sumbitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  //ImagePickingUploading
  File? _userImageFile;
  void _pickedImage(File image) {
    _userImageFile = image;
  }

  //AuthForm Builder
  FormGroup buildForm() => fb.group(<String, Object>{
        'email': FormControl<String>(
          validators: [Validators.required, Validators.email],
        ),
        'password': ['', Validators.required, Validators.minLength(8)],
        // 'rememberMe': false,
      });
  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.all(16),
      child: ReactiveFormBuilder(
        form: buildForm,
        builder: (context, form, child) {
          return Column(
            children: <Widget>[
              UserImagePicker(widget.isLoginForm, _pickedImage),
              ReactiveTextField<String>(
                formControlName: 'email',
                validationMessages: (control) => {
                  ValidationMessage.required: 'The email must not be empty',
                  ValidationMessage.email:
                      'The email value must be a valid email',
                  'unique': 'This email is already in use',
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  helperText: '',
                  helperStyle: TextStyle(height: 0.7),
                  errorStyle: TextStyle(height: 0.7),
                ),
              ),
              const SizedBox(height: 16.0),
              ReactiveTextField<String>(
                formControlName: 'password',
                obscureText: true,
                validationMessages: (control) => {
                  ValidationMessage.required: 'The password must not be empty',
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
              const SizedBox(height: 16.0),
              if (widget.isLoading) const CircularProgressIndicator(),
              if (!widget.isLoading)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity,
                          MediaQuery.of(context).size.height * 0.06)),
                  onPressed: () {
                    if (form.valid) {
                      if (_userImageFile == null && !widget.isLoginForm) {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Theme.of(context).errorColor,
                            content: const Text('Please pick an image.'),
                          ),
                        );
                        return;
                      }
                      Map signupData = form.value;
                      widget.sumbitFn(
                          signupData['email'],
                          signupData['password'],
                          widget.isLoginForm,
                          context,
                          _userImageFile);
                    } else {
                      form.markAllAsTouched();
                    }
                  },
                  child: widget.isLoginForm
                      ? const Text('Log In')
                      : const Text('Sign Up'),
                ),
              SizedBox(
                height: deviceHeight * 0.02,
              ),
              if (!widget.isLoading)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.pink,
                      minimumSize: Size(double.infinity, deviceHeight * 0.06)),
                  onPressed: () => form.resetState({
                    'email': ControlState<String>(value: null),
                    'password': ControlState<String>(value: null),
                  }, removeFocus: true),
                  child: const Text('Reset all'),
                ),
            ],
          );
        },
      ),
    );
  }
}
