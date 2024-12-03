import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_cookly/services/fs_service.dart';
import 'package:flutter/material.dart';

class CategoriasAgregar extends StatefulWidget {
  const CategoriasAgregar({super.key});

  @override
  State<CategoriasAgregar> createState() => _CategoriasAgregarState();
}

class _CategoriasAgregarState extends State<CategoriasAgregar> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nombreCtrl = TextEditingController();

  String? nombreError;
  int? ultimoId = 0;

  Future<int> obtenerProximoId() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('categorias')
          .orderBy('id', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        int ultimoId = snapshot.docs.first['id'];
        return ultimoId + 1; 
      } else {

        return 1;
      }
    } catch (e) {
      print("Error al obtener el próximo ID: $e");
      return 1; 
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEB9D6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            Text('Agregar categoria',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextFormField(
                  validator: (titulo) {
                    if (titulo!.isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                  controller: nombreCtrl,
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Agregar categoria'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()){
                       ultimoId = await obtenerProximoId();
                       await FsService().agregarCategoria(ultimoId, nombreCtrl.text);
                       Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      )
      );
  }
}