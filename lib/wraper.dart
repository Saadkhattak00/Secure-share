import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './services/auth_services.dart';

import './screens/auth/login_screen.dart';
import './screens/home_screen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container();
  }
}

// StreamBuilder<User?>(
//       stream: authService.user,
//       builder: (context, AsyncSnapshot<User?> snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           final User? user = snapshot.data;
//           return user == null ? const LoginScreen() : HomeScreen();
//         } else {
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }
//       },
//     );