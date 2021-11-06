import 'package:flutter/material.dart';

class ListaPost extends StatelessWidget {

  final List noticias;

  const ListaPost (this.noticias);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.noticias.length,
      itemBuilder: (BuildContext context, int index) {
        return Text(this.noticias[index].title);
      },
    );
  }
}