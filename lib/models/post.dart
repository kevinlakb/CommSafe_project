// To parse this JSON data, do
//
//     final post = postFromMap(jsonString);

import 'dart:convert';

class Post {
  Post(
      {this.detalle,
      this.picture,
      this.titulo,
      this.id,
      this.comentarios,
      this.idUser});
  List<dynamic> comentarios;
  String detalle;
  String picture;
  String titulo;
  String idUser;
  String id;

  factory Post.fromJson(String str) => Post.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Post.fromMap(Map<String, dynamic> json) => Post(
        comentarios: json["comentarios"],
        detalle: json["detalle"],
        picture: json["picture"],
        titulo: json["titulo"],
        idUser: json["idUser"],
      );

  Map<String, dynamic> toMap() => {
        "comentarios": comentarios,
        "detalle": detalle,
        "picture": picture,
        "titulo": titulo,
        "idUser": idUser,
      };

  Post copy() => Post(
      comentarios: this.comentarios,
      detalle: this.detalle,
      picture: this.picture,
      titulo: this.titulo,
      idUser: this.idUser,
      id: this.id);
}
