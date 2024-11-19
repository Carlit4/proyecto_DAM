import 'package:dam_cookly/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:dam_cookly/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //controllers
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  //String msgError = '';

  //metodo login
  void login() async {
    //tener la instancia de auth_service
    final authService = AuthService();

    //metodo login
    try {
      await authService.signInWithEmailPassword(
        emailCtrl.text,
        passwordCtrl.text,
      );
    }
    //atrapar errores
    catch (ex) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(ex.toString()),
        ),
      );
    }
  }

  //contraseña olvidada
  void forgotPw() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('El usuario olvido la contraseña'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                //logo
                Icon(
                  MdiIcons.email,
                  color: Colors.grey,
                  size: 80,
                ),

                const SizedBox(height: 50),
                //mensaje de inicio
                Text(
                  'Bienvenid@, ingrese sus datos.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),

                const SizedBox(height: 25),
                //textfield de email

                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  child: TextField(
                    controller: emailCtrl,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(180, 180, 180, 180)),
                      hintText: 'usuario1@gmail.com',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                //textfield de contraseña

                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  child: TextField(
                    controller: passwordCtrl,
                    obscureText: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                //boton login
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 16), // Ajusta el valor según lo que necesites
                  child: ElevatedButton(
                    onPressed: () {
                      login(); // Llama a la función de inicio de sesión
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity,
                          56), // Tamaño del botón similar a TextField
                      backgroundColor: const Color.fromARGB(
                          255, 241, 92, 142), // Color de fondo del botón
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Bordes redondeados para coincidir con TextField
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18.0, // Tamaño de fuente para que sea legible
                        color: Colors.white, // Color del texto
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),
                // mensaje para registrarse
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No tienes cuenta?',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 196, 196, 196)),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      child: Text(
                        'Registrate!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 114, 114, 114),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 25),
                //boton inicio sesion de google
                ElevatedButton(
                  onPressed: () {
                    AuthService().signInWithGoogle();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                    );
                  },
                  child: const Text('Iniciar sesion con Google'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
