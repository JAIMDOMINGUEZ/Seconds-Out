import 'package:flutter/material.dart';
import '../repositories/ejercicio_repository.dart';
import '/data/models/ejercicio.dart';


class EjercicioViewModel extends ChangeNotifier {
  final EjercicioRepository _repository;
  List<Ejercicio> _ejercicios = [];

  EjercicioViewModel(this._repository);

  List<Ejercicio> get ejercicios => _ejercicios;

  Future<void> cargarEjercicios() async {
    _ejercicios = await _repository.obtenerTodosLosEjercicios();
    notifyListeners();
  }

  Future<void> agregarEjercicio(Ejercicio ejercicio) async {
    await _repository.insertarEjercicio(ejercicio);
    await cargarEjercicios();
  }

  Future<void> eliminarEjercicio(int id) async {
    try {
      // 1. Eliminar en el backend (si aplica)
       await _repository.eliminarEjercicio(id);

      // 2. Actualizar la lista local
      _ejercicios.removeWhere((e) => e.id_ejercicio == id);

      // 3. Notificar a los listeners
      notifyListeners();
    } catch (e) {
      //_errorMessage = 'Error al eliminar ejercicio';
      notifyListeners();
      throw e;
    }
  }

  Future<void> actualizarEjercicio(Ejercicio ejercicio) async {
    try {
      final success = await _repository.actualizarEjercicio(ejercicio);
      if (success) {
        // Actualiza la lista local sin recargar toda la base de datos
        final index = _ejercicios.indexWhere((e) => e.id_ejercicio == ejercicio.id_ejercicio);
        if (index != -1) {
          _ejercicios[index] = ejercicio;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error en ViewModel al actualizar: $e');
      throw e;
    }
  }

  Future<void> buscarEjerciciosPorNombre(String nombre) async {
    _ejercicios = await _repository.buscarEjerciciosPorNombre(nombre);
    notifyListeners();
  }

  void limpiarBusqueda() async {
    await cargarEjercicios();
  }
}
