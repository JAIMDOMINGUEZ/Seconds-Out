import 'package:flutter/material.dart';
import '/data/models/prueba_fisica.dart';
import '/repositories/prueba_fisica_repository.dart';

class PruebaFisicaViewModel extends ChangeNotifier {
  final PruebaFisicaRepository repository;

  List<PruebaFisica> _pruebas = [];
  bool _isLoading = false;

  List<PruebaFisica> get pruebas => _pruebas;
  bool get isLoading => _isLoading;

  PruebaFisicaViewModel({required this.repository});

  Future<void> cargarPruebas() async {
    _isLoading = true;
    notifyListeners();

    _pruebas = await repository.obtenerPruebas();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> guardarPrueba(PruebaFisica prueba) async {
    try {
      final existe = _pruebas.any((p) => p.id_prueba == prueba.id_prueba);

      if (existe) {
        await repository.actualizarPrueba(prueba);
      } else {
        await repository.insertarPrueba(prueba);
      }

      await cargarPruebas();
      return true;
    } catch (e) {
      print('Error guardando prueba: $e');
      return false;
    }
  }
}
