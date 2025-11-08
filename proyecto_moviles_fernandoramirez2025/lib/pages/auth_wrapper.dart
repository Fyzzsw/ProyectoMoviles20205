import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:proyecto_moviles_fernandoramirez2025/pages/home.dart";
import "package:proyecto_moviles_fernandoramirez2025/pages/login.dart";

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return Login();
        }
      },
    );
  }
}
