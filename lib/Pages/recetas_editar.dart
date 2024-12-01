import 'package:dam_cookly/services/fs_service.dart';
import 'package:flutter/material.dart';

class RecetasEditar extends StatefulWidget {
  const RecetasEditar({super.key, required this.recetaId});
  final String recetaId;

  @override
  State<RecetasEditar> createState() => _RecetasEditarState();
}

class _RecetasEditarState extends State<RecetasEditar> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController calificacionCtrl = TextEditingController();
  TextEditingController tiempoCoccionCtrl = TextEditingController();
  TextEditingController imagenCtrl = TextEditingController();
  int categoriaSeleccionada = 1;

  String categoria = "";

  String? tituloError;
  String? categoriaError;
  String? calificacionError;
  String? tiempoCoccionError;
  String? imagenError;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFEB9D6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            Text('Agregar receta',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
            stream: FsService().recetaPorId(widget.recetaId),
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Colors.white));
              }
              var receta = snapshot.data;

              tituloCtrl.text = receta['titulo'];
              calificacionCtrl.text = receta['calificacion'];
              tiempoCoccionCtrl.text = receta['tiempoCoccion'];
              imagenCtrl.text = receta['rutaImagen'];
              return FutureBuilder<int>(
                future: FsService().obtenerIdPorNombre(receta['categoria']),
                builder: (context, AsyncSnapshot<int> snapshot2) {
                    if (!snapshot2.hasData || snapshot2.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    categoriaSeleccionada = snapshot2.data!;
                    return Form(
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
                                  return 'El título es requerido';
                                }
                                return null;
                              },
                              controller: tituloCtrl,
                              decoration: InputDecoration(
                                labelText: 'Título',
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: StreamBuilder(
                              stream: FsService().categorias(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                                  return Text('Cargando categorías...');
                                }
                                var categorias = snapshot.data!.docs;
                                return DropdownButtonFormField<int>(
                                  decoration: InputDecoration(
                                    labelText: 'Categoría',
                                  ),
                                  value: categoriaSeleccionada,
                                  onChanged: (value) {
                                    categoriaSeleccionada = value!;
                                  },
                                  items: categorias.map<DropdownMenuItem<int>>((categoria) {
                                    return DropdownMenuItem<int>(
                                      child: Text(categoria['nombre']),
                                      value: categoria['id'],
                                    );
                                  }).toList(),
                                );
                              },
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              validator: (calificacion) {
                                if (calificacion!.isEmpty) {
                                  return 'La calificación es requerida';
                                }
                                if (double.tryParse(calificacion) == null) {
                                  return 'La calificación debe ser un número';
                                }
                                return null;
                              },
                              controller: calificacionCtrl,
                              decoration: InputDecoration(
                                labelText: 'Calificación',
                              ),
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              validator: (tiempoCoccion) {
                                if (tiempoCoccion!.isEmpty) {
                                  return 'El tiempo de cocción es requerido';
                                }
                                return null;
                              },
                              controller: tiempoCoccionCtrl,
                              decoration: InputDecoration(
                                labelText: 'Tiempo de Cocción',
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: TextFormField(
                              validator: (imagen) {
                                if (imagen!.isEmpty) {
                                  return 'La imagen es requerida';
                                }
                                return null;
                              },
                              controller: imagenCtrl,
                              decoration: InputDecoration(
                                labelText: 'URL de la Imagen',
                              ),
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 20),
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text('Agregar receta'),
                              onPressed: () async {
                                if (formKey.currentState!.validate()){
                                  String? categoria = await FsService().obtenerNombrePorId(categoriaSeleccionada);
                                  await FsService().agregarReceta(tituloCtrl.text, categoria, calificacionCtrl.text, tiempoCoccionCtrl.text, imagenCtrl.text);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                   );
                }
              );
            }
          )
        )
      );
   }
} 