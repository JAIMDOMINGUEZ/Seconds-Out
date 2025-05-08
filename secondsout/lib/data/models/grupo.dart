import 'package:floor/floor.dart';

@Entity(tableName: 'grupos')
class Grupo {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String nombre;
  final int capacidadMaxima;

  Grupo({
    this.id,
    required this.nombre,
    required this.capacidadMaxima,
  });

  factory Grupo.fromJson(Map<String, dynamic> json) => Grupo(
        id: json['id'],
        nombre: json['nombre'],
        capacidadMaxima: json['capacidadMaxima'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'capacidadMaxima': capacidadMaxima,
      };
}