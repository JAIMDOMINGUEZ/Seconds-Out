import 'package:floor/floor.dart';
import 'entrenador.dart';
import 'grupo.dart';
@Entity(
  tableName: 'planeaciones',
  foreignKeys: [
    ForeignKey(
      childColumns: ['grupoId'],
      parentColumns: ['id'],
      entity: Grupo,
    )
  ],
)
class Planeacion {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String nombre;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final int grupoId;

  Planeacion({
    this.id,
    required this.nombre,
    required this.fechaInicio,
    required this.fechaFin,
    required this.grupoId,
  });

  factory Planeacion.fromJson(Map<String, dynamic> json) => Planeacion(
        id: json['id'],
        nombre: json['nombre'],
        fechaInicio: DateTime.parse(json['fechaInicio']),
        fechaFin: DateTime.parse(json['fechaFin']),
        grupoId: json['grupoId'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'fechaInicio': fechaInicio.toIso8601String(),
        'fechaFin': fechaFin.toIso8601String(),
        'grupoId': grupoId,
      };
}