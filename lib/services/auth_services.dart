import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teacher/models/user_model.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);
  String? errorMessage;

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  Future<void> userSignOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    try {
      print(email.toString().trim());

      await _firebaseAuth
          .signInWithEmailAndPassword(
              email: email.toString().trim(),
              password: password.toString().trim())
          .catchError((e) {
        print(email.toString().trim());

        Fluttertoast.showToast(
            msg: "Check your credential",
            // msg: e!.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      });
    } on FirebaseAuthException catch (error) {
      switch (error.code) {
        case "invalid-email":
          errorMessage = "Invalid Email.Please enter a valid Email.";
          break;
        case "wrong-password":
          errorMessage = "Password is wrong.";
          break;
        case "user-not-found":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "user-disabled":
          errorMessage = "This email has been disabled.";
          break;
        case "too-many-requests":
          errorMessage = "Too many requests";

          break;
        case "operation-not-allowed":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }

      Fluttertoast.showToast(msg: errorMessage!);
      print(error.code);
    }
  }

  Future<void> userSignUp(
      String email, String password, BuildContext context) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(
              email: email.toString().trim(),
              password: password.toString().trim())
          .then((value) => {postDetailsToFirestore()});
    } on FirebaseAuthException catch (e) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: const Text('Error Occured'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("OK"))
                  ]));
    } catch (e) {
      if (e == 'email-already-in-use') {
        print('Email already in use.');
      } else {
        print('Error: $e');
      }
    }
    return null;
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _firebaseAuth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email.toString().trim();
    userModel.uid = user.uid;
    userModel.fullName = 'fullNameEditingController'.toString().trim();

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    Fluttertoast.showToast(
        msg: "Account created successfully.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  // SignUp the user using Email and Password
  Future<void> signUpWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()});

      print('i m inside create user function');
    } on FirebaseAuthException catch (e) {
      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                  title: const Text('Error Occured'),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text("OK"))
                  ]));
    } catch (e) {
      if (e == 'email-already-in-use') {
        print('Email already in use.');
      } else {
        print('Error: $e');
      }
    }
  }
}
