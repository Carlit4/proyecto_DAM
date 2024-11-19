import 'package:flutter/material.dart';

class RecetasAgregar extends StatefulWidget {
  const RecetasAgregar({super.key});

  @override
  State<RecetasAgregar> createState() => _RecetasAgregarState();
}

class _RecetasAgregarState extends State<RecetasAgregar> {
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
    );
  }
}