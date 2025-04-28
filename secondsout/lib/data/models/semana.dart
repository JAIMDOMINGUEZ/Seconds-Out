import 'package:floor/floor.dart';

import 'planeacion.dart';

@Entity(
  tableName: 'semanas',
  foreignKeys: [
    ForeignKey(
      childColumns: ['planeacionId'],
      parentColumns: ['id'],
      entity: Planeacion,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Semana {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int planeacionId;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  Semana({
    this.id,
    required this.planeacionId,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Semana.fromJson(Map<String, dynamic> json) => Semana(
        id: json['id'] as int?,
        planeacionId: json['planeacionId'] as int,
        nombre: json['nombre'] as String,
        fechaInicio: DateTime.parse(json['fechaInicio'] as String),
        fechaFin: DateTime.parse(json['fechaFin'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'planeacionId': planeacionId,
        'nombre': nombre,
        'fechaInicio': fechaInicio.toIso8601String(),
        'fechaFin': fechaFin.toIso8601String(),
      };
}