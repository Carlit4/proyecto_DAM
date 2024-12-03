import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_cookly/Pages/categorias_editar.dart';
import 'package:dam_cookly/Pages/recetas_por_categoria.dart';
import 'package:dam_cookly/services/fs_service.dart';
import 'package:dam_cookly/widget/categorias_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoriasPage extends StatefulWidget {
  const CategoriasPage({super.key});

  @override
  State<CategoriasPage> createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  Future<dynamic> _confirmBorrado(BuildContext context, categoria) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Borrado'),
          content: Text('¿Desea borrar la categoría: ${categoria['nombre']}?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              child: Text('Aceptar'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: FsService().categorias(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var categoria = snapshot.data!.docs[index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _confirmBorrado(context, categoria).then((confirm) {
                            if (confirm) {
                              setState(() {
                                FsService().borrarCategoria(
                                    categoria.id); // Se usa 'id' directamente
                              });
                            }
                          });
                        },
                        icon: Icons.delete,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        label: 'Eliminar',
                      ),
                    ],
                  ),
                  startActionPane: ActionPane(
                    motion: ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoriasEditar(categoria: categoria),
                            ),
                          );
                        },
                        icon: Icons.edit,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        label: 'Editar',
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecetasPorCategoriaPage(
                            IdCategoria: categoria.id, // Pasa el 'id' correcto
                            NombreCategoria: categoria['nombre'],
                          ),
                        ),
                      );
                    },
                    child: CategoriasWidget(categoria: categoria),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
