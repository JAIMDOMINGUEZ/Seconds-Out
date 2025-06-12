import 'package:floor/floor.dart';
import 'package:flutter/foundation.dart';

@Entity(tableName: 'planeaciones')
class Planeacion {
  @PrimaryKey(autoGenerate: true)
  final int? id_planeacion;

  @ColumnInfo(name: 'nombre')
  final String nombre;

  @ColumnInfo(name: 'fecha_inicio')
  final DateTime fechaInicio;

  @ColumnInfo(name: 'fecha_fin')
  final DateTime fechaFin;

  Planeacion({
    this.id_planeacion,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
  });

  factory Planeacion.fromJson(Map<String, dynamic> json) {
    try {
      // Manejo robusto de fechas con valores por defecto
      final fechaInicio = DateTime.tryParse(json['fechaInicio']?.toString() ?? '') ??
          DateTime.tryParse(json['fecha_inicio']?.toString() ?? '') ??
          DateTime.now();

      final fechaFin = DateTime.tryParse(json['fechaFin']?.toString() ?? '') ??
          DateTime.tryParse(json['fecha_fin']?.toString() ?? '') ??
          fechaInicio.add(const Duration(days: 7)); // Valor por defecto: 1 semana

      return Planeacion(
        id_planeacion: json['id_planeacion'] as int? ?? json['id'] as int?,
        nombre: json['nombre']?.toString() ?? 'Nueva Planeación', // Valor por defecto
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );
    } catch (e, stackTrace) {
      debugPrint('Error parsing Planeacion: $e');
      debugPrint('Stack trace: $stackTrace');
      debugPrint('JSON data: $json');
      rethrow; // O devolver un objeto con valores por defecto si prefieres
    }
  }

  Map<String, dynamic> toJson() => {
    'id_planeacion': id_planeacion,
    'nombre': nombre,
    'fecha_inicio': fechaInicio.toIso8601String(),
    'fecha_fin': fechaFin.toIso8601String(),
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Planeacion &&
              runtimeType == other.runtimeType &&
              id_planeacion == other.id_planeacion &&
              nombre == other.nombre &&
              fechaInicio == other.fechaInicio &&
              fechaFin == other.fechaFin;

  @override
  int get hashCode =>
      id_planeacion.hashCode ^
      nombre.hashCode ^
      fechaInicio.hashCode ^
      fechaFin.hashCode;

  @override
  String toString() {
    return 'Planeacion{id: $id_planeacion, nombre: $nombre, inicio: $fechaInicio, fin: $fechaFin}';
  }
}