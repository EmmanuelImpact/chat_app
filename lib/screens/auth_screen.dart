import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(
    File image,
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) async {
    // ignore: unused_local_variable
    UserCredential userCredential;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredential.user!.uid}.jpg');

        await ref.putFile(image);
        final url = await ref.getDownloadURL();

        FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': userName,
          'email': email,
          'image_url': url,
        });
      }
    } on PlatformException catch (error) {
      var message = 'An error occured. Please check your credentials.';

      if (error.message != null) {
        message = error.message!;
      }
      // ignore: deprecated_member_use
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      //print(error);
      var message = 'An error occured. Please check your credentials.';
      if (error.toString().contains('firebase_auth/email-already-in-use')) {
        message = 'Email address already exists.';
      } else if (error.toString().contains('firebase_auth/user-not-found')) {
        message = 'Unauthenticated email, please sign up.';
      } else if (error.toString().contains('firebase_auth/invalid-email]')) {
        message = 'Invalid email address.';
      }
      // ignore: deprecated_member_use
      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
