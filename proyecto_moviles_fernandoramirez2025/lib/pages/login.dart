import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:proyecto_moviles_fernandoramirez2025/services/auth_service.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  String msgError = "";

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
                    labelText: "Email",
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
                Column(
                  children: [
                    // Container(
                    //   padding: EdgeInsets.only(top: 10),
                    //   width: double.infinity,
                    //   child: FilledButton(
                    //     style: ButtonStyle(
                    //       backgroundColor: WidgetStatePropertyAll(Colors.red.shade900),
                    //     ),

                    //     onPressed: () async {
                    //       try {
                    //         await FirebaseAuth.instance.signInWithEmailAndPassword(
                    //           email: emailCtrl.text.trim(),
                    //           password: passCtrl.text.trim(),
                    //         );
                    //       } on FirebaseAuthException catch (ex) {
                    //         setState(() {
                    //           switch (ex.code) {
                    //             case "channel-error":
                    //               msgError = "Ingrese sus credenciales";
                    //               break;
                    //             case "invalid-email":
                    //               msgError = "Email no válido";
                    //               break;
                    //             case "invalid-credential":
                    //               msgError = "Credenciales no válidas";
                    //               break;
                    //             case "user-disabled":
                    //               msgError = "Usuario deshabilitado";
                    //               break;
                    //             case "too-many-requests":
                    //               msgError =
                    //                   "Demasiados intentos. Bloqueado temporalmente, espera y vuelve a intentar.";
                    //               break;
                    //             default:
                    //               msgError = "Error desconocido";
                    //           }
                    //         });
                    //       }
                    //     },
                    //     child: Text(
                    //       "Iniciar Sesión",
                    //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),

                    //boton de google
                    FilledButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red.shade900),
                      ),
                      onPressed: () async {
                        try {
                          final userCredential = await AuthService().signInWithGoogle();

                          if (userCredential != null) {}
                        } catch (ex) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error al iniciar sesión con Google: $ex")),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.login_rounded),
                          SizedBox(width: 8),
                          Text("Inicie sesion con google"),
                        ],
                      ),
                    ),
                  ],
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
