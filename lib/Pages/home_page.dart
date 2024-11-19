import 'package:dam_cookly/Pages/categorias_page.dart';
import 'package:dam_cookly/Pages/recetas_agregar.dart';
import 'package:dam_cookly/Pages/recetas_page.dart';
import 'package:dam_cookly/widget/drawe_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List paginas = [RecetasPage(), CategoriasPage()];
  int paginaSeleccionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //APPBAR
      appBar: AppBar(
        backgroundColor: Color(0xFFFEB9D6),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu),
            Text('COOKLY Martin y goku',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => RecetasAgregar()));
        },
      ),

      //DAWER
      endDrawer: Drawer(
        backgroundColor: Color(0xFFFFFFFF),
        child: ListView(
          children: [
            DraweWidget(),
            ListTile(
              title: Text('Recetas'),
              onTap: () => _navegarDrawer(context, 0),
            ),
            Divider(),
            ListTile(
              title: Text('Categorias'),
              onTap: () => _navegarDrawer(context, 1),
            ),
            Divider(),
          ],
        ),
      ),

      //BODY
      body: paginas[paginaSeleccionada],
    );
  }

  void _cerrarDrawer(BuildContext context) {
    Navigator.pop(context);
  }

  void _navegarDrawer(BuildContext context, int pagina) {
    setState(() {
      paginaSeleccionada = pagina;
    });
    this._cerrarDrawer(context);
  }
}
