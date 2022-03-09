import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:teacher/models/user_model.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;
  AuthenticationService(this._firebaseAuth);
  String? errorMessage;

  @override
  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  @override
  Future<void> userSignOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .catchError((e) {
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
        // print('Email already in use.');
      } else {
        // print('Error: $e');
      }
    }
    return null;
  }

  postDetailsToFirestore() async {
    // calling our firestore
    // calling our user model
    // sedning these values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _firebaseAuth.currentUser;

    UserModel userModel = UserModel();

    // writing all the values
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

  // postDetailsToFirestore() async {
  //   // calling our firestore
  //   // calling our user model
  //   // sedning these values

  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   User? user = _firebaseAuth.currentUser;

  //   UserModel userModel = UserModel();

  //   // writing all the values
  //   userModel.email = user!.email;
  //   userModel.uid = user.uid;
  //   userModel.fullName = "fullNameEditingController";

  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());

  //   Fluttertoast.showToast(
  //       msg: "Account created successfully.",
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.green,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  // // Future<void> signUp(String email, String password) async {
  //var _formKey;
  //if (_formKey.currentState!.validate()) {
  //try {
  //     await _firebaseAuth
  //         .createUserWithEmailAndPassword(email: email, password: password)
  //         .then((value) => {postDetailsToFirestore()})
  //         .catchError((e) {
  //       Fluttertoast.showToast(msg: e!.message);
  //     });
  //   } on FirebaseAuthException catch (error) {
  //     switch (error.code) {
  //       case "invalid-email":
  //         errorMessage = "Invalid Email.Please enter a valid Email.";
  //         break;
  //       case "wrong-password":
  //         errorMessage = "Password is wrong.";
  //         break;
  //       case "user-not-found":
  //         errorMessage = "User with this email doesn't exist.";
  //         break;
  //       case "user-disabled":
  //         errorMessage = "This email has been disabled.";
  //         break;
  //       case "too-many-requests":
  //         errorMessage = "Too many requests";
  //         break;
  //       case "operation-not-allowed":
  //         errorMessage = "Signing in with Email and Password is not enabled.";
  //         break;
  //       default:
  //         errorMessage = "An undefined Error happened.";
  //     }
  //     Fluttertoast.showToast(msg: errorMessage!);
  //     print(error.code);
  //   }
  // }

  // // postDetailsToFirestore() async {
  //   // calling our firestore
  //   // calling our user model
  //   // sending these values

  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   User? user = _firebaseAuth.currentUser;

  //   UserModel userModel = UserModel();

  //   // writing all the values
  //   userModel.email = user!.email;
  //   userModel.uid = user.uid;
  //   userModel.fullName = "fullNameEditingController";

  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());
  //   Fluttertoast.showToast(msg: 'from auth service ');

  //   //.whenComplete(() => _firebaseAuth.signInWithCredential);
  //   // Navigator.pushAndRemoveUntil((context),
  //   //     MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
  //   // Fluttertoast.showToast(msg: "Account created successfully :) ");
  // }

  //     MaterialPageRoute(builder: (context) => HomePage()), (route) => false);

  // Future<void> userSignOut() async {
  //   try {
  //     // _firebaseAuth.currentUser.toString();
  //     print(_firebaseAuth.currentUser);
  //     _firebaseAuth.signOut();
  //   } catch (e) {
  //     print(e.toString());
  //     print('asdafad');
  //   }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:teacher/models/user_model.dart';

// class Authentication {
//   // For Authentication related functions you need an instance of FirebaseAuth
//   FirebaseAuth _auth = FirebaseAuth.instance;

//   String? errorMessage;

//   //  This getter will be returning a Stream of User object.
//   //  It will be used to check if the user is logged in or not.
//   Stream<User?> get authStateChange => _auth.authStateChanges();

//   //String? errorMessage;

// // string for displaying the error Message
//   // String? errorMessage;

//   // Now This Class Contains 3 Functions currently
//   // 1. signInWithGoogle
//   // 2. signOut
//   // 3. signInwithEmailAndPassword

//   //  All these functions are async because this involves a future.
//   //  if async keyword is not used, it will throw an error.
//   //  to know more about futures, check out the documentation.
//   //  https://dart.dev/codelabs/async-await
//   //  Read this to know more about futures.
//   //  Trust me it will really clear all your concepts about futures

//   //  SigIn the user using Email and Password
//   Future<void> signInWithEmailAndPassword(
//       String email, String password, BuildContext context) async {
//     try {
//       await _auth
//           .signInWithEmailAndPassword(email: email, password: password)
//           .catchError((e) {
//         Fluttertoast.showToast(
//             msg: e!.message,
//             toastLength: Toast.LENGTH_LONG,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.red,
//             textColor: Colors.white,
//             fontSize: 16.0);
//       });
//     } on FirebaseAuthException catch (error) {
//       switch (error.code) {
//         case "invalid-email":
//           errorMessage = "Invalid Email.Please enter a valid Email.";
//           break;
//         case "wrong-password":
//           errorMessage = "Password is wrong.";
//           break;
//         case "user-not-found":
//           errorMessage = "User with this email doesn't exist.";
//           break;
//         case "user-disabled":
//           errorMessage = "This email has been disabled.";
//           break;
//         case "too-many-requests":
//           errorMessage = "Too many requests";

//           break;
//         case "operation-not-allowed":
//           errorMessage = "Signing in with Email and Password is not enabled.";
//           break;
//         default:
//           errorMessage = "An undefined Error happened.";
//       }

//       Fluttertoast.showToast(msg: errorMessage!);
//       print(error.code);
//     }
//   }

//   // SignUp the user using Email and Password

//   postDetailsToFirestore() async {
//     // calling our firestore
//     // calling our user model
//     // sedning these values

//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = _auth.currentUser;

//     UserModel userModel = UserModel();

//     // writing all the values
//     userModel.email = user!.email;
//     userModel.uid = user.uid;
//     //userModel.fullName = fullNameEditingController.text;

//     await firebaseFirestore
//         .collection("users")
//         .doc(user.uid)
//         .set(userModel.toMap());

//     Fluttertoast.showToast(
//         msg: "Account created successfully.",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.CENTER,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.green,
//         textColor: Colors.white,
//         fontSize: 16.0);

//     // Navigator.pushAndRemoveUntil(
//     //     (context),
//     //     MaterialPageRoute(builder: (context) => HomePage()),
//     //     (route) => false);
//   }

//   //     _auth.createUserWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //   } on FirebaseAuthException catch (e) {
//   //     await showDialog(
//   //         context: context,
//   //         builder: (ctx) => AlertDialog(
//   //                 title: Text('Error Occured'),
//   //                 content: Text(e.toString()),
//   //                 actions: [
//   //                   TextButton(
//   //                       onPressed: () {
//   //                         Navigator.of(ctx).pop();
//   //                       },
//   //                       child: Text("OK"))
//   //                 ]));
//   //   } catch (e) {
//   //     if (e == 'email-already-in-use') {
//   //       print('Email already in use.');
//   //     } else {
//   //       print('Error: $e');
//   //     }
//   //   }
//   // }

}
