import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<User?> currentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.code);
    }
  }

  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      throw Exception(ex.code);
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();

      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
        await _googleSignIn.disconnect();
      }
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();

      if (gUser == null) return null;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print("Error de Firebase durante el inicio de sesión: ${e.message}");
      return null;
    } catch (e) {
      print("Error desconocido al iniciar sesión con Google: $e");
      return null;
    }
  }

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
