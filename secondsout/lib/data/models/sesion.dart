import 'package:floor/floor.dart';

import 'semana.dart';

@Entity(
  tableName: 'sesiones',
  foreignKeys: [
    ForeignKey(
      childColumns: ['semanaId'],
      parentColumns: ['id'],
      entity: Semana,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
)
class Sesion {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int semanaId;
  final String dia; // Ej: "Lunes", "Martes"
  final String objetivo;

  Sesion({
    this.id,
    required this.semanaId,
    required this.dia,
    required this.objetivo,
  });

  factory Sesion.fromJson(Map<String, dynamic> json) => Sesion(
        id: json['id'] as int?,
        semanaId: json['semanaId'] as int,
        dia: json['dia'] as String,
        objetivo: json['objetivo'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'semanaId': semanaId,
        'dia': dia,
        'objetivo': objetivo,
      };
}