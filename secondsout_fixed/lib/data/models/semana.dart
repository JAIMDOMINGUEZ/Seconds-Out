import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@Entity(tableName: 'semanas')
class Semana {
  @PrimaryKey(autoGenerate: true)
  final int? id_semana;

  @ColumnInfo(name: 'id_planeacion')
  final int id_planeacion;

  @ColumnInfo(name: 'nombre')
  final String nombre;

  @ColumnInfo(name: 'fecha_inicio')
  final DateTime fechaInicio;

  @ColumnInfo(name: 'fecha_fin')
  final DateTime fechaFin;

  Semana({
    this.id_semana,
    required this.id_planeacion,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Semana.fromJson(Map<String, dynamic> json) {
    try {
      final fechaInicio = DateTime.tryParse(json['fechaInicio']?.toString() ?? '') ??
          DateTime.tryParse(json['fecha_inicio']?.toString() ?? '') ??
          DateTime.now();

      final fechaFin = DateTime.tryParse(json['fechaFin']?.toString() ?? '') ??
          DateTime.tryParse(json['fecha_fin']?.toString() ?? '') ??
          fechaInicio.add(const Duration(days: 7));
      final idPlaneacion = (json['id_planeacion'] ?? json['idPlaneacion']);
      if (idPlaneacion == null) {
        throw ArgumentError('id_planeacion es requerido');
      }
      return Semana(
        id_semana: json['id_semana'] as int?,
        nombre: json['nombre']?.toString() ?? 'Nueva Semana',
        id_planeacion: idPlaneacion is int ? idPlaneacion : int.parse(idPlaneacion.toString()),
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing Semana: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    'id_semana': id_semana,
    'id_planeacion': id_planeacion,
    'nombre': nombre,
    'fecha_inicio': fechaInicio.toIso8601String(),
    'fecha_fin': fechaFin.toIso8601String(),
  };

  Semana copyWith({
    int? id_semana,
    int? id_planeacion,
    String? nombre,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) {
    return Semana(
      id_semana: id_semana ?? this.id_semana,
      id_planeacion: id_planeacion ?? this.id_planeacion,
      nombre: nombre ?? this.nombre,
      fechaInicio: fechaInicio ?? this.fechaInicio,
      fechaFin: fechaFin ?? this.fechaFin,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Semana &&
              runtimeType == other.runtimeType &&
              id_semana == other.id_semana &&
              id_planeacion == other.id_planeacion &&
              nombre == other.nombre &&
              fechaInicio == other.fechaInicio &&
              fechaFin == other.fechaFin;

  @override
  int get hashCode =>
      id_semana.hashCode ^
      id_planeacion.hashCode ^
      nombre.hashCode ^
      fechaInicio.hashCode ^
      fechaFin.hashCode;

  @override
  String toString() {
    return 'Semana{id: $id_semana, nombre: $nombre, inicio: $fechaInicio, fin: $fechaFin}';
  }
}