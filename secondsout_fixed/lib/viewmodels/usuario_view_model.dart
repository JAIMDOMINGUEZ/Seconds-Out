import 'package:flutter/material.dart';
import 'package:secondsout_fixed/data/models/usuario_tipo.dart';
import '../data/models/usuario.dart';

import '/repositories/usuario_repository.dart';

class UsuarioViewModel extends ChangeNotifier {
  final UsuarioRepository usuarioRepository;

  UsuarioViewModel(this.usuarioRepository);

  Usuario? _usuarioLogueado;
  Usuario? get usuarioLogueado => _usuarioLogueado;

  Future<UsuarioConTipo?> loginUsuario(String correo, String contrasena) async {
    try {
      final usuario = await usuarioRepository.buscarPorCorreoYContrasena(correo, contrasena);
      if (usuario != null) {
        _usuarioLogueado = usuario;
        notifyListeners();

        final tipo = await usuarioRepository.determinarTipoUsuario(usuario.idUsuario);
        print('Tipo de usuario: ${tipo.tipoUsuario}');
        return tipo;
      }
      return null;
    } catch (e) {
      debugPrint('Error en loginUsuario: ${e.toString()}');
      return null;
    }
  }



  void cerrarSesion() {
    _usuarioLogueado = null;
    notifyListeners();
  }
}
