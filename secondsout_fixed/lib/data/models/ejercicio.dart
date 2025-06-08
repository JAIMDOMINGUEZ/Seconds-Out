import 'package:floor/floor.dart';

@Entity(tableName: 'ejercicios')
class Ejercicio {
  @PrimaryKey(autoGenerate: true)
  final int? id_ejercicio;
  final String nombre;
  final String tipo;
  final String descripcion;

  Ejercicio({
    this.id_ejercicio,
    required this.nombre,
    required this.tipo,
    required this.descripcion,
  });

  factory Ejercicio.fromJson(Map<String, dynamic> json) => Ejercicio(
    id_ejercicio: json['id_ejercicio'],
        nombre: json['nombre'],
        tipo: json['tipo'],
        descripcion: json['descripcion'],
      );

  Map<String, dynamic> toJson() => {
        'id_ejercicio': id_ejercicio,
        'nombre': nombre,
        'tipo': tipo,
        'descripcion': descripcion,
      };
  // Método copyWith para crear una copia modificada del objeto
  Ejercicio copyWith({

    String? nombre,
    String? tipo,
    String? descripcion, required id_ejercicio,
  }) {
    return Ejercicio(

      nombre: nombre ?? this.nombre,
      tipo: tipo ?? this.tipo,
      descripcion: descripcion ?? this.descripcion,
    );
  }

}