import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_cookly/services/fs_service.dart';
import 'package:flutter/material.dart';

class CategoriasEditar extends StatefulWidget {
  const CategoriasEditar({super.key, required this.categoria});
  final categoria;

  @override
  State<CategoriasEditar> createState() => _CategoriasEditarState();
}

class _CategoriasEditarState extends State<CategoriasEditar> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nombreCtrl = TextEditingController();

  String? nombreError;
  int? ultimoId = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEB9D6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            Text('Editar categoria',
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
                  child: Text('Editar categoria'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()){
                       await FsService().editarCategoria(widget.categoria.id, nombreCtrl.text);
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