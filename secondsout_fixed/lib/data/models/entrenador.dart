import 'usuario.dart';

class Entrenador {
  final int idEntrenador;
  final int idUsuario;
  final Usuario? usuario;
  final int? localId;

  Entrenador({
    required this.idEntrenador,
    required this.idUsuario,
    this.usuario,
    this.localId,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'id_usuario': idUsuario,
      // No incluyas id_entrenador si es autoincremental
    };
    if (idEntrenador != 0) {
      map['id_entrenador'] = idEntrenador;
    }
    return map;
  }

  factory Entrenador.fromMap(Map<String, dynamic> map) {
    return Entrenador(
      idEntrenador: map['id_entrenador'],
      idUsuario: map['id_usuario'],
    );
  }

  Entrenador copyWith({
    int? idEntrenador,
    int? idUsuario,
    Usuario? usuario,
    int? localId,
  }) {
    return Entrenador(
      idEntrenador: idEntrenador ?? this.idEntrenador,
      idUsuario: idUsuario ?? this.idUsuario,
      usuario: usuario ?? this.usuario,
      localId: localId ?? this.localId,
    );
  }

  // Propiedades delegadas al usuario para fácil acceso
  String get nombre => usuario?.nombre ?? '';
  String get correo => usuario?.correo ?? '';
  String get contrasena => usuario?.contrasena ?? '';
  String get fechaNacimiento => usuario?.fechaNacimiento ?? '';
}