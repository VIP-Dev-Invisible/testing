import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher/pages/home_page.dart';
import 'package:teacher/providers/auth_provider.dart';
import 'package:teacher/providers/login_page_providers.dart';

class RegisterUserPage extends ConsumerStatefulWidget {
  const RegisterUserPage({Key? key}) : super(key: key);

  @override
  RegisterUserPageState createState() => RegisterUserPageState();
}

String? errorMessage;

final _formKey = GlobalKey<FormState>();

class RegisterUserPageState extends ConsumerState<RegisterUserPage> {
  void updateEmail(WidgetRef ref, String emailNewUser) {
    ref.watch(emailProvider.state).state = emailNewUser.toString().trim();
  }

  void updatePassword(WidgetRef ref, String passwordNewUser) {
    ref.watch(passwordProvider.state).state = passwordNewUser.toString().trim();
  }

  bool _isLoading = false;
  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _authFirebase = ref.watch(authServicesProvider);
    final emailNewUser = ref.watch(emailProvider.state).state;
    final passwordNewUser = ref.watch(passwordProvider.state).state;

    Future<void> _onPressedFunction() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      loading();

      await _authFirebase
          .userSignUp(emailNewUser.toString().trim(),
              passwordNewUser.toString().trim(), context)
          .whenComplete(
              () => _authFirebase.authStateChange.listen((event) async {
                    if (event == null) {
                      print(emailNewUser.toString().trim());

                      loading();
                      return;
                    } //       MaterialPageRoute(builder: (context) => HomePage()),

                    else {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false);
                    }
                  }));
    }

    //** SignUpButton Material button

    // final signUpButton = Material(
    //   elevation: 5,
    //   borderRadius: BorderRadius.circular(30),
    //   color: Colors.green,
    //   child: MaterialButton(
    //       padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    //       minWidth: MediaQuery.of(context).size.width,
    //       onPressed: () {
    //         _onPressedFunction();
    //       },
    //       child: Text(
    //         "SIGN UP",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //             // fontSize: 18,
    //             color: Colors.white,
    //             fontWeight: FontWeight.bold),
    //       )),
    // );

    //* * SignUpButton ended

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Column(
            children: [
              const Center(child: FlutterLogo(size: 81)),
              const Spacer(),
              SizedBox(
                width: 350,
                height: 70,
                child: TextFormField(
                  autocorrect: true,
                  enableSuggestions: true,
                  keyboardType: TextInputType.name,
                  onChanged: (value) => updateEmail(ref, value),
                  textInputAction: TextInputAction.next,

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                    //contentPadding:  const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter your Name.",
                    labelText: "Name",

                    // hintStyle: const TextStyle(color: Colors.black54),

                    // border: InputBorder.none,
                    //alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  // decoration: InputDecoration(
                  //   hintStyle: const TextStyle(color: Colors.black54),
                  //   icon:
                  //       Icon(Icons.boy, color: Colors.blue.shade700, size: 24),
                  // alignLabelWithHint: true,
                  // border: InputBorder.none,
                  // ),
                  validator: (value) {
                    RegExp regex = RegExp(r'^.{3,}$');
                    if (value!.isEmpty) {
                      return ("Name cannot be Empty.");
                    }
                    if (!regex.hasMatch(value)) {
                      return ("Enter Valid name.(Min. 3 Character)");
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // fullNameEditingController.text = value!;
                  },
                ),
              ),

              SizedBox(
                width: 350,
                height: 70,
                child: TextFormField(
                  //controller: _email,
                  autocorrect: true,
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) => updateEmail(ref, value),

                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    hintText: "Enter your Email.",
                    labelText: "Email",
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.email_outlined,
                        color: Colors.blue.shade700, size: 24),
                    //alignLabelWithHint: true,
                    // border: InputBorder.none,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(
                width: 350,
                height: 70,
                child: TextFormField(
                  //controller: _password,

                  //

                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password is too short!Min 6 Charachter';
                    }
                    return null;
                  },
                  onChanged: (value) => updatePassword(ref, value),
                  //print(value),
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    hintText: 'Enter Password',
                    labelText: 'Password',
                    hintStyle: const TextStyle(color: Colors.black54),
                    prefixIcon: Icon(Icons.vpn_key,
                        color: Colors.blue.shade700, size: 24),
                    //alignLabelWithHint: true,
                    //border: InputBorder.none,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 2,
              // ),
              SizedBox(
                width: 350,
                height: 70,
                child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      labelText: 'Password',
                      hintText: 'Retype password',
                      hintStyle: const TextStyle(color: Colors.black54),
                      prefixIcon: Icon(CupertinoIcons.lock_circle,
                          color: Colors.blue.shade700, size: 24),
                      // alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    validator: (value) {
                      if (value != passwordNewUser) {
                        return 'Passwords does\'t match!';
                      }
                      return null;
                    }),
              ),
              const Spacer(),
              Flexible(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.redAccent),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(top: 32.0),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        width: double.infinity,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                child: const Text('Sign Up'),
                                onPressed: _onPressedFunction,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.purple,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 50, vertical: 20),
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 2),
                                )

                                //     ? const Center(child: CircularProgressIndicator())
                                //     : ElevatedButton(
                                //         onPressed: _onPressedFunction,
                                //         style: ElevatedButton.styleFrom(
                                //           primary: Colors.purple,
                                //           //padding: const EdgeInsets.all(18),
                                //           //side: BorderSide.none,
                                //           shape: RoundedRectangleBorder(),
                                //           padding: const EdgeInsets.symmetric(horizontal: 20),
                                //         ),
                                //         child: const Text(
                                //           'Log in',
                                //           style: const TextStyle(fontWeight: FontWeight.w600),

                                ),
                      ),
                    ],
                  ),
                  //),
                ),
              ),
            ],
          ),
        ),
      ),
    );

