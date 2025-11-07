import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  String msgError = '';

  @override
  void dispose() {
    emailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade100,
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.red.shade100, Colors.red.shade900],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(60),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                TextFormField(
                  controller: passCtrl,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: FilledButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red.shade900),
                    ),

                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: emailCtrl.text.trim(),
                          password: passCtrl.text.trim(),
                        );
                      } on FirebaseAuthException catch (ex) {
                        setState(() {
                          switch (ex.code) {
                            case 'channel-error':
                              msgError = 'Ingrese sus credenciales';
                              break;
                            case 'invalid-email':
                              msgError = 'Email no válido';
                              break;
                            case 'invalid-credential':
                              msgError = 'Credenciales no válidas';
                              break;
                            case 'user-disabled':
                              msgError = 'Usuario deshabilitado';
                              break;
                            case 'too-many-requests':
                              msgError =
                                  'Demasiados intentos. Bloqueado temporalmente, espera y vuelve a intentar.';
                              break;
                            default:
                              msgError = 'Error desconocido';
                          }
                        });
                      }
                    },
                    child: Text(
                      'Iniciar Sesión',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text(msgError, style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
