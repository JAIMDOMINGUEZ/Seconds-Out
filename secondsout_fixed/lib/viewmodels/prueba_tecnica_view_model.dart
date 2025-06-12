import 'package:flutter/material.dart';
import '/repositories/prueba_tecnica_repository.dart';
import '/data/models/prueba_tecnica.dart';

class PruebasTecnicasViewModel with ChangeNotifier {
  final PruebasTecnicasRepository _repository;
  List<PruebaTecnica> _pruebas = [];
  bool _isLoading = false;
  String? _errorMessage;

  PruebasTecnicasViewModel(this._repository);

  List<PruebaTecnica> get pruebas => _pruebas;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Cargar pruebas de un atleta
  Future<void> cargarPruebas(int atletaId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _pruebas = await _repository.obtenerPruebasPorAtleta(atletaId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar las pruebas: ${e.toString()}';
      _pruebas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int?> agregarPrueba(DateTime fecha, int atletaId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final nuevaPrueba = PruebaTecnica(
        id_prueba: null,
        idAtleta: atletaId,
        fecha: fecha,
        puntajeTotal: 0,
      );

      // Aquí obtienes el id del insert
      final idInsertado = await _repository.agregarPrueba(nuevaPrueba);

      // Recarga la lista para actualizar UI
      await cargarPruebas(atletaId);

      return idInsertado;
    } catch (e) {
      _errorMessage = 'Error al agregar prueba: ${e.toString()}';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar una prueba existente
  Future<bool> actualizarPrueba(PruebaTecnica prueba) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.actualizarPrueba(prueba);
      await cargarPruebas(prueba.idAtleta); // Recargar la lista
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar prueba: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Eliminar una prueba
  Future<bool> eliminarPrueba(int idPrueba, int atletaId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.eliminarPrueba(idPrueba);
      await cargarPruebas(atletaId); // Recargar la lista
      return true;
    } catch (e) {
      _errorMessage = 'Error al eliminar prueba: ${e.toString()}';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Determinar si una prueba está completa
  bool esPruebaCompleta(PruebaTecnica prueba) {
    // Implementar lógica para verificar si todas las subpruebas están completas
    // Esto dependerá de tu estructura de datos específica
    return prueba.puntajeTotal > 0; // Ejemplo simplificado
  }

  // Limpiar mensajes de error
  void limpiarErrores() {
    _errorMessage = null;
    notifyListeners();
  }
}