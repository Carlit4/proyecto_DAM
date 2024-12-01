import 'package:cloud_firestore/cloud_firestore.dart';

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