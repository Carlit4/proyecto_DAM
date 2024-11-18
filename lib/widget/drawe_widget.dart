import 'package:flutter/material.dart';

class DraweWidget extends StatelessWidget {
  const DraweWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      padding: EdgeInsets.all(0),
      child: Container(
        padding: EdgeInsets.all(5),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Image.asset('assets/images/D.jpg'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}