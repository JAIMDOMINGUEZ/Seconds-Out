import 'package:floor/floor.dart';
import 'usuario.dart';


class Atleta {
  @primaryKey
  final int idAtleta;
  final int idUsuario;
  final Usuario? usuario;

  Atleta({
    required this.idAtleta,
    required this.idUsuario,
    this.usuario,
  });

  factory Atleta.fromMap(Map<String, dynamic> map) {
    return Atleta(
      idAtleta: map['id_atleta'],
      idUsuario: map['id_usuario'],
    );
  }

  Map<String, dynamic> toMap() => {
    'id_atleta': idAtleta,
    'id_usuario': idUsuario,



  };

  // Propiedades delegadas para fácil acceso
  String get nombre => usuario?.nombre ?? '';
  String get correo => usuario?.correo ?? '';
  String get contrasena => usuario?.contrasena ?? '';
  String get fechaNacimiento => usuario?.fechaNacimiento ?? '';

  Atleta copyWith({
    int? idAtleta,
    int? idUsuario,
    Usuario? usuario,
  }) {
    return Atleta(
      idAtleta: idAtleta ?? this.idAtleta,
      idUsuario: idUsuario ?? this.idUsuario,
      usuario: usuario ?? this.usuario,
    );
  }

}