//   void signUp(String email, String password) async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await _auth
//             .createUserWithEmailAndPassword(email: email, password: password)
//             .then((value) => {postDetailsToFirestore()})
//             .catchError((e) {
//           Fluttertoast.showToast(msg: e!.message);
//         });
//       } on FirebaseAuthException catch (error) {
//         switch (error.code) {
//           case "invalid-email":
//             errorMessage = "Invalid Email.Please enter a valid Email.";
//             break;
//           case "wrong-password":
//             errorMessage = "Password is wrong.";
//             break;
//           case "user-not-found":
//             errorMessage = "User with this email doesn't exist.";
//             break;
//           case "user-disabled":
//             errorMessage = "This email has been disabled.";
//             break;
//           case "too-many-requests":
//             errorMessage = "Too many requests";
//             break;
//           case "operation-not-allowed":
//             errorMessage = "Signing in with Email and Password is not enabled.";
//             break;
//           default:
//             errorMessage = "An undefined Error happened.";
//         }
//         Fluttertoast.showToast(msg: errorMessage!);
//         print(error.code);
//       }
//     }
//   }

//   postDetailsToFirestore() async {

//     FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//     User? user = _auth.currentUser;

//     UserModel userModel = UserModel();

//     userModel.email = user!.email;
//     userModel.uid = user.uid;
//     userModel.fullName = fullNameEditingController.text;

//     await firebaseFirestore
//         .collection("users")
//         .doc(user.uid)
//         .set(userModel.toMap());
//     Fluttertoast.showToast(msg: "Account created successfully :) ");

//     Navigator.pushAndRemoveUntil(
//         (context),
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//         (route) => false);
//   }
// }
  }

  // Future<void> signUpUser(String email, String password) async {
  //   if (_formKey.currentState!.validate()) {
  //     try {
  //       await _firebaseAuth
  //           .createUserWithEmailAndPassword(email: email, password: password)
  //           .then((value) => {postDetailsToFirestore()})
  //           .catchError((e) {
  //         Fluttertoast.showToast(msg: e!.message);
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
  // }

  // postDetailsToFirestore() async {

  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   User? user = _firebaseAuth.currentUser;

  //   UserModel userModel = UserModel();

  //   userModel.email = user!.email;
  //   userModel.uid = user.uid;
  //   userModel.fullName = "fullNameEditingController";

  //   await firebaseFirestore
  //       .collection("users")
  //       .doc(user.uid)
  //       .set(userModel.toMap());
  //   Fluttertoast.showToast(msg: 'done done done done');

  // }

}
