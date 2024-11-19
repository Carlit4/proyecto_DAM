import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  //instancia de auth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //obtener usuario;
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  //mostrar correo
  Future<User?> currentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  //inicio sesion de email
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      //iniciar sesion correo
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.code);
    }
  }

  //registrar un email
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      //crear usuario
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.code);
    }
  }

  //cerrar sesion
  Future<void> signOut() async {
    // Cerrar sesión en Firebase
    await FirebaseAuth.instance.signOut();

    // Cerrar sesión en Google
    await GoogleSignIn().signOut();

    // Limpiar caché de Google (opcional)
    await GoogleSignIn().disconnect();
  }

  //cerrar sesion con google

  //iniciar sesion con google
  signInWithGoogle() async {
    //inicio sesion interactivo
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    //cancelar inicio sesion en ventana google
    if (gUser == null) return;

    //obtener datos de autenticacion
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    //crear nueva credencial de usuario
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    //inicio de sesion exitoso
    return await _firebaseAuth.signInWithCredential(credential);
  }

  //errores posibles
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'Exception: wrong-password':
        return 'La contraseña es incorrecta, intente de nuevo.';
        break;
      case 'Exception: user-not-found':
        return 'No hay usuario con este correo, porfavor registrese.';
        break;
      case 'Exception: invalid-email':
        return 'Este correo no existe.';
        break;
      default:
        return 'Error desconocido, porfavor vuelva mas tarde.';
        break;
    }
  }
}
