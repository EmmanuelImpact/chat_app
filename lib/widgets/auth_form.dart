import '../widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;

  // ignore: use_key_in_widget_constructors
  const AuthForm(
    this.submitFn,
    this.isLoading,
  );

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // ignore: unused_field
  var _emailAddress = '';
  // ignore: unused_field
  var _userName = '';
  // ignore: unused_field
  var _password = '';

  var _isLogin = true;

  final _formKey = GlobalKey<FormState>();

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _emailAddress.trim(),
        _password.trim(),
        _userName.trim(),
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isLogin) const ImagePickerWidget(),
                    TextFormField(
                      key: const ValueKey('email'),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _emailAddress = value!;
                      },
                    ),
                    if (!_isLogin)
                      TextFormField(
                        key: const ValueKey('userName'),
                        validator: (value) {
                          if (value!.isEmpty || value.length < 4) {
                            return 'User name of nothing less than four characters is required.';
                          }
                          return null;
                        },
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        onSaved: (value) {
                          _userName = value!;
                        },
                      ),
                    TextFormField(
                      key: const ValueKey('password'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 7) {
                          return 'A password of at least 7 characters is required';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      onSaved: (value) {
                        _password = value!;
                      },
                    ),
                    const SizedBox(height: 12),
                    if (widget.isLoading) const CircularProgressIndicator(),
                    if (!widget.isLoading)
                      // ignore: deprecated_member_use
                      RaisedButton(
                        onPressed: _trySubmit,
                        child: _isLogin
                            ? const Text('LogIn')
                            : const Text('SignUp'),
                      ),
                    if (!widget.isLoading)
                      // ignore: deprecated_member_use
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        textColor: Theme.of(context).primaryColor,
                        child: Text(_isLogin
                            ? 'Create a new account.'
                            : 'I already have an account.'),
                      ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
