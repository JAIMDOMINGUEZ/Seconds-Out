import 'package:flutter/foundation.dart';
import '../data/models/planeacion.dart';
import '../repositories/planeacion_repository.dart';

class AdminPlaneacionesViewModel extends ChangeNotifier {
  final PlaneacionRepository _planeacionRepository;

  AdminPlaneacionesViewModel(this._planeacionRepository);

  List<Planeacion> _planeaciones = [];
  List<Planeacion> get planeaciones => _planeaciones;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String? _successMessage;
  String? get successMessage => _successMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> cargarPlaneaciones() async {
    _isLoading = true;
    notifyListeners();
    try {
      _planeaciones = await _planeacionRepository.obtenerTodasLasPlaneaciones();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar planeaciones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> registrarPlaneacion({
    required String nombre,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevaPlaneacion = Planeacion(
        nombre: nombre,
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

      await _planeacionRepository.insertarPlaneacion(nuevaPlaneacion);
      _successMessage = 'Planeación registrada exitosamente';
      await cargarPlaneaciones();
      return true;
    } catch (e) {
      _errorMessage = 'Error al registrar planeación: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarPlaneacion(Planeacion planeacionActualizada) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _planeacionRepository.actualizarPlaneacion(planeacionActualizada);
      await cargarPlaneaciones();
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar planeación: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> eliminarPlaneacion(int idPlaneacion) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _planeacionRepository.eliminarPlaneacion(idPlaneacion);
      await cargarPlaneaciones();
    } catch (e) {
      _errorMessage = 'Error al eliminar planeación: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> buscarPorNombre(String nombre) async {
    _isLoading = true;
    notifyListeners();
    try {
      _planeaciones = await _planeacionRepository.buscarPlaneacionesPorNombre(nombre);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al buscar planeaciones: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
