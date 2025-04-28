import 'package:floor/floor.dart';
import 'package:secondsout/data/models/grupo.dart';

import 'usuario.dart';

/// lib/models/entrenador.dart
@Entity(
  tableName: 'entrenadores',
  foreignKeys: [
    ForeignKey(
      childColumns: ['usuarioId'],
      parentColumns: ['id'],
      entity: Usuario,
      onDelete: ForeignKeyAction.cascade,
    )
  ],
)
class Entrenador extends Usuario {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String licencia;

  Entrenador({
    this.id,
    required String nombre,
    required String correo,
    required String contrasena,
    String? fotoUrl,
    required String fechaNacimiento,
    required this.licencia,
  }) : super(
          id: id,
          nombre: nombre,
          correo: correo,
          contrasena: contrasena,
          fotoUrl: fotoUrl,
          fechaNacimiento: fechaNacimiento,
        );

  // Para Firebase
  factory Entrenador.fromJson(Map<String, dynamic> json) => Entrenador(
        id: json['id'],
        nombre: json['nombre'],
        correo: json['correo'],
        contrasena: json['contrasena'],
        fotoUrl: json['fotoUrl'],
        fechaNacimiento: json['fechaNacimiento'],
        licencia: json['licencia'],
      );

  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'licencia': licencia,
        'tipo': 'entrenador',
      };
}