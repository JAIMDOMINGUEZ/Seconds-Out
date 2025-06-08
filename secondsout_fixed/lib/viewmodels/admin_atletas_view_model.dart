import 'package:flutter/foundation.dart';
import '../data/models/atleta.dart';
import '../data/models/usuario.dart';
import '../repositories/atleta_repository.dart';
import '../repositories/usuario_repository.dart';

class AdminAtletasViewModel extends ChangeNotifier {
  final AtletaRepository _atletaRepository;
  final UsuarioRepository _usuarioRepository;

  List<Atleta> _atletas = [];
  List<Atleta> get atletas => _atletas;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AdminAtletasViewModel(this._atletaRepository, this._usuarioRepository);

  Future<void> cargarAtletas() async {
    _isLoading = true;
    notifyListeners();
    try {
      _atletas = await _atletaRepository.obtenerTodosLosAtletas();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar atletas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registrarAtleta({
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
      // 1. Insertar usuario primero
      final nuevoUsuario = Usuario(
        idUsuario: 0, // Auto-incrementado
        nombre: nombre,
        correo: correo,
        contrasena: contrasena,
        fechaNacimiento: fechaNacimiento,
      );

      final idUsuario = await _usuarioRepository.insertarUsuario(nuevoUsuario);
      debugPrint('ID de usuario insertado: $idUsuario');

      // 2. Insertar atleta
      final nuevoAtleta = Atleta(
        idAtleta: 0, // Auto-incrementado
        idUsuario: idUsuario,

      );

      final idAtleta = await _atletaRepository.insertarAtleta(nuevoAtleta);
      debugPrint('ID de atleta insertado: $idAtleta');

      _successMessage = 'Atleta registrado exitosamente';
      await cargarAtletas();
      return true;
    } catch (e) {
      debugPrint('Error en registrarAtleta: $e');
      _errorMessage = 'Error al registrar atleta: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarAtleta(int idAtleta) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _atletaRepository.eliminarAtleta(idAtleta);
      await cargarAtletas();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al eliminar atleta: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarAtleta(Atleta atletaActualizado) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (atletaActualizado.usuario == null) {
        throw Exception('No se puede actualizar un atleta sin usuario');
      }

      // Actualizar primero el usuario
      await _usuarioRepository.actualizarUsuario(atletaActualizado.usuario!);

      // Luego actualizar los datos específicos del atleta
      await _atletaRepository.actualizarAtleta(atletaActualizado);

      await cargarAtletas();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar atleta: $e';
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
      _atletas = await _atletaRepository.buscarAtletasPorNombre(nombre);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al buscar atletas: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}