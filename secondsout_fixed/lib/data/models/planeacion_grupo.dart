import 'package:floor/floor.dart';
import 'package:secondsout_fixed/data/models/planeacion.dart' show Planeacion;

import 'grupo.dart';

@Entity(
  tableName: 'planeacion_grupo',
  foreignKeys: [
    ForeignKey(
      childColumns: ['id_planeacion'],
      parentColumns: ['id_planeacion'],
      entity: Planeacion,
      onDelete: ForeignKeyAction.cascade,
    ),
    ForeignKey(
      childColumns: ['id_grupo'],
      parentColumns: ['id_grupo'],
      entity: Grupo,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['id_planeacion']),
    Index(value: ['id_grupo']),
  ],
)
class PlaneacionGrupo {
  @PrimaryKey(autoGenerate: true)
  final int? id_planeacion_grupo;

  final int id_planeacion;
  final int id_grupo;

  PlaneacionGrupo({
    this.id_planeacion_grupo,
    required this.id_planeacion,
    required this.id_grupo,
  });

  factory PlaneacionGrupo.fromJson(Map<String, dynamic> json) => PlaneacionGrupo(
    id_planeacion_grupo: json['id_planeacion_grupo'] as int?,
    id_planeacion: json['id_planeacion'] as int,
    id_grupo: json['id_grupo'] as int,
  );

  Map<String, dynamic> toJson() => {
    'id_planeacion_grupo': id_planeacion_grupo,
    'id_planeacion': id_planeacion,
    'id_grupo': id_grupo,
  };

  PlaneacionGrupo copyWith({
    int? id_planeacion_grupo,
    int? id_planeacion,
    int? id_grupo,
  }) {
    return PlaneacionGrupo(
      id_planeacion_grupo: id_planeacion_grupo ?? this.id_planeacion_grupo,
      id_planeacion: id_planeacion ?? this.id_planeacion,
      id_grupo: id_grupo ?? this.id_grupo,
    );
  }
}
