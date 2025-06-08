import 'package:floor/floor.dart';

import 'planeacion.dart';

class Semana {
  @PrimaryKey(autoGenerate: true)
  final int? id_semana;
  final int id_planeacion;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  Semana({
    this.id_semana,
    required this.id_planeacion,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Semana.fromJson(Map<String, dynamic> json) => Semana(
    id_semana: json['id_semana'] as int?,
    id_planeacion: json['id_planeacion'] as int,
        nombre: json['nombre'] as String,
        fechaInicio: DateTime.parse(json['fechaInicio'] as String),
        fechaFin: DateTime.parse(json['fechaFin'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id_semana': id_semana,
        'id_planeacion': id_planeacion,
        'nombre': nombre,
        'fechaInicio': fechaInicio.toIso8601String(),
        'fechaFin': fechaFin.toIso8601String(),
      };
}