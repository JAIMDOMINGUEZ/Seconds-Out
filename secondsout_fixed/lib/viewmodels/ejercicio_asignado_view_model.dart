import 'package:flutter/foundation.dart';
import '/data/models/ejercicio_asignado.dart';
import '../repositories/ejercicio_asignado_repository.dart';
import '../repositories/ejercicio_repository.dart';
import '/data/models/ejercicio.dart';

class EjercicioAsignadoViewModel with ChangeNotifier {
  final EjercicioAsignadoRepository _ejercicioAsignadoRepository;
  final EjercicioRepository _ejercicioRepository;

  List<EjercicioAsignado> _ejerciciosAsignados = [];
  List<Ejercicio> _ejerciciosDisponibles = [];
  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false;

  // Getters
  List<EjercicioAsignado> get ejerciciosAsignados => _ejerciciosAsignados;
  List<Ejercicio> get ejerciciosDisponibles => _ejerciciosDisponibles;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  EjercicioAsignadoViewModel({
    required EjercicioAsignadoRepository ejercicioAsignadoRepository,
    required EjercicioRepository ejercicioRepository,
  })  : _ejercicioAsignadoRepository = ejercicioAsignadoRepository,
        _ejercicioRepository = ejercicioRepository;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void safeNotifyListeners() {
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> cargarEjerciciosAsignados(int idSesion) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    safeNotifyListeners();

    try {
      await cargarEjerciciosDisponibles();
      _ejerciciosAsignados = await _ejercicioAsignadoRepository.getEjerciciosBySesion(idSesion);
    } catch (e) {
      _errorMessage = 'Error al cargar ejercicios asignados: ${e.toString()}';
      _ejerciciosAsignados = [];
      if (kDebugMode) {
        print(_errorMessage);
      }
    } finally {
      _isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<void> cargarEjerciciosDisponibles() async {
    try {
      _ejerciciosDisponibles = await _ejercicioRepository.obtenerTodosLosEjercicios();
    } catch (e) {
      _errorMessage = 'Error al cargar ejercicios disponibles: ${e.toString()}';
      _ejerciciosDisponibles = [];
      if (kDebugMode) {
        print(_errorMessage);
      }
      safeNotifyListeners();
    }
  }

  Future<bool> agregarEjercicioAsignado({
    required int idSesion,
    required int idEjercicio,
    required int repeticiones,
    required int tiempoTrabajo,
    required int tiempoDescanso,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    safeNotifyListeners();

    try {
      final nuevoEjercicio = EjercicioAsignado(
        id_sesion: idSesion,
        id_ejercicio: idEjercicio,
        repeticiones: repeticiones,
        tiempoTrabajo: tiempoTrabajo,
        tiempoDescanso: tiempoDescanso,
      );

      final id = await _ejercicioAsignadoRepository.insertEjercicioAsignado(nuevoEjercicio);

      if (id != null) {
        await cargarEjerciciosAsignados(idSesion);
        return true;
      }

      _errorMessage = 'No se pudo agregar el ejercicio';
      return false;
    } catch (e) {
      _errorMessage = 'Error al agregar ejercicio: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
      return false;
    } finally {
      _isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> actualizarEjercicioAsignado(EjercicioAsignado ejercicio) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      safeNotifyListeners();

      final rowsAffected = await _ejercicioAsignadoRepository.updateEjercicioAsignado(ejercicio);

      if (rowsAffected <= 0) {
        _errorMessage = 'No se actualizó ningún registro';
        return false;
      }

      // Recargar los ejercicios automáticamente
      await cargarEjerciciosAsignados(ejercicio.id_sesion);
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> eliminarEjercicioAsignado(int idEjercicioAsignado, int idSesion) async {
    _isLoading = true;
    _errorMessage = null;
    safeNotifyListeners();

    try {
      final rowsAffected = await _ejercicioAsignadoRepository.deleteEjercicioAsignado(idEjercicioAsignado);

      if (rowsAffected > 0) {
        await cargarEjerciciosAsignados(idSesion);
        return true;
      }

      _errorMessage = 'No se pudo eliminar el ejercicio';
      return false;
    } catch (e) {
      _errorMessage = 'Error al eliminar ejercicio: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
      return false;
    } finally {
      _isLoading = false;
      safeNotifyListeners();
    }
  }

  Future<bool> limpiarEjerciciosSesion(int idSesion) async {
    _isLoading = true;
    _errorMessage = null;
    safeNotifyListeners();

    try {
      final rowsAffected = await _ejercicioAsignadoRepository.deleteEjerciciosBySesion(idSesion);

      if (rowsAffected > 0) {
        await cargarEjerciciosAsignados(idSesion);
        return true;
      }

      _errorMessage = 'No se pudieron eliminar los ejercicios';
      return false;
    } catch (e) {
      _errorMessage = 'Error al limpiar ejercicios: ${e.toString()}';
      if (kDebugMode) {
        print(_errorMessage);
      }
      return false;
    } finally {
      _isLoading = false;
      safeNotifyListeners();
    }
  }
}