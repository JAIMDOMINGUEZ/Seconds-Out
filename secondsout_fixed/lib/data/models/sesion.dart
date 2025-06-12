import 'package:floor/floor.dart';

import 'semana.dart';


class Sesion {
  @PrimaryKey(autoGenerate: true)
  final int? id_sesion;
  final int id_semana;
  final String nombre; // Ej: "Lunes", "Martes"


  Sesion({
    this.id_sesion,
    required this.id_semana,
    required this.nombre,

  });

  factory Sesion.fromJson(Map<String, dynamic> json) => Sesion(
    id_sesion: json['id_sesion'] as int?,
    id_semana: json['id_semana'] as int,
        nombre: json['nombre'] as String,

      );

  Map<String, dynamic> toJson() => {
        'id_sesion': id_sesion,
        'id_semana': id_semana,
        'nombre': nombre,

      };
}