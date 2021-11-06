import 'dart:convert';

class Profile {
  Profile({
    this.picture,
    this.nombre,
    this.detalle,
    this.id});
  
   String picture;
   String nombre;
   String detalle;
   String id;
   bool isDarkMode = false;

  factory Profile.fromJson(String str) => Profile.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Profile.fromMap(Map<String, dynamic> json) => Profile(
        nombre: json["nombre"],
        detalle: json["detalle"],
        picture: json["picture"],
      );

  Map<String, dynamic> toMap() => {
        "nombre": nombre,
        "detalle": detalle,
        "picture": picture,
      };

  Profile copy() => Profile(
      nombre: this.nombre,
      detalle: this.detalle,
      picture: this.picture,
      id: this.id);
}
