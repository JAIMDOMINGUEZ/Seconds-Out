import 'package:floor/floor.dart';

import 'ejercicio.dart';
import 'sesion.dart';

@Entity(
  tableName: 'ejercicios_asignados',
  foreignKeys: [
    ForeignKey(
      childColumns: ['sesionId'],
      parentColumns: ['id'],
      entity: Sesion,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['ejercicioId'],
      parentColumns: ['id'],
      entity: Ejercicio,
    ),
  ],
)
class EjercicioAsignado {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int sesionId;
  final int ejercicioId;
  final int tiempoTrabajo; // segundos
  final int tiempoDescanso; // segundos
  final int repeticiones;

  EjercicioAsignado({
    this.id,
    required this.sesionId,
    required this.ejercicioId,
    required this.tiempoTrabajo,
    required this.tiempoDescanso,
    required this.repeticiones,
  });

  factory EjercicioAsignado.fromJson(Map<String, dynamic> json) => EjercicioAsignado(
        id: json['id'] as int?,
        sesionId: json['sesionId'] as int,
        ejercicioId: json['ejercicioId'] as int,
        tiempoTrabajo: json['tiempoTrabajo'] as int,
        tiempoDescanso: json['tiempoDescanso'] as int,
        repeticiones: json['repeticiones'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sesionId': sesionId,
        'ejercicioId': ejercicioId,
        'tiempoTrabajo': tiempoTrabajo,
        'tiempoDescanso': tiempoDescanso,
        'repeticiones': repeticiones,
      };
}