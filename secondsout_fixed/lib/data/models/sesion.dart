import 'package:floor/floor.dart';

import 'semana.dart';


class Sesion {
  @PrimaryKey(autoGenerate: true)
  final int? id_sesion;
  final int semanaId;
  final String nombre; // Ej: "Lunes", "Martes"


  Sesion({
    this.id_sesion,
    required this.semanaId,
    required this.nombre,

  });

  factory Sesion.fromJson(Map<String, dynamic> json) => Sesion(
    id_sesion: json['id_sesion'] as int?,
        semanaId: json['semanaId'] as int,
        nombre: json['dia'] as String,

      );

  Map<String, dynamic> toJson() => {
        'id_sesion': id_sesion,
        'semanaId': semanaId,
        'nombre': nombre,

      };
}