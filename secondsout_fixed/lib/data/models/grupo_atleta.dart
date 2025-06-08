import 'package:floor/floor.dart';

import 'atleta.dart';
import 'grupo.dart';

@Entity(
  tableName: 'grupo_atletas',
  foreignKeys: [
    ForeignKey(childColumns: ['id_grupo'], parentColumns: ['id_grupo'], entity: Grupo),
    ForeignKey(childColumns: ['id_atleta'], parentColumns: ['id_atleta'], entity: Atleta),
  ],
)
class GrupoAtleta {
  @PrimaryKey(autoGenerate: true)
  final int? id_grupo_atleta;

  final int id_grupo;
  final int id_atleta;

  GrupoAtleta({
    this.id_grupo_atleta,
    required this.id_grupo,
    required this.id_atleta,
  });

  factory GrupoAtleta.fromJson(Map<String, dynamic> json) => GrupoAtleta(
    id_grupo_atleta: json['id_grupo_atleta'],
    id_grupo: json['id_grupo'],
    id_atleta: json['id_atleta'],
  );

  Map<String, dynamic> toJson() => {
    'id_grupo_atleta': id_grupo_atleta,
    'id_grupo': id_grupo,
    'id_atleta': id_atleta,
  };
}
