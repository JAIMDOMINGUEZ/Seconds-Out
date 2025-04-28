import 'package:floor/floor.dart';

// lib/models/usuario.dart
abstract class Usuario {
  final int? id; // Nullable para inserts
  final String nombre;
  final String correo;
  final String contrasena; // ¡Encriptar en producción!
  final String? fotoUrl;
  final String fechaNacimiento;

  Usuario({
    this.id,
    required this.nombre,
    required this.correo,
    required this.contrasena,
    this.fotoUrl,
    required this.fechaNacimiento,
  });
  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
    'contrasena': contrasena,
    'fotoUrl': fotoUrl,
    'fechaNacimiento': fechaNacimiento,
  };
}