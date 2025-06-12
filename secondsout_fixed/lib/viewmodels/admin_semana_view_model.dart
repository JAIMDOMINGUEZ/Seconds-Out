import 'package:flutter/foundation.dart';
import '/data/models/semana.dart';
import '../repositories/semana_repository.dart';

class SemanaViewModel with ChangeNotifier {
  final SemanaRepository _repository;

  SemanaViewModel(this._repository);

  List<Semana> _semanas = [];
  List<Semana> get semanas => _semanas;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Cargar semanas para una planeación específica
  Future<void> cargarSemanas(int idPlaneacion) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _semanas = await _repository.obtenerSemanasPorPlaneacion(idPlaneacion);
    } catch (e) {
      _errorMessage = 'Error al cargar semanas: ${e.toString()}';
      _semanas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Registrar una nueva semana
  Future<bool> registrarSemana(Semana semana) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final id = await _repository.insertarSemana(semana);
      if (id != null) {
        await cargarSemanas(semana.id_planeacion);
        return true;
      }
      _errorMessage = 'No se pudo registrar la semana';
      return false;
    } catch (e) {
      _errorMessage = 'Error al registrar semana: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar una semana existente
  Future<bool> actualizarSemana(Semana semana) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final rowsAffected = await _repository.actualizarSemana(semana);
      if (rowsAffected > 0) {
        await cargarSemanas(semana.id_planeacion);
        return true;
      }
      _errorMessage = 'No se pudo actualizar la semana';
      return false;
    } catch (e) {
      _errorMessage = 'Error al actualizar semana: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar una semana
  Future<bool> eliminarSemana(int idSemana) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final semana = await _repository.obtenerSemanaPorId(idSemana);
      if (semana == null) {
        _errorMessage = 'Semana no encontrada';
        return false;
      }

      final rowsAffected = await _repository.eliminarSemana(idSemana);
      if (rowsAffected > 0) {
        await cargarSemanas(semana.id_planeacion);
        return true;
      }
      _errorMessage = 'No se pudo eliminar la semana';
      return false;
    } catch (e) {
      _errorMessage = 'Error al eliminar semana: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpiar el estado
  void clear() {
    _semanas = [];
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }
}