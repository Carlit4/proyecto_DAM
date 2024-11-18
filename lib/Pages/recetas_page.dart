import 'package:dam_cookly/widget/recetas_widget.dart';
import 'package:flutter/material.dart';

class RecetasPage extends StatelessWidget {
  const RecetasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        RecetasWidget(
            titulo: 'Sushi',
            calificacion: '4.5',
            tiempoCoccion: '30 mins',
            categoria: 'Japonesa',
            rutaImagen: 'assets/images/sushi.jpg',
          ),
          
          // Ejemplo 2: Tacos al Pastor
          RecetasWidget(
            titulo: 'Tacos al Pastor',
            calificacion: '4.7',
            tiempoCoccion: '45 min',
            categoria: 'Mexicana',
            rutaImagen: 'assets/images/tacos.jpg',
          ),

          // Ejemplo 3: Pizza Margherita
          RecetasWidget(
            titulo: 'Pizza Margherita',
            calificacion: '4.8',
            tiempoCoccion: '40 min',
            categoria: 'Italiana',
            rutaImagen: 'assets/images/pizza.jpg',
          ),

          // Ejemplo 4: Ensalada César
          RecetasWidget(
            titulo: 'Ensalada César',
            calificacion: '4.3',
            tiempoCoccion: '15 min',
            categoria: 'Vegetariana',
            rutaImagen: 'assets/images/ensalada.jpg',
          ),

          // Ejemplo 5: Paella Valenciana
          RecetasWidget(
            titulo: 'Paella Valenciana',
            calificacion: '5.0',
            tiempoCoccion: '1 hr 15 min',
            categoria: 'Española',
            rutaImagen: 'assets/images/paella.jpg',
          ),
      ],
    );
  }
}