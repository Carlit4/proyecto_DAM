import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Instancia de FirebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Instancia de GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Obtener el usuario actual
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Mostrar correo del usuario actual
  Future<User?> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  // Iniciar sesión con correo y contraseña
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.code);
    }
  }

  // Registrar un nuevo usuario con correo y contraseña
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.code);
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      // Cerrar sesión en Firebase
      await _firebaseAuth.signOut();

      // Si hay una sesión activa en Google, cerrarla
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect(); // Opcional, para limpiar la caché
      }
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  // Iniciar sesión con Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Iniciar sesión interactivo con Google
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      // Cancelar si el usuario cierra la ventana
      if (gUser == null) return null;

      // Obtener datos de autenticación de Google
      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      // Crear credencial para Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // Iniciar sesión en Firebase
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print("Error de Firebase durante el inicio de sesión: ${e.message}");
      return null;
    } catch (e) {
      print("Error desconocido al iniciar sesión con Google: $e");
      return null;
    }
  }

  // Obtener mensaje de error legible
  String getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'Exception: wrong-password':
        return 'La contraseña es incorrecta, intente de nuevo.';
      case 'Exception: user-not-found':
        return 'No hay usuario con este correo, por favor registrese.';
      case 'Exception: invalid-email':
        return 'Este correo no es válido.';
      default:
        return 'Error desconocido, por favor vuelva más tarde.';
    }
  }
}
