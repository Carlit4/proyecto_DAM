import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class FsService {

  Stream<QuerySnapshot> recetas() {
    return FirebaseFirestore.instance.collection('recetas').snapshots();
  }

  Stream<DocumentSnapshot> recetaPorId(String id) {
    return FirebaseFirestore.instance.collection('recetas').doc(id).snapshots();  
  }


  Future<void> agregarReceta(String titulo, String? categoria, String calificacion, String tiempoCoccion, String imagen){
    return FirebaseFirestore.instance.collection('recetas').doc().set({
      'titulo': titulo,
      'categoria': categoria,
      'calificacion': calificacion,
      'tiempoCoccion': tiempoCoccion,
      'rutaImagen': imagen,
    });
  }

  Future<void> editarReceta(String recetaId, String titulo, String? categoria, String calificacion, String tiempoCoccion, String imagen){
    return FirebaseFirestore.instance.collection('recetas').doc(recetaId).set({
      'titulo': titulo,
      'categoria': categoria,
      'calificacion': calificacion,
      'tiempoCoccion': tiempoCoccion,
      'rutaImagen': imagen,
    });
  }

  Future<void> borrarReceta(String recetaId) {
    return FirebaseFirestore.instance.collection('recetas').doc(recetaId).delete();
  }

Future<String> guardarImagenLocalmente(File imagen) async {
  // Obtén el directorio de documentos de la app
  final Directory appDir = await getApplicationDocumentsDirectory();

  // Genera un nombre único para la imagen
  final String fileName = DateTime.now().millisecondsSinceEpoch.toString();

  // Copia la imagen en el directorio
  final File localImage = await imagen.copy('${appDir.path}/$fileName.jpg');

  // Devuelve la ruta local
  return localImage.path;
}

  Stream<QuerySnapshot> categorias(){
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  Future<String> obtenerNombrePorId(int id) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('categorias')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();
    return query.docs.first['nombre'];
  }

  Future<int> obtenerIdPorNombre(String categoria) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('categorias')
        .where('nombre', isEqualTo: categoria)
        .limit(1)
        .get();
    return query.docs.first['id'];
  }
  
}