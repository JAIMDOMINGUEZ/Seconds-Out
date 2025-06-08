import 'package:floor/floor.dart';

import 'ejercicio.dart';
import 'sesion.dart';


class EjercicioAsignado {
  @PrimaryKey(autoGenerate: true)
  final int? id_ejercicio_asignado;
  final int id_sesion;
  final int id_ejercicio;
  final int tiempoTrabajo; // segundos
  final int tiempoDescanso; // segundos
  final int repeticiones;

  EjercicioAsignado({
    this.id_ejercicio_asignado,
    required this.id_sesion,
    required this.id_ejercicio,
    required this.tiempoTrabajo,
    required this.tiempoDescanso,
    required this.repeticiones,
  });

  factory EjercicioAsignado.fromJson(Map<String, dynamic> json) => EjercicioAsignado(
    id_ejercicio_asignado: json['id_ejercicio_asignado'] as int?,
    id_sesion: json['id_sesion'] as int,
    id_ejercicio: json['id_ejercicio'] as int,
        tiempoTrabajo: json['tiempoTrabajo'] as int,
        tiempoDescanso: json['tiempoDescanso'] as int,
        repeticiones: json['repeticiones'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id_ejercicio_asignado': id_ejercicio_asignado,
        'id_sesion': id_sesion,
        'id_ejercicio': id_ejercicio,
        'tiempoTrabajo': tiempoTrabajo,
        'tiempoDescanso': tiempoDescanso,
        'repeticiones': repeticiones,
      };
}