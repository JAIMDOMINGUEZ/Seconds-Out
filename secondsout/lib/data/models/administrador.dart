import 'package:floor/floor.dart';
import 'usuario.dart';

class Administrador extends Usuario {
  Administrador({
    int? id,
    required String nombre,
    required String correo,
    required String contrasena,
    String? fotoUrl,
    required String fechaNacimiento,
  }) : super(
          id: id,
          nombre: nombre,
          correo: correo,
          contrasena: contrasena,
          fotoUrl: fotoUrl,
          fechaNacimiento: fechaNacimiento,
        );

  // Convertir a/desde JSON para Firebase
  factory Administrador.fromJson(Map<String, dynamic> json) => Administrador(
        id: json['id'],
        nombre: json['nombre'],
        correo: json['correo'],
        contrasena: json['contrasena'],
        fotoUrl: json['fotoUrl'],
        fechaNacimiento: json['fechaNacimiento'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'correo': correo,
        'contrasena': contrasena,
        'fotoUrl': fotoUrl,
        'fechaNacimiento': fechaNacimiento,
        'tipo': 'administrador', // Para distinguir en Firebase
      };
}