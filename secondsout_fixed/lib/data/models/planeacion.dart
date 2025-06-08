import 'package:floor/floor.dart';
import 'entrenador.dart';
import 'grupo.dart';

class Planeacion {
  @PrimaryKey(autoGenerate: true)
  final int? id_planeacion;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  Planeacion({
    this.id_planeacion,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Planeacion.fromJson(Map<String, dynamic> json) => Planeacion(
    id_planeacion: json['id_planeacion'] ?? json['id'], // por si viene como 'id'
    nombre: json['nombre'],
    fechaInicio: DateTime.parse(json['fechaInicio']),
    fechaFin: DateTime.parse(json['fechaFin']),
  );

  Map<String, dynamic> toJson() => {
    'id_planeacion': id_planeacion,
    'nombre': nombre,
    'fechaInicio': fechaInicio.toIso8601String(),
    'fechaFin': fechaFin.toIso8601String(),
  };

  Planeacion copyWith({
    int? id_planeacion,
    String? nombre,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) {
    return Planeacion(
      id_planeacion: id_planeacion ?? this.id_planeacion,
      nombre: nombre ?? this.nombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
    );
  }
}
