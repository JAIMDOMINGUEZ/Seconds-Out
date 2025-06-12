import 'package:secondsout_fixed/data/models/usuario.dart';

class UsuarioLogin {
  final Usuario usuario;
  final TipoUsuario tipoUsuario;

  UsuarioLogin({
    required this.usuario,
    required this.tipoUsuario,
  });
}

enum TipoUsuario {
  administrador,
  entrenador,
  atleta,
  desconocido,
}