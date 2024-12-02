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
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  void login() async {
    final authService = AuthService();

    try {
      await authService.signInWithEmailPassword(
        emailCtrl.text,
        passwordCtrl.text,
      );
    } catch (ex) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(ex.toString() +
              ' Inicio de sesion no habilitado, inicie sesion con google...'),
        ),
      );
    }
  }

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
                Icon(
                  MdiIcons.email,
                  color: Colors.grey,
                  size: 80,
                ),
                const SizedBox(height: 50),
                Text(
                  'Bienvenid@, ingrese sus datos.',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 25),
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
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      login();
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 56),
                      backgroundColor: const Color.fromARGB(255, 241, 92, 142),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
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
