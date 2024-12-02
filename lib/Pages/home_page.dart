import 'package:dam_cookly/Pages/categorias_page.dart';
import 'package:dam_cookly/Pages/login_page.dart';
import 'package:dam_cookly/Pages/recetas_agregar.dart';
import 'package:dam_cookly/Pages/recetas_page.dart';
import 'package:dam_cookly/services/auth_service.dart';
import 'package:dam_cookly/widget/drawe_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  void logout() {
    final auth = AuthService();
    auth.signOut();
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List paginas = [RecetasPage(), CategoriasPage()];
  int paginaSeleccionada = 0;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  Future<void> _loadUserEmail() async {
    try {
      final user = await AuthService().currentUser();
      setState(() {
        userEmail = user?.email;
        isLoading = false;
      });
    } catch (e) {
      print("Error al cargar el usuario: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

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
            Text('COOKLY Martin y Goku',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RecetasAgregar()));
        },
      ),

      //DRAWER
      endDrawer: Drawer(
        backgroundColor: Color(0xFFFFFFFF),
        child: ListView(
          children: [
            DraweWidget(),
            FutureBuilder(
              future: AuthService().currentUser(),
              builder: (context, AsyncSnapshot<User?> snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return Row(
                    children: [
                      Padding(padding: const EdgeInsets.only(left: 16)),
                      Text(
                        'Cargando usuario...',
                        style: TextStyle(color: Colors.pink),
                      ),
                    ],
                  );
                }
                return Row(
                  children: [
                    Padding(padding: const EdgeInsets.only(left: 16)),
                    Text(
                      'Usuario: ' + snapshot.data!.email!,
                      style: TextStyle(
                          color: Colors.pink, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        MdiIcons.heart,
                        color: Colors.pink,
                      ),
                    )
                  ],
                );
              },
            ),
            Divider(),
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
            ListTile(
              trailing: TextButton(
                onPressed: () async {
                  try {
                    await AuthService().signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  } catch (e) {
                    print("Error al cerrar sesión: $e");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al cerrar sesión')),
                    );
                  }
                },
                child: Text('Cerrar sesión'),
              ),
            ),
          ],
        ),
      ),

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
