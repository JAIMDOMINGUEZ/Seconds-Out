import 'package:floor/floor.dart';

@Entity(tableName: 'ejercicios')
class Ejercicio {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String nombre;
  final String tipo;
  final String descripcion;

  Ejercicio({
    this.id,
    required this.nombre,
    required this.tipo,
    required this.descripcion,
  });

  factory Ejercicio.fromJson(Map<String, dynamic> json) => Ejercicio(
        id: json['id'],
        nombre: json['nombre'],
        tipo: json['tipo'],
        descripcion: json['descripcion'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'tipo': tipo,
        'descripcion': descripcion,
      };
}