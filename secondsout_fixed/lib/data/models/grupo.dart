import 'package:floor/floor.dart';

@Entity(tableName: 'grupos')
class Grupo {
  @PrimaryKey(autoGenerate: true)
  final int? id_grupo;

  final String nombre;
  final int capacidadMaxima;

  Grupo({
    this.id_grupo,
    required this.nombre,
    required this.capacidadMaxima,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) => Grupo(
    id_grupo: json['id_grupo'],
        nombre: json['nombre'],
        capacidadMaxima: json['capacidadMaxima'],
      );

  Map<String, dynamic> toJson() => {
        'id_grupo': id_grupo,
        'nombre': nombre,
        'capacidadMaxima': capacidadMaxima,
      };
  Grupo copyWith({
    int? id_grupo,
    String? nombre,
    int? capacidadMaxima,
  }) {
    return Grupo(
      id_grupo: id_grupo ?? this.id_grupo,
      nombre: nombre ?? this.nombre,
      capacidadMaxima: capacidadMaxima ?? this.capacidadMaxima,
    );
  }
}