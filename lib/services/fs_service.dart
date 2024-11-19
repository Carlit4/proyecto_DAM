import 'package:cloud_firestore/cloud_firestore.dart';

class FsService {
  Stream<QuerySnapshot> recetas() {
    return FirebaseFirestore.instance.collection('recetas').snapshots();
  }
}