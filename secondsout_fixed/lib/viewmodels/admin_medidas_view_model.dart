// admin_medidas_view_model.dart
import 'package:flutter/foundation.dart';
import '../repositories/medidas_repository.dart';
import '../data/models/medidaantropometrica.dart';

class AdminMedidasViewModel extends ChangeNotifier {
  final MedidasRepository _repository;
  int? _atletaId;
  List<MedidaAntropometrica> _medidas = [];
  MedidaAntropometrica? _medidaMasReciente;
  bool _isLoading = false;
  String? _error;

  AdminMedidasViewModel(this._repository);

  // Getters públicos
  int? get atletaId => _atletaId;
  List<MedidaAntropometrica> get medidas => _medidas;
  MedidaAntropometrica? get medidaMasReciente => _medidaMasReciente;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Inicializa el ViewModel con el ID del atleta
  void inicializar(int atletaId) {
    _atletaId = atletaId;
    cargarMedidas();
    //obtenerMedidaMasReciente();

  }

  Future<void> cargarMedidas() async {

    if (_atletaId == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {

      _medidas = await _repository.obtenerMedidasPorAtleta(_atletaId!);


    } catch (e) {
      _error = 'Error cargando medidas: $e';

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> agregarMedida(MedidaAntropometrica medida) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.insertarMedida(medida);
      await cargarMedidas();
      return true;
    } catch (e) {
      _error = 'Error agregando medida: $e';
      notifyListeners();
      return false;
    }
  }

  Future<bool> actualizarMedida(MedidaAntropometrica medida) async {

    try {
      _isLoading = true;
      notifyListeners();

      await _repository.actualizarMedida(medida);
      await cargarMedidas();
      return true;
    } catch (e) {
      _error = 'Error actualizando medida: $e';
      print('Error actualizando medida: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> eliminarMedida(int idMedida) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _repository.eliminarMedida(idMedida);
      await cargarMedidas();
      return true;
    } catch (e) {
      _error = 'Error eliminando medida: $e';
      notifyListeners();
      return false;
    }
  }

  Future<void> obtenerMedidaMasReciente() async {
    if (_atletaId == null) {
      print('Error: atletaId es nulo al obtener medida más reciente');
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _medidaMasReciente = await _repository.obtenerMedidaMasReciente(_atletaId!);
      if (_medidaMasReciente == null) {
        print('No se encontró medida reciente para atleta $_atletaId');
      }
    } catch (e) {
      _error = 'Error obteniendo medida más reciente: $e';
      print('Error al obtener medida reciente: $e');
      _medidaMasReciente = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiarError() {
    _error = null;
    notifyListeners();
  }
}