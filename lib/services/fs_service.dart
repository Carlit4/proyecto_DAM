import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  
  Stream<QuerySnapshot> recetas() {
    return FirebaseFirestore.instance.collection('recetas').snapshots();
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

  Stream<QuerySnapshot> categorias(){
    return FirebaseFirestore.instance.collection('categorias').snapshots();
  }

  Future<String?> obtenerNombrePorId(int id) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('categorias')
        .where('id', isEqualTo: id)
        .limit(1)
        .get();
    return query.docs.first['nombre'];
  }
  
}