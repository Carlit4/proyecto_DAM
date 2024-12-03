import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_cookly/widget/recetas_widget.dart';
import 'package:flutter/material.dart';

class RecetasPorCategoriaPage extends StatelessWidget {
  final String IdCategoria;
  final String NombreCategoria;

  RecetasPorCategoriaPage({
    required this.IdCategoria,
    required this.NombreCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recetas: $NombreCategoria"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('recetas')
            .where('categoria',
                isEqualTo:
                    NombreCategoria) // Asegúrate de que el campo sea 'IdCategoria'
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No hay recetas para esta categoría."),
            );
          }

          final recetas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              final receta = recetas[index];
              return RecetasWidget(receta: receta);
            },
          );
        },
      ),
    );
  }
}
