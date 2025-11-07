import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<User?> currentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  //crear funcion para iniciar sesion con cuenta de google
}
