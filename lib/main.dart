// // // ignore_for_file: prefer_const_constructors

// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter_riverpod/flutter_riverpod.dart';
// // import 'package:teacher/home_page.dart';
// // import 'package:teacher/providers/auth_providers.dart';
// // import 'package:teacher/screens/home_screen.dart';
// // import 'package:teacher/screens/login_page.dart';
// // import 'package:teacher/screens/login_screen.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';

// // void main() {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   runApp(ProviderScope(child: MyApp()));
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({Key? key}) : super(key: key);

// //   // This widget is the root of your application.
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       title: 'Flutter Demo',
// //       theme: ThemeData(
// //         primarySwatch: Colors.blue,
// //         fontFamily: GoogleFonts.notoSans().fontFamily,
// //         //fontFamily: 'Montserrat-Regular',
// //       ),
// //       home: StartPage(),
// //     );
// //   }
// // }

// // class StartPage extends StatelessWidget {
// //   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
// //   @override
// //   Widget build(BuildContext context) {
// //     return FutureBuilder(
// //       future: _initialization,
// //       builder: (context, snapshot) {
// //         if (snapshot.hasError) {
// //           return Center(
// //             child: Text("Something Went wrong"),
// //           );
// //         }
// //         if (snapshot.connectionState == ConnectionState.done) {
// //           return AuthChecker();
// //         }
// //         //loading
// //         return Scaffold(
// //           body: Center(
// //             child: CircularProgressIndicator(),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// // class AuthChecker extends ConsumerWidget {
// //   @override
// //   Widget build(BuildContext context, WidgetRef ref) {
// //     final _authState = ref.watch(authStateProvider);
// //     return _authState.when(
// //       data: (value) {
// //         if (value != null) {
// //           return DearMyHomePage();
// //         }
// //         return MyLoginPage();
// //       },
// //       loading: () {
// //         return Scaffold(
// //           body: Center(
// //             child: CircularProgressIndicator(),
// //           ),
// //         );
// //       },
// //       error: (_, __) {
// //         return Scaffold(
// //           body: Center(
// //             child: Text("OOPS"),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:teacher/home_page.dart';
// import 'package:teacher/providers/auth_providers.dart';
// import 'package:teacher/screens/login_page.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(ProviderScope(child: MyApp()));
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: StartPage(),
//     );
//   }
// }

// class StartPage extends StatelessWidget {
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _initialization,
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           return Center(
//             child: Text("Something Went wrong"),
//           );
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           return AuthChecker();
//         }
//         //loading
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//     );
//   }
// }

// class AuthChecker extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final _authState = ref.watch(authStateProvider);
//     return _authState.when(
//       data: (value) {
//         if (value != null) {
//           return DearMyHomePage();
//         }
//         return MyLoginPage();
//       },
//       loading: () {
//         return Scaffold(
//           body: Center(
//             child: CircularProgressIndicator(),
//           ),
//         );
//       },
//       error: (_, __) {
//         return Scaffold(
//           body: Center(
//             child: Text("OOPS"),
//           ),
//         );
//       },
//     );
//   }
// }

//* march 6 ko morning

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:teacher/pages/loading_screen.dart';
// import 'package:teacher/services/auth_checker.dart';
// import 'Pages/error_screen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const ProviderScope(child: MyApp()));
// }

// //  This is a FutureProvider that will be used to check whether the firebase has been initialized or not
// final firebaseinitializerProvider = FutureProvider<FirebaseApp>((ref) async {
//   return await Firebase.initializeApp();
// });

// class MyApp extends ConsumerWidget {
//   const MyApp({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     //  We will watch this provider to see if the firebase has been initialized
//     //  As said this gives async value so it can gives 3 types of results
//     //  1. The result is a Future<FirebaseApp>
//     //  2. The result is a Future<Error>
//     //  3. It's still loading

//     final initialize = ref.watch(firebaseinitializerProvider);
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,

//       //  We will use the initialize to check if the firebase has been initialized
//       //  .when function can only be used with AsysncValue. If you hover over intialize
//       //  you can see what type of variable it is. I have left it dynamic here for your better understanding
//       //  Though it's always recommended to not to use dynamic variables.

//       // Now here if the Firebase is initialized we will be redirected to AuthChecker
//       // which checks if the user is logged in or not.

//       //  the other Two functions speaks for themselves.
//       home: initialize.when(
//           data: (data) {
//             return const AuthChecker();
//           },
//           loading: () => const LoadingScreen(),
//           error: (e, stackTrace) => ErrorScreen(e, stackTrace)),
//     );
//   }
// }
//* march 6 ko morning

//* march 6 ko next test
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher/pages/home_page.dart';
import 'package:teacher/pages/login_page.dart';
import 'package:teacher/providers/auth_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // home: RegisterUserPage(),
      home: StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something Went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthChecker();
          //RegisterUserPage();
        }
        //loading
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

class AuthChecker extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
      data: (value) {
        if (value != null) {
          return HomePage();
        }
        return LoginPage();
      },
      loading: () {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      error: (_, __) {
        return Scaffold(
          body: Center(
            child: Text("OOPS"),
          ),
        );
      },
    );
  }
}
