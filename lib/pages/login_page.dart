import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher/pages/registration_user.dart';
import 'package:teacher/providers/auth_provider.dart';
import 'package:teacher/providers/login_page_providers.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const routename = '/LoginPage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

final GlobalKey<FormState> _formKey = GlobalKey();

class LoginPageState extends ConsumerState<LoginPage> {
  void updateEmail(WidgetRef ref, String email) {
    ref.watch(emailProvider.state).state = email.toString().trim();
  }

  void updatePassword(WidgetRef ref, String pass) {
    ref.watch(passwordProvider.state).state = pass.toString().trim();
  }

  bool _isLoading = false;
  void loading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    // @override
    // Widget build(BuildContext context, WidgetRef ref) {

    final email = ref.watch(emailProvider.state).state;
    //final email = ref.watch(emailProvider);
    final pass = ref.watch(passwordProvider.state).state;
    final _auth = ref.watch(authServicesProvider);
    //final emailController = TextEditingController();
    // final passwordController = TextEditingController();
    Future<void> _onPressedFunction() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      loading();
      print(email.toString().trim());
      print(pass.toString().trim());

      await _auth
          .signIn(email.toString().trim(), pass.toString().trim())
          .whenComplete(() => _auth.authStateChange.listen((event) async {
                if (event == null) {
                  loading();
                  return;
                }
              }));
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.only(top: 48),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: FlutterLogo(size: 81)),
                      const Spacer(flex: 1),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: TextFormField(
                          //controller: _email,
                          autocorrect: true,
                          enableSuggestions: true,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => updateEmail(ref, value),

                          decoration: InputDecoration(
                            hintText: 'Email address',
                            hintStyle: const TextStyle(color: Colors.black54),
                            icon: Icon(Icons.email_outlined,
                                color: Colors.blue.shade700, size: 24),
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Invalid email!';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
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
                          //print('sdfsd'),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.black54),
                            icon: Icon(CupertinoIcons.lock_circle,
                                color: Colors.blue.shade700, size: 24),
                            alignLabelWithHint: true,
                            //border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.white),
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
                                onPressed: _onPressedFunction,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.purple,
                                  padding: const EdgeInsets.all(18),
                                  //side: BorderSide.none,
                                  shape: RoundedRectangleBorder(),
                                  // padding: const EdgeInsets.symmetric(
                                  //     horizontal: 50, vertical: 20),
                                ),
                                child: const Text(
                                  'Log in',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),

                                  //ButtonStyle: Style=textColor: Colors.blue.shade700,
                                  // BorderSide(color: Colors.blue.shade700),
                                ),
                                //
                                // textTheme: ButtonTextTheme.primary,
                                // minWidth: 100,
                                //  padding: const EdgeInsets.all(18),
                                //  shape: RoundedRectangleBorder(
                              ),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushAndRemoveUntil(
                            (context),
                            MaterialPageRoute(
                                builder: (context) => RegisterUserPage()),
                            (route) => false),
                        //  Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => RegisterUserPage(),),), // {
                        //  Navigator.push(
                        //     context, MaterialPageRoute(builder: (context) => RegisterUserPage()));
                        //}
                        child: Text('new user'),
                      )

                      //),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
