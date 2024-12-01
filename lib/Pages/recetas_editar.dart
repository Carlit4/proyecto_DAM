import 'package:dam_cookly/services/fs_service.dart';
import 'package:flutter/material.dart';

class RecetasEditar extends StatefulWidget {
  const RecetasEditar({super.key});

  @override
  State<RecetasEditar> createState() => _RecetasEditarState();
}

class _RecetasEditarState extends State<RecetasEditar> {
  final formKey = GlobalKey<FormState>();

  TextEditingController tituloCtrl = TextEditingController();
  TextEditingController categoriaCtrl = TextEditingController();
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
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: tituloCtrl,
                decoration: InputDecoration(
                  labelText: 'Titulo',
                  errorText: tituloError,
                ),
              ),
              StreamBuilder(
                stream: FsService().categorias(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Text('Cargando categoria...');
                  }
                  var categoria = snapshot.data!.docs;
                  return DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Categoria',
                      errorText: categoriaError,
                    ),
                    value: categoriaSeleccionada,
                    onChanged: (value) {
                      categoriaSeleccionada = value!;
                    },
                    items: categoria.map<DropdownMenuItem<int>>((categoria) {
                      return DropdownMenuItem<int>(
                        child: Text(categoria['nombre']),
                        value: categoria['id'],
                      );
                    }).toList(),
                  );
                },
              ),
              TextFormField(
                controller: calificacionCtrl,
                decoration: InputDecoration(
                  labelText: 'Calificacion',
                  errorText: calificacionError,
                ),
              ),
              TextFormField(
                controller: tiempoCoccionCtrl,
                decoration: InputDecoration(
                  labelText: 'Tiempo de coccion',
                  errorText: tiempoCoccionError,
                ),
              ),
              TextFormField(
                controller: imagenCtrl,
                decoration: InputDecoration(
                  labelText: 'Imagen',
                  errorText: tiempoCoccionError,
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
                       print("1234");
                       print(categoria);
                       await FsService().agregarReceta(tituloCtrl.text, categoria, calificacionCtrl.text, tiempoCoccionCtrl.text, imagenCtrl.text);
                    }
                    Navigator.pop(context);
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