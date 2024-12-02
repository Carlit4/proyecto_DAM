import 'dart:io';

import 'package:dam_cookly/services/fs_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class RecetasAgregar extends StatefulWidget {
  const RecetasAgregar({super.key});

  @override
  State<RecetasAgregar> createState() => _RecetasAgregarState();
}

class _RecetasAgregarState extends State<RecetasAgregar> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController calificacionCtrl = TextEditingController();
  TextEditingController tiempoCoccionCtrl = TextEditingController();
  TextEditingController imagenCtrl = TextEditingController();
  int categoriaSeleccionada = 1;

  String categoria = "";
  File? imagenSeleccionada;

  String? tituloError;
  String? categoriaError;
  String? calificacionError;
  String? tiempoCoccionError;
  String? imagenError;

  Future<void> seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final File localImage = await File(image.path).copy('${appDir.path}/$fileName.jpg');

      setState(() {
        imagenSeleccionada = localImage;
      });
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
            Text('Agregar receta',
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

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Imagen'),
                  SizedBox(height: 10),
                  if (imagenSeleccionada != null)
                    Image.file(imagenSeleccionada!, height: 150, width: 150),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: seleccionarImagen,
                    child: Text('Seleccionar Imagen'),
                  ),
                ],
              ),

              Container(
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('Agregar receta'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()){
                       String? categoria = await FsService().obtenerNombrePorId(categoriaSeleccionada);
                       String imagenUrl = await FsService().guardarImagenLocalmente(imagenSeleccionada!);
                       await FsService().agregarReceta(tituloCtrl.text, categoria, calificacionCtrl.text, tiempoCoccionCtrl.text, imagenUrl);
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