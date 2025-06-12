import 'package:flutter/material.dart';
import '../data/models/usuario_login.dart';
import '../repositories/usuario_repository.dart';
import '/data/models/usuario_login.dart';
import '../screens/menu_screen.dart';

class LoginViewModel with ChangeNotifier {
  final UsuarioRepository usuarioRepository;
  bool _isLoading = false;
  String _errorMessage = '';

  LoginViewModel(this.usuarioRepository);

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> login(String email, String password, BuildContext context) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final usuarioLogin = await usuarioRepository.login(email, password);

      if (usuarioLogin != null) {
        // Navegar al menú según el tipo de usuario
        _navigateToMenu(context, usuarioLogin.tipoUsuario);
      } else {
        _errorMessage = 'Credenciales incorrectas';
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _navigateToMenu(BuildContext context, TipoUsuario tipoUsuario) {
    UserRole userRole;

    switch (tipoUsuario) {
      case TipoUsuario.administrador:
        userRole = UserRole.admin;
        break;
      case TipoUsuario.entrenador:
        userRole = UserRole.entrenador;
        break;
      case TipoUsuario.atleta:
        userRole = UserRole.atleta;
        break;
      case TipoUsuario.desconocido:
      default:
        userRole = UserRole.atleta;
        break;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MenuScreen(userRole: userRole),
      ),
    );
  }
}