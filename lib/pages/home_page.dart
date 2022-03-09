// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:teacher/providers/auth_provider.dart';

// class HomePage extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final data = ref.watch(firebaseAuthProvider);
//     final _auth = ref.watch(authServicesProvider);

//     return Scaffold(
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           // Text(
//           Text(data.currentUser!.email ?? 'You are logged In'),
//           // style: TextStyle(
//           //   fontSize: 24,

//           ElevatedButton(
//             onPressed: () => _auth.signout(),

//             style: ElevatedButton.styleFrom(
//               primary: Colors.purple,
//               padding: const EdgeInsets.all(18),
//               //padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
//             ),

//             child: const Text(
//               'Log out',
//               style: const TextStyle(fontWeight: FontWeight.w600),
//               //ButtonStyle: Style=textColor: Colors.blue.shade700,
//               // BorderSide(color: Colors.blue.shade700),
//             ),
//           ),
//           // MaterialButton(
//           //   onPressed: () => _auth.signout(),
//           //   child: Text('Sign-out'),
//           // ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teacher/providers/auth_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // first variable is to get the data of Authenticated User
    final data = ref.watch(firebaseAuthProvider);
    final _auth = ref.watch(authServicesProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data.currentUser!.email ?? 'You are logged In'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(data.currentUser!.displayName ?? ' home page'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 48.0),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _auth.userSignOut(),
                child: const Text(
                  'Log Out',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                // textColor: Colors.blue.shade700,
                // textTheme: ButtonTextTheme.primary,
                // minWidth: 100,
                // padding: const EdgeInsets.all(18),
                // shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(25),
                // side: BorderSide(color: Colors.blue.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
