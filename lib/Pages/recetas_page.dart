import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dam_cookly/services/fs_service.dart';
import 'package:dam_cookly/widget/recetas_widget.dart';
import 'package:flutter/material.dart';

class RecetasPage extends StatelessWidget {
  const RecetasPage({super.key});

  @override
  Widget build(BuildContext context) {
     return Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: FsService().recetas(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return ListView.separated(
                    separatorBuilder: (context, index) => Divider(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var receta = snapshot.data!.docs[index];
                      return RecetasWidget(receta: receta);
                    },
                  );
                },
              ),
            ),
          );
  }
}