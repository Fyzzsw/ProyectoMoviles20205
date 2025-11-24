import "package:flutter/material.dart";
import "package:proyecto_moviles_fernandoramirez2025/constantes.dart";
import "package:proyecto_moviles_fernandoramirez2025/services/auth_service.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/login.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundColor: Colores.kprimary,
                          child: Icon(Icons.event, color: Colores.kaccent, size: 35),
                        ),
                        SizedBox(height: 15),
                        Text(
                          "Eventos",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Colores.kprimary,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Publica y descubre eventos",
                          style: TextStyle(fontSize: 14, color: Colores.ksecondary),
                        ),
                        SizedBox(height: 20),
                        Divider(),
                        SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colores.kprimary,
                              backgroundColor: Colores.kbackground,
                              side: BorderSide(color: Colores.ksecondary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () async {
                              try {
                                await AuthService().signInWithGoogle();
                              } catch (ex) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("No se pudo iniciar sesión: $ex")),
                                );
                              }
                            },
                            icon: Icon(Icons.login_rounded, color: Colores.kprimary),
                            label: Text(
                              "Continuar con Google",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Usaremos tu cuenta de Gmail para ingresar",
                          style: TextStyle(fontSize: 15, color: Colores.ksecondary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
