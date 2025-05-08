import 'package:floor/floor.dart';

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



  Entrenador({
    this.id,
    required String nombre,
    required String correo,
    required String contrasena,
    String? fotoUrl,
    required String fechaNacimiento,
    
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
        
      );

  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        
        'tipo': 'entrenador',
      };
}