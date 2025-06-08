import 'package:flutter/foundation.dart';
import '../data/models/entrenador.dart';
import '../data/models/usuario.dart';

import '../repositories/entrenador_repository.dart';
import '../repositories/usuario_repository.dart';

class AdminEntrenadoresViewModel extends ChangeNotifier {
  final EntrenadorRepository _entrenadorRepository;
  final UsuarioRepository _usuarioRepository;

  List<Entrenador> _entrenadores = [];
  List<Entrenador> get entrenadores => _entrenadores;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AdminEntrenadoresViewModel(this._entrenadorRepository, this._usuarioRepository);

  //get successMessage => null;

  Future<void> cargarEntrenadores() async {
    _isLoading = true;
    notifyListeners();
    try {
      _entrenadores = await _entrenadorRepository.obtenerTodosLosEntrenadores();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar entrenadores: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registrarEntrenador({
    required String nombre,
    required String correo,
    required String contrasena,
    required String fechaNacimiento,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      // 1. Insertar usuario
      final nuevoUsuario = Usuario(
        idUsuario: 0,
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        fechaNacimiento: fechaNacimiento,
      );

      final idUsuario = await _usuarioRepository.insertarUsuario(nuevoUsuario);
      debugPrint('ID de usuario insertado: $idUsuario');

      // 2. Insertar entrenador
      final nuevoEntrenador = Entrenador(
        idEntrenador: 0,
        idUsuario: idUsuario,
      );

      final idEntrenador = await _entrenadorRepository.insertarEntrenador(nuevoEntrenador);
      debugPrint('ID de entrenador insertado: $idEntrenador');

      _successMessage = 'Entrenador registrado exitosamente';
      await cargarEntrenadores();
      return true;
    } catch (e) {
      debugPrint('Error en registrarEntrenador: $e');
      _errorMessage = 'Error al registrar entrenador: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarEntrenador(int idEntrenador) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _entrenadorRepository.eliminarEntrenador(idEntrenador);
      await cargarEntrenadores();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al eliminar entrenador: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarEntrenador(Entrenador entrenadorActualizado) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (entrenadorActualizado.usuario == null) {
        throw Exception('No se puede actualizar un entrenador sin usuario');
      }

      await _usuarioRepository.actualizarUsuario(entrenadorActualizado.usuario!);
      await cargarEntrenadores();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar entrenador: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> buscarPorNombre(String nombre) async {
    _isLoading = true;
    notifyListeners();
    try {
      _entrenadores = await _entrenadorRepository.buscarEntrenadoresPorNombre(nombre);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al buscar entrenadores: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
